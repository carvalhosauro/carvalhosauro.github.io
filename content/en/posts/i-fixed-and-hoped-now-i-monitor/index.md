---
title: "I fixed and hoped. Now I monitor."
date: 2026-07-08
draft: false
postType: "aprendizado"
translationKey: "eu-corrigia-e-torcia-agora-monitoro"
tags: ["data", "observability", "monitoring", "ai", "grafana"]
description: "A customer checking every penny taught me what no passing test ever teaches: only production data sees what nobody imagined."
---

> For a long time, my bug-fix workflow ended at deploy.
> I'd ship the fix, cross my fingers, and move to the next task.
> Today it ends somewhere else: in the data that proves it worked.

Mid-June 2026. A customer reported something that makes any dev's stomach drop: the cash in hand didn't match what the system showed. And this wasn't just any customer — they were the type who checks every penny. They didn't want an apology. They wanted to understand **where the money went**.

It's not a 500 error in a log, not a misaligned button. It's money. And money diverging is the fastest way to destroy a customer's trust in your system.

That case solidified a shift I'd been building slowly: putting data analysis and monitoring into my workflow — not as an end-of-sprint extra task, but as part of the work itself. And it's exactly this that AI's speed has made everyone ignore, including me.

The thesis of this text is simple: **production data is the only thing that sees what nobody imagined**. And because of that, it has two uses that are really just one — **diagnosis**, when something breaks and data reveals the truth that code hides, and **monitoring**, when you look at that same data continuously to ensure it stays fixed. They're not two tools. They're the same data, viewed at two moments. I'll tell you a story from each moment.

It's not a Grafana tutorial or an MCP review. It's the story of how I stopped crossing my fingers and started paying attention.

## Crossing fingers: the deploy as finish line

Let me start with the uncomfortable part: for a long time, my bug-fix workflow was fix and hope.

I'd ship the fix, glance at it, and move to the next task. Sometimes I *thought* I'd fixed it — and I hadn't. I didn't have (and I'll be honest: I'm still building) the habit of actively monitoring whether the problem was actually solved in production. For me, the deploy was the finish line. What happened after it was future me's problem — or the support team's.

And before anyone blames AI for that: no. That's always been dev laziness. Mine, especially.

What AI did was **industrialize** that laziness. If I used to deliver X fixes a week without checking a single one, now I deliver 3X — without checking any of them. AI removed almost every friction point from development: writing code got fast, refactoring got fast, understanding someone else's code got fast. The only friction it didn't remove was verification. And when everything speeds up except one step, that's the step you skip first.

The irony is that the same AI that industrializes guesswork turned out to be the best tool I've ever had to kill it. But that realization only came with the money case.

---

## The money case: when data revealed what code hid

Back to the customer. The stage was a **post-closing screen**: at the end of the shift, it consolidated the movement so the operator could verify it. Except this screen counted sales and receivables on store credit — and nothing else. What it didn't count: the **cash drop**, which is the removal of physical cash from the register mid-shift (to avoid keeping too much in the drawer, to pay a supplier at the door, the reasons vary). The system allowed registering the cash drop. It just didn't deduct it on this screen.

Result: the system showed **more** cash than actually existed in the drawer. On this customer's account, the accumulated difference was close to about a thousand reais (~$200) in roughly two weeks. For someone who checks every penny, that's not rounding — it's a hole.

The investigation went like this: I used AI to read the code and reconstruct the business rules of the financial flow, validating each understanding with me. In parallel, it consulted the customer's actual values in the database through an MCP I'd built myself (it gets its own section just below). Code on one side, production data on the other — and the gap between them pointed the way. It took about two days. In my old workflow — DBeaver open, SQL by hand, cross-referencing query results with manual code reading of legacy code — I honestly can't imagine how long it would take. I just know it wouldn't be two days.

And why hadn't anyone seen it before? Because it was legacy code, and the screen's description didn't make it explicit that only sales came in. Over time, it became what all legacy becomes: devs themselves *thought* the system deducted the cash drops. We allowed the operation, after all. The "bug" wasn't a bug. It was a modeling gap: the code was doing exactly what it was told to do; the problem was that nobody had told it to account for part of reality.

And that's the central point of this text: **no amount of careful code review would find this problem**. The code was "correct." All the devs "knew" how the screen worked — and we were wrong. What revealed the gap was the data.

I'll be honest about the ending: we didn't rebuild the flow. It wasn't a priority then, and other work came first. What we did was clarify to the customer exactly what happened — an exchange of messages and a detailed report with the numbers on the table. And that, by itself, was enough to hold their trust — which was what was at stake. The data didn't become a feature; it became an answer. Sometimes that's all the customer needs: to understand.

The experienced dev's classic objection: *"why investigate data? Write a regression test so it doesn't happen again."* And that's where the money case closes the argument. A test only catches what **someone thought to test**. Nobody thought of the cash drop — so no test, however complete, would cover that case. A passing test doesn't prove reality is correct; it only proves that what you *imagined* still works. The gap wasn't in what we imagined: it was exactly in what nobody imagined. And only one thing sees what nobody imagined — production data.

---

## How I let AI look at my production database

I promised to come back to the MCP. There are ready-made MCPs for databases, but I didn't want AI to be able to make changes, insertions, or deletions in production — so I built my own, read-only by design, with guardrails at two levels.

In the application, every query goes through validation that blocks anything that isn't read-only (there's a Python library that does exactly this). And in the database, AI uses a read-only user with a timeout. The number of connections and accessible tables are also limited. Beyond that, I wanted traceability: I implemented logging by user, so I know exactly **who** ran **which** query.

