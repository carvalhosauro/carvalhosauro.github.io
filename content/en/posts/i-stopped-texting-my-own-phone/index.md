---
title: "I stopped texting my own phone"
date: 2026-10-01
draft: false
postType: "aprendizado"
translationKey: "whelx"
tags: ["whatsapp", "testing", "ai", "agents", "open-source", "whelx"]
description: "Testing a WhatsApp integration meant a Meta app, a WABA, a real number and hoping the webhook arrived. I used floci, thought \"why not for WhatsApp?\", and two days later whelx existed. On day one it found a bug that dropped 124 of 229 messages in a campaign."
---

> I used to test WhatsApp bots by texting "hi" to my own phone.
> And hoping the webhook arrived.
> That's not testing. That's a ritual.

If you've ever integrated with the WhatsApp Cloud API, you know the routine. Create an app on Meta, grab a test number, start ngrok, set up the webhook, text yourself and stare at the log. If it arrived, great. If it didn't, you don't know whether the problem is your code, the tunnel, the token or Meta.

For a chat screen, you can live with that. For campaign infrastructure, you can't.

---

## The red tape that blocked testing

At Pigz we were evolving our campaign dispatch infrastructure. High-volume sends, many stores, each with its own WhatsApp Business account (a WABA) and its own numbers.

To test that for real I would need:

- several WABAs, with real or test customer numbers;
- a **second Meta app just for testing**, because each app gets exactly one webhook. Point it at my environment and production stops receiving;
- the nerve to send in volume without burning a real number.

And to trigger a specific error? A closed 24-hour window (`131047`) means waiting 24 hours. The 80 messages per second per number limit (`130429`) means sending more than 80 messages per second from a real number and hoping Meta doesn't flag it.

Nobody tests like that. What happens in practice is you test the happy path, a bit by hand, and the rest goes to production on faith. I wanted autonomy: test whatever I wanted, as many times as I wanted, without asking anyone for a number or opening a ticket with Meta.

## The spark

