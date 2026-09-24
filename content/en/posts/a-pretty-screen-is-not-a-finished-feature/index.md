---
title: "A pretty screen is not a finished feature"
date: 2026-09-24
draft: false
postType: "aprendizado"
translationKey: "nao-e-so-tela-bonita"
tags: ["react-native", "mobile", "ios", "performance", "tech-debt", "ai"]
description: "My first feature in a React Native app, a stack I didn't know, and a hunt for freezes in a point-of-sale system. Both times the screen looked great and the tests were green. Both times it froze in the user's hands."
---

> I used to treat performance as dessert.
> First make it work, then, if there was time left, make it fast.
> There was never time left. And the customer never waited.

I'll start with the sentence I wish someone had told me a few years ago: **if it freezes on the customer's machine, it doesn't work**. It doesn't matter if it passed review, if the tests are green, if it matches the Figma pixel for pixel. The customer doesn't open your code. They open the screen, tap, and wait. If it doesn't respond, to them the system is broken, and they're right.

Over the last few weeks I got hit by this from two sides at once.

On one side, my first feature in the company's App. React Native, a stack I had never shipped to production. On the other, Gestão, the system that sits on the store counter, freezing in stores that get close to a thousand orders in a few hours. Freezing on decent computers, not on potatoes.

Two different subjects, same lesson. This is not a tutorial on anything. It's the story of someone who left their own little box and found out the pretty screen was the easy part.

---

## The App: iOS doesn't care that you're new to the stack

The feature was order reviews. The order arrives, the app asks how it went. Stars, a little face that changes with the rating, some tags to pick, a required comment when the rating is low, a thank-you at the end. In Figma, a screen and a half. On the branch, around 120 commits in ten days.

And most of those commits are not screen.

### The keyboard that ate the button

On Android, when the keyboard opens, the screen shrinks and the "Send review" button moves up with it. I tested on Android, it worked, and I moved on.

Not on iOS. The keyboard opened on top of the button. The user wrote the whole comment and had no way to send it. A beautiful screen that wouldn't let you do the one thing it existed for.

I fixed the button, and then the comment field was the one hiding. I fixed the field, and the iOS return key decided to insert a line break instead of submitting. Every fix opened the next problem. None of it shows up when you test on a single device.

Then there was the build. An Xcode update simply stopped compiling the project, and a colleague is the one who unblocked it. I'm writing that down because it's true, and because it's exactly the kind of thing I don't have in my bones yet. And the iPhone 8, the weak device, which is exactly the one that matters for measuring, wouldn't even install through the normal path.

### Tools lie, and they lie quietly

This is what got me the most, coming from web and backend.

The project's type check finished with zero errors. Looks clean, right? It wasn't checking anything. It was broken and nobody had noticed, because silence looks like success. A mock in the tests behaved differently from the real library, so the test went down a path the real app never takes. And measuring performance in development mode gives you inflated numbers: on another delivery, we lost hours staring at numbers that meant nothing.

Three times in ten days green evidence lied to me. After the third, I stopped trusting green by default.

### Pretty and freezing

Here's the part that gives this post its name. The screen was pretty. And it froze.

Every letter the user typed in the comment made the app redraw the whole screen, stars included. On a weak phone, typing stuttered. On the store menu, toggling a filter froze the app for **almost half a second**, measured on the device. One tab fired 12 requests nobody asked for. The list fetched the same page three, four times when the user scrolled fast, and showed duplicate cards.

All fixed, and none of it is in the Figma. It's exactly what the user feels in their hand.

### How I measured without the device next to me

Being upfront about the method: I built on macOS, downloaded the profiling files, and brought them here to analyze with AI. Part of the diagnosis was reading profiles, part was reading code, and part, I confess, was gut feeling. One of the fixes went in that way, and the commit says in plain words that the gain still has to be confirmed in the field.

Writing in the commit what I did **not** measure became a rule.

---

## Gestão: a debt charging interest every 15 seconds

Meanwhile, at the counter.

The report was vague the way customer reports always are: "the screen stutters when an order comes in" and "every now and then it freezes, even when idle". Sounds minor until you picture the operator staring at a frozen screen in the middle of a rush. And in high-volume stores, close to a thousand orders in a shift, it froze even on a good computer.

The lazy answer was ready: "the customer's computer is weak". I've used that excuse before. This time I went and measured first.

### Measure before touching anything

I set up an environment that simulates a weak counter machine, with test stores of growing volume, from zero up to 1,800 orders. Nine rounds of measurement. No optimization went in without a before and after number.

If you optimize without measuring, you're just guessing with more confidence.

### The culprit wasn't the obvious one

The system was slow to open, and that's where everyone was looking. But what hurt the most at the counter was something much quieter.

Every 15 seconds, even with the screen idle, and on every new order, the system saved **the store's entire catalog and the entire order list** to the browser. Almost 2MB written at once, and while it was writing, the screen froze. All day long.

Technical debt in the most literal sense I've ever seen. Nobody made a mistake. When the system had little data, it made no difference. The system grew and the setting stayed there, charging interest every 15 seconds, from everyone.

The highest-impact fix of the whole project was **one line**: stop saving the catalog. What got written dropped from ~1.7MB to ~150KB.

One line. And a debt old as hell.