If the question in your head is "am I going to let an AI loose on my production database?", the answer is: no. You let it look, through the keyhole you built, and you write down everything it looked at.

---

## Friction: why I never really monitored

After the money case, the obvious question: if data is so powerful, why didn't I monitor? The honest answer isn't "lack of discipline." It's **friction**.

Checking a fix in my old workflow meant: open DBeaver, remember (or rewrite) the SQL, run it, and interpret the result in a table of rows and columns. Every check was a small project. And checking that requires a small project doesn't survive a startup's routine.

Compare that to: open a dashboard.

That's it. The difference between monitoring that *happens* and monitoring you *intended* to do is the friction between you and the data. The lower the friction to do something, the higher the chance it becomes a habit.

So I invested in that. And I won't romanticize it: I work at a startup, nobody has spare time. Building dashboards, constructing MCPs, configuring logs — all of that competed with customer work. What let me do it was a mix of learning to say no, delegating some responsibilities, and accepting that this extra effort was an investment, not a distraction.

The real cost: the dashboard was built with Grafana. Setting up Grafana and plugging in the connectors (the data sources) took just over a week. Building the dashboard itself, after that, was about 3 hours — and many tokens. Compared to what I got in return, every minute was worth it.

That's when the question I asked after deploy changed:

> I stopped asking:
> "did it work?"
>
> And started asking:
> "where can I **see** that it worked?"

---

## The closed loop: seeing instead of guessing

The return on investment came quick, in a concrete case: the menu update, an asynchronous flow that ran with an average of **10 minutes**, with spikes of 20 to 60.

Before optimizing anything, I needed two answers: was the bottleneck real or just my impression? And if it was real, where exactly was it? In my old workflow, I would have guessed — probably optimized the wrong place, the way we usually optimize by instinct. This time, I built the dashboard before touching the code.

What it shows: how many messages arrive in the queue, how many are processed, and — the metric that matters — **the age of the oldest message waiting**. It answered the first question in black and white: the 10-minute average was real, and the spikes of up to an hour weren't anecdotal — they happened regularly. The bottleneck stopped being a suspicion and became a fact before I wrote a line of fix.

But the dashboard didn't answer the second question. It shows the symptom, not the cause — we don't have tracing yet. The **where** came from reading the code: it was legacy code piling N+1 on top of N+1 and blocking I/O operations running in sequence. Notice it's the same pair from the money case: **the data says it hurts; the code says where it hurts**. Neither one alone closes the diagnosis.

The fix was less glamorous than the result — eager loading to kill the N+1s, I/O operations running concurrently, and tuning how we processed messages from SQS. With I/O running in parallel, the total time fell to roughly the slowest operation.

After the fix, I didn't need to build anything new to know if it worked: it was the same dashboard. The average dropped from 10 to about **3 minutes**; the spikes, from up to an hour to less than **6**.

![Grafana dashboard for the menu-update flow: age of the oldest message in the queue, before and after the optimization deploy](./grafana-cardapio.webp)

The graph tells the story by itself: left of the deploy, red spikes over half an hour; right of it, green — and it never went back. I don't *think* I optimized it. I **see** how much I optimized it.

And here the thesis closes: the tool I used to *diagnose* the problem is exactly the one I use to *monitor* that it stays fixed. Diagnosis and monitoring aren't two tools — they're the same data, viewed at two moments.

That's the closed loop: code → production → evidence. Before, my loop ended at deploy. Now it ends in the data.

And that's where the investment paid off — but not in a metric I can put in a spreadsheet. It paid off in **peace of mind**. One less worry, one more certainty. The calm I feel after shipping something to production increased a lot. It's not that I started delivering faster or saving X hours a week; it's that the anxiety of "did I break something?" was replaced by a place where I simply *look* and see. For me, that ROI was worth more than any number.

---

## What stuck — and what's missing

Let me be exact about the size of the win I'm selling: the menu deploy was a week ago. In the first two days, with the fix still fresh, I monitored constantly. Now I open it casually — I look for a spike, don't find one, I close it. This still isn't a consolidated habit; it's a habit being tested. Writing this text, making it public, is part of the bet: it costs more to quit.

And there's a crack in this story I won't hide. The dashboard reduced the friction of *looking at* the data — but it doesn't solve *remembering* to look. Today my monitoring is *pull*: I'm the one who opens the dashboard, when I remember. And that depends on the same discipline I admitted at the start I don't have in abundance. If the menu flow regresses in month three, who warns me? Nobody. The dashboard doesn't yell — it waits for me to show up. I haven't solved that yet, and I won't pretend I have.

The hypothesis to solve it is known: alerts, with their channels. Moving from *pull* to *push* — data coming to me when something goes wrong. But with a caution I've learned from watching environments that got this wrong: if everything beeps, nothing beeps. Too many alerts become noise, and we learn to ignore noise. The dashboard was the step; the well-calibrated alert is the next bet — and for now that's all it is: a bet.

About data access: I know it depends on the company's size and maturity. I like transparency — but start with operational data, which nobody will deny you. Queue latency isn't anyone's secret.

So here's the question, and answer honestly: **what was the last task that, after hitting production, you actually cared whether it was working and whether customers were using it?**

If the answer is "none" or an awkward silence — why not do it now? Look in your system. Write a query to check the volume. Don't have database access? Ask the support team if the problem went away.

Monitoring what you ship is also your responsibility. This story started with a customer checking, penny by penny, what my system showed. What changed is that now I check before they do. I still cross my fingers — but only after looking at the dashboard.
