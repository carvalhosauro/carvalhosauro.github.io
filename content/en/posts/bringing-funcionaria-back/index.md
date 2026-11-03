---
title: "I'm bringing FuncionárIA back to life"
date: 2026-11-02
draft: true
postType: "aprendizado"
translationKey: "funcionaria-revival"
tags: ["product", "ai", "pigz", "funcionaria", "planning"]
description: "Few customers, almost nobody paying and nothing but bug fixes. Pigz's FuncionárIA was dead, and I took on bringing it back. Why it died, how I planned it, where I am and the number I'm still missing."
---

> Few customers since launch.
> Almost nobody paying.
> The last meaningful update, I can't even remember.

FuncionárIA is Pigz's AI for merchants. (The name is a pun: *funcionária* is Portuguese for "employee", with "IA" for AI.) The idea is mine, and I think this product is seriously good. But a product nobody uses and nobody improves is dead, even with the server still running.

What I learned trying to understand why it died: products don't die from bugs. They die when they stop hearing back from the world.

This post is the record of how I'm going to try to bring it back. I'm writing it now, halfway through, because three months from now I'll tell this story in a nicer way than it actually happened.

---

## How it died

FuncionárIA has two fronts. The **Seller**, which sells over WhatsApp, 100% conversational. And the **assistant**, which answers the merchant's questions about their own store.

My read is that the first stumble was price. Restaurants count margin to the cent, and the price was too high for someone who just wanted to try an AI.

After that, the loop closes by itself. Few customers, little feedback. No feedback, nobody knows what to improve. Not knowing what to improve, it never becomes a priority. And without priority, its history became a queue of fixes: bug fix, bug fix, bug fix. No new feature that changed anything for the merchant.

Every request it couldn't handle became a line in a JSON file nobody opened. FuncionárIA was asking what to do, and nobody was listening.

It had no owner. Nobody picked it up. So I did.

## Why I took it on

Pigz wants to bet more on AI, and I had a stalled product I knew could be much more.

But what really made me pick it up was a question. I looked at what the market does, and the pattern is clear: the copilot comes included in the plan. Toast IQ, Shopify Sidekick, iFood's Cris, free over WhatsApp for its partners. What gets charged is heavy or autonomous work.

So the question stopped being "how much do we charge for AI" and became: **how do you charge without the merchant's simple question feeling like a downgrade next to the competitor that gives it away?**

My bet, for now, is weighted credits. Every action spends credits, more complex actions spend more, and each chain gets a weekly balance large enough that someone who only asks questions never feels the limit. Whoever leans hard on the heavy work (custom reports, analysis, automatic alerts) hits the end, and that's when they upgrade. The basics never stop because of the heavy stuff.

And the reason to pay instead of using Cris for free can't be the AI itself. It has to be what it sees. Cris sees the iFood channel. FuncionárIA can see the whole operation: POS, tabs, cash register, own delivery, inventory.

It's still a hypothesis. The pilot exists to test exactly that.

## Start from the measured problem