Shortly before that I had come across [floci](https://github.com/floci-io/floci). It does for AWS what LocalStack does: runs SQS, Lambda and friends on your machine. The campaign dispatch lambda already ran entirely on top of it, FIFO queue, DLQ and all, without touching AWS.

But the lambda talked to Meta. And for Meta I had a hand-written mock that answered based on the last digits of the phone number: ends in 0400, return 400; ends in 0429, return 429. It worked. Or I thought it did.

Then came the obvious question: if I can have all of AWS on my laptop, why not WhatsApp?

Two days later [whelx](https://github.com/carvalhosauro/whelx) existed.

---

## What whelx is

A faithful local copy of the WhatsApp Cloud API. Same endpoints, same JSON, same error codes. Your app swaps `https://graph.facebook.com` for `http://localhost:4000` and can't tell the difference.

```bash
docker run -p 4000:4000 ghcr.io/carvalhosauro/whelx
```

What's inside, in short:

- **Real signed webhooks** (`X-Hub-Signature-256`), with retries and a record of every delivery.
- **Statuses** `sent → delivered → read → failed` in Meta's current format.
- **Real errors on demand**: `130429`, `131047`, `132001`, `131056`. The 24-hour window expires with one click.
- **The 80 msg/s per number limit**, emulated: send 200 requests, 80 go through and 120 come back as `130429`.
- **A WhatsApp Web style chat** where *you* are the customer. Text, audio, location, buttons, lists, an order card with Pix. Every message has an inspector with its JSON and the webhooks it produced.
- **Deterministic chaos**: dropped, duplicated, out-of-order webhooks, seeded. Same seed, same result.
- **An MCP server**, so a coding agent can play the customer.

Anything it doesn't emulate yet returns an error with `whelx: not supported`. Never a silent success. That was a design decision, and the reason is right below.

---

## What it found on day one

I put the whole stack on my laptop: the Pigz API running on the production image, the dispatch lambda on floci, and whelx in Meta's place. I fired a campaign end to end and left the agent running, measuring and reading the logs.

**124 of 229 recipients were lost.**

The reason: the function that classified Meta's response only looked at the HTTP status. But Meta sends throughput errors, `130429` per number, `80007` per WABA and `4` per app, as **HTTP 400**, not 429. So every rate limit became a permanent failure. No backoff, no slowing down, no retry. The recipient just vanished from the campaign.

And my hand-written mock? It returned 429 to simulate rate limiting. In other words, the mock agreed with the bug. It was written with the same wrong assumption as the code, so both passed together. Green tests, broken campaign.

I wrote about this [in the previous post](/en/posts/a-pretty-screen-is-not-a-finished-feature/): tools lie quietly, and green proves nothing. A hand-written mock is the sneakiest version of that, because it tests what you *think* the service does. If you're wrong about the service, the mock is wrong in exactly the same way.

Twenty minutes later the second one showed up. The app and WABA limits, which last from minutes to an hour, were falling into the same retry path as the per-number limit. The result: up to 8 workers making 4 attempts each, dragging the campaign down to 5 messages per second, only to defer anyway. Now the first hit hands the batch back to the queue and that's it.

Both bugs were headed for production. Nobody would see them in manual testing, because nobody sends 229 messages by hand. They would have shown up as "the campaign didn't reach half the list", and someone would spend days trying to figure out why.

---

## Agents in a loop: the real reason

All of that would make it just a useful testing tool. What got me hooked was something else.

A coding agent can read, write and test almost everything in your system. It spins the database up in a container. Queues, now, with floci. The piece that was always left over was the external service. Payments, WhatsApp, email. That's where the agent stopped and handed it back to you: "test it on your phone and tell me what happened".

With a local simulator, that wall goes away. The agent:

1. plays the customer and sends a message;
2. waits for the bot's reply (no `sleep`, there's a wait endpoint);
3. answers, taps a button, changes its mind halfway through;
4. turns chaos on, repeats, compares;
5. reads the code, fixes it, runs everything again.

No cost per conversation, no risk of a flagged number, no 24-hour wait. It can loop all afternoon, and the worst that happens is I wipe whelx's database.

The repo ships an example sales bot to show this. I asked Claude, through whelx's MCP, to play three customers: one who buys a pizza with a drink, one who asks a question mid-order and one who gives up at the drink upsell. It ran and came back with this:

> The happy path works. The funnel breaks when the customer types a question mid-order: the bot treats any text other than the greeting as unknown, resets the cart and sends the menu again. Daniel loses his four-cheese pizza.

The agent used three tools: send a message as a contact, tap an option and wait. Nobody texted their own phone.

## Simulating the world is the new testing

I'm not saying anything new. LocalStack has been around for years. What changed is who's doing the testing.

Before, a local simulator was a convenience for the developer. Now it's what lets an agent work on its own. Every external service you can run on your laptop is a part of the system the agent can test without calling you. And every part it can't is where you become the bottleneck.

That's why I keep hunting for these tools. floci for AWS, whelx for WhatsApp. And the rule I hold any simulator to, including my own: **faithful or nothing**. A simulator that makes up the service's behavior is just a more expensive mock, and I just told you what a mock does to you.

---

## Where the math doesn't add up

- whelx doesn't replace the final test against Meta. It's faithful to what's documented and to what I've seen in production. Meta changes, and it will lag behind.
- Not everything is emulated. When something isn't, it says so with an error instead of faking success, but saying so isn't covering it.
- The UI and control API have no authentication. It's a local tool. Don't expose the port on a network you don't trust.
- It was built in two days, with AI. It has end-to-end tests and has already caught a real bug, but it's still young.

---

## Try it

If you have a bot or any WhatsApp integration, it takes two minutes:

```bash
docker run -p 4000:4000 ghcr.io/carvalhosauro/whelx
```

Point your app at `http://localhost:4000`, open the browser and say "hi". If you want your agent to test it for you:

```bash
claude mcp add --transport http whelx http://localhost:4000/_whelx/mcp
```

The code is at [github.com/carvalhosauro/whelx](https://github.com/carvalhosauro/whelx), MIT. If it saves you from texting yourself, leave a star. If it's wrong about some Meta behavior, open an issue. Fidelity is the only thing that matters in a simulator, and I'd rather know.