Then came the cleanup: the system loaded pretty much the whole app on the first screen, including screens the user would never open. There were 8MB of tutorial images embedded in the code, being read as if they were program. A loading animation burned CPU right at startup. Each of those went away.

### The cache that slowed things down

This is my favorite finding.

There was a cache for the order list, built precisely to make it open faster. I measured it. **With no cache at all, the list showed up 3.3 seconds faster.**

The cache that existed to speed things up was slowing them down, and nobody knew because nobody had measured. Everybody "knew" how it worked. It's the same hole I wrote about in the [post on monitoring](/en/posts/i-fixed-and-hoped-now-i-monitor/), just somewhere else.

### The thousand orders

For high-volume stores the problem was different: the screen rendered **every** order at once, even the ones that didn't fit on the monitor. With 1,800 orders, that was 54 thousand elements on screen. The fix was to draw only what's visible.

| with 1,800 orders | before | after |
|---|---|---|
| switch view | 127s | 0.3s |
| update one order | 8.9s | 0.15s |
| memory | 859MB | 358MB |

You read that right: **127 seconds** to switch views. On a simulated slow machine, yes. Still, that's two minutes of frozen screen because of one click.

Day to day, with around 300 orders, long freezes on an idle screen went from 52 in half a minute to zero.

There was also the idea of swapping the app's underlying technology to fix the slowness. The numbers say it wouldn't have helped. **The problem was software. Not hardware, and not the technology.** A faster machine only makes the freeze shorter.

---

## Where the math doesn't add up

It would be hypocritical to write a whole post about distrusting evidence and not show where mine is weak.

- The weak machine is simulated. I haven't run the same tests on a real counter computer yet, so every Gestão number is relative until I do.
- Memory barely dropped in day-to-day use. For it to really go down, the app has to load less stuff, and that's a big job, not a tweak.
- The longest test ran for about 20 minutes. A store shift is 12 hours. I haven't measured that yet.
- On the App, part of the diagnosis was gut feeling, and the iOS keyboard behavior can only be validated on a device.

None of this invalidates the rest. But whoever reads me deserves to know what's a number and what's a bet.

---

## And where AI fits in

Almost every commit in the mobile feature is co-authored by AI. The Gestão measurement environment, the nine rounds, reading the profiles: all done paired with AI.

Without it, I wouldn't have shipped a feature in a stack I didn't know in ten days, let alone run nine rounds of measurement at the same time. No point pretending otherwise.

But the AI didn't know what I wanted. I did. Every prompt had the problem, the metric that would prove the fix, what couldn't break, and what I had already ruled out. I didn't know React Native, but I knew what a screen freezing because it's doing too much looks like, and I knew how to compare before and after the right way. The AI translated the stack. The judgment stayed mine.

I've written about this [before](/en/posts/it-was-always-me/): the tool amplifies whoever is using it. Ask badly, and it hands you the mistake faster.

---

## Stop shipping half-baked work

And here I'm going to be harsher than usual.

Today, with AI, you can build pretty much anything. You just have to know how to ask. I shipped a feature in a stack I didn't know and ran nine rounds of measurement on a legacy system in the same few weeks. So I no longer accept, not even from myself, the feature that "works" but freezes, the screen that looks gorgeous in Figma and stutters on the customer's device, the "we'll optimize later".

I refuse to ship features that don't actually work. And actually working means working on the customer's machine, at the customer's volume, not on mine.

But there's a pattern I see a lot, and it's undeniable: devs accepting half-baked deliveries, or postponing forever. Both come from the same place. One ships without thinking, the other thinks so much it never ships. "What if it breaks another screen?", "what if the customer complains?", "what if there's a case we didn't foresee?". Meanwhile, the entire catalog kept getting saved again every 15 seconds. The fix was one line, and it sat there for who knows how long.

Endlessly thinking about the difficulties and the "what ifs" is the surest way to keep the system you work on a piece of shit. Start. Improve what you can improve today. Measure. Ship.

**If it breaks, fix it.**

Now, if you don't know whether your application is breaking or not, or if shipping the fix takes longer than writing the fix, then the problem is something else. It's not caution. It's incompetence. Without monitoring you can't see the error (I've told how I learned that [the hard way](/en/posts/i-fixed-and-hoped-now-i-monitor/)), and with a deploy slower than the fix, every fix becomes an event. In that scenario the fear of touching things makes sense, but what needs fixing is the process, and standing still fixes nothing. [Akita wrote about this this week](https://akitaonrails.com/2026/09/22/parem-de-inventar-desculpas-e-facam-mais-deploy-a-premissa-mudou/) (in Portuguese) better than I can: the premise has changed. Fixing got cheap. Pretending it's still expensive is a choice.

---

## So, broadening horizons

Learning React Native was the least of it. What I took from these weeks is that the same problem lives everywhere. On the phone, it's the keyboard covering the button and the stars stuttering while you type. At the counter, it's the screen freezing every 15 seconds to save a catalog nobody asked it to save. In neither case was the screen ugly, and in neither case was the test red.

If you still treat performance as something for later, like I did, try this: grab the weakest device your customer uses, build for production, and use your system the way they use it, at the volume they have. If it freezes, your feature isn't done. It's just pretty.

What stuck with me, on both sides, is a way of working: measure on the weakest device, in a production build, with the same state on both ends of the comparison. Confirm the test fails before the fix. And write down in plain words what hasn't been measured yet.