A lot of how I put this plan together came from watching [Product Gurus](https://www.youtube.com/@productgurus). Two ideas from there became rules here: go first after what takes work off someone's plate, and ship a narrow slice to learn from real use instead of waiting for the full product.

The "someone", in this case, was support. I started by talking to the support team, and the same story kept coming up: merchants asking to change a price, pause an item, edit a description. Things they could do themselves, but asked for anyway.

Then I measured. I took two months of support conversations and sorted them by topic. More than one in ten was a merchant asking to change something in their store. Menu changes alone (price, pause, reactivate, add an item) were almost one in ten.

The detail that got me: these requests barely show up in tickets. They get solved on first contact and never escalate. If I had only looked at tickets, I would have concluded the problem didn't exist.

It's the same mistake that killed FuncionárIA, seen from the other side. The demand was there. It just wasn't where we were looking.

That gave me the first product decision, and the narrow slice: **FuncionárIA comes back by changing the menu through conversation**. The new page, the panel and everything else only ship together with that. Without it, it would be just another pretty chat screen.

## What it must never do

An AI changing a restaurant's live menu is a real risk. A wrong price is a loss the same day. So, before the goals, I wrote the anti-goals: the things that, if they happen, mean it went wrong even while "working".

- Changing the menu without the merchant seeing the before and after and clicking Confirm.
- The model executing anything. It only proposes. The API executes, from a proposal stored on the server.
- A change with no record of who confirmed it.
- Changing a field the merchant didn't ask to change.
- One store's data showing up for another.

And one rule for everything: numbers don't come from the LLM. The list of paused products, totals, revenue, all of it comes from the API. The model writes the sentence around it. If it puts in a number that isn't in the data, the sentence gets dropped.

That list caught things no test would. When FuncionárIA changed a product's price, the code reused an existing routine that keeps combos in sync. It looked right. Tests passed. The review agent is what caught it: that routine reactivated combos the merchant had paused. Nobody asked for that, and it wasn't recorded anywhere.

By the list, that broke two anti-goals at once. The decision was easy: the routine came out of FuncionárIA's path.

Every new idea goes through the same question, in this order: "does this break an anti-goal?" before "is this cool?".

## Fast without breaking the list

FuncionárIA died standing still. So the question I had to answer was: how do you move fast without breaking any anti-goal?

I took the plan to the CTO. I showed the prototype, the specs and what I wanted to do: ship in slices, with a pilot on real stores, instead of waiting for the whole package to be ready. He agreed.

What made that possible was the way of working. Every feature goes down the same path:

1. I talk with the AI until the idea becomes a spec, with goals, non-goals and anti-goals.
2. The spec becomes one plan per repository.
3. Subagents implement one task at a time.
4. An agent reviews each task before the next one starts. At the end, another reviews the whole branch.
5. I decide and commit.

That's how, in a little over ten days, eight specs came out, each with its plans. And it was step 4 that caught the combo being reactivated without anyone asking.

Care didn't disappear so I could move fast. It moved: out of the approval queue and into the anti-goal list and the review of every delivery.

## Where I am now

The first slice is in staging: FuncionárIA's own page, a pill at the top of every store screen and menu changes through conversation. Price for one product or many, pause, reactivate, name and description. Always with a preview, confirmation and undo.

The rest is designed and planned, and the order isn't by which feature is coolest. It's by which one makes it listen first.

First comes the **unmet request**. That JSON file nobody opened becomes a record with a topic and a per-store count, on a screen the team can triage. Then 👍 and 👎 on every answer, with a reason. And a record of usage and cost for every AI call, per store, with a weekly credit cap. That last one is already being built.

Only after that come creating products from the chat (even from just a photo), listing products, checking the store's configuration and, last, insights. Insights are the most expensive and the only place where a wrong number really hurts.

## What's pending

Two questions I still can't answer: **do merchants use it?** and **how much does it cost?**

That's what the pilot is for. A few dozen stores, in three profiles (delivery, dine-in and self-service, chains), for one or two weeks. Before it starts, I need to finish the cost record and the credit cap, and pick the stores.

## How far I want to take it

I'll be honest here: I haven't set a goal beyond what's in the specs.

I know what I want to see. Merchants solving on their own, by talking, what they ask support for today. Fewer "change the cheeseburger price for me" in the help inbox. More stores paying because they use it, not because they got a discount.

Turning that into a number and a deadline is something I'm still learning. The pilot will give me the baseline. Without it, any target I write here is a guess.

I don't even have the criterion for giving up yet. And that bothers me more than not having a goal, because the lack of one is exactly what let FuncionárIA die slowly the first time. Nobody looked and said "it's over". It just stopped.

So that's the first number I'll take from the pilot. Not the one for success. The one for giving up.

> The first time, it died without anyone noticing.
> If it dies again, it'll be with a number on the table.
