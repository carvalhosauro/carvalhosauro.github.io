---
title: "I thought it was the tool. It was always me."
date: 2026-06-21
draft: false
postType: "aprendizado"
translationKey: "sempre-fui-eu"
tags: ["ai", "tools", "process", "career"]
description: "In just over a year, I switched AI tools some six times. Each one felt like the definitive turning point. The only thing that needed to change was me."
---

> In just over a year, I switched AI tools some six times. Each one felt like the definitive turning point. The only thing that, in the end, needed to change was me.

January 2025. I was an intern, and AI was just one more tab in my browser. I'd open ChatGPT, ask, copy the code snippet, paste it into the project, and hope it worked. When it worked, it felt like magic. When it didn't, I'd ask for another answer, paste it again, and hope a little harder.

Looking back, it's almost absurd to compare that workflow with today's. These days I write far less code by hand and I've never felt so productive. But it took me a while to understand one thing: the tools got a lot better — and that's exactly what laid the bottleneck bare. When the tool was weak, it was the limit. When it got good, only one thing was left limiting me: me.

That was an idea I was slow to accept. It hurt to admit that the bottleneck was me. At each phase, I'd switch tools thinking the previous one was the limit — Copilot, Cursor, Antigravity, Mythos. Each seemed to explain why I still wasn't as good as I wanted to be. For a while, I refused to face the most uncomfortable hypothesis: maybe it was just a *skill issue*. Maybe, with the tool already good enough, the only bottleneck left was my process.

This text isn't a review of tools. It's the story of how I figured that out — getting excited, falling on my face, studying and maturing, one phase at a time. And each phase taught me a piece of the same skill: thinking about the problem before asking, giving context, questioning whether the solution is really the best one, validating the result, and — the hardest part — knowing what **not** to delegate.

## The map of the journey

It wasn't a straight line. It was a sequence of states of mind, and whatever tool I was using at the time was just the backdrop:

- **Innocence** — ChatGPT: AI in a browser tab.
- **Excitement** — Copilot, Windsurf, and Cursor: AI inside the editor.
- **Scale** — Antigravity: agents at volume, subsidized by the company.
- **Obsession** — Claude Max: orchestration with `tmux`, hooks, skills, and MCPs.
- **The fall** — Mythos: the most advanced model of the moment.
- **Maturity** — now.

## Innocence: "it worked once" isn't "it's right"

Back then, I had a simple yardstick for knowing whether a piece of code was done: if it looked right and passed the test I ran — one test, the happy path — then it was solved. It never occurred to me to ask what would happen outside that happy path.

And, by that yardstick, ChatGPT was incredible. It saved me a ton on DTOs, for example. I'd always forget a validation, or get stuck on which one to use, and it would sort that out in a fraction of the time it would've taken me alone. For that kind of thing, the gain was real and immediate.

The problem is that the same yardstick that sped me up also left me blind. One day, I asked it for a SQL query to fetch transactions by a specific field. I pasted it, it worked in my test, I moved on. What I didn't tell it — because it never even crossed my mind that it mattered — was what sat on the other side: a transactions table with more than 30 million rows, a `WHERE` on a column with no index and no pagination whatsoever. In practice, a full scan of the entire table on every call, on a heavily used route. In my test, with little data, it was blazing fast. Days later, with the real volume, the database's CPU hit the ceiling and it went down.

It hurt. And the worst part is that it was my fault. Not ChatGPT's, not the query's — mine. I had asked for the wrong thing, without giving the context that mattered — the size of the table, the frequency of the call — and I had validated too little. I was an intern, yes, but that doesn't change the diagnosis: the tool did exactly what I asked. I was the one who didn't know how to ask, or how to check.

It was the first crack in the idea that having the answer was enough. AI gave me speed, but speed on top of a bad request only carried me into the hole faster. What was missing wasn't in the model. It was in me.

## Excitement: AI changed places, and the friction dropped

Then came the Copilot hype. Everyone was talking about it and I didn't want to be left out — except I couldn't afford it. I went looking for a free alternative and landed on Windsurf. It was my first taste of having AI inside the editor, and the difference was one of place: it had left the browser tab and moved into where the work actually happened. The friction dropped, and I thought it was brilliant.

It clicked on a not-very-important task: I was adding some extra security and business-rule validations. There were several permission functions — `temAcesso`, `pode` this, `pode` that — that didn't exist yet and I had to create. I wrote the first two by hand. From the third on, autocomplete was already filling them in on its own: it had caught the pattern and predicted what I was going to write before I wrote it. It was my first "pseudo flow-state." It felt like the tool was reading my mind.

Until, in that same task, I needed a loop with a rule slightly different from the previous one. And autocomplete suggested with the old thinking — it repeated the earlier pattern, ignoring that the intent had changed. That's when it became clear what it was: autocomplete on steroids. Brilliant at repetition, blind to a change of intent. It saw the open file, but not the project, and much less what I was actually trying to do.

That's when I understood the difference between being in the right place and understanding the problem. Windsurf had killed the friction — I no longer had to switch windows, explain everything from scratch, come back. But reducing friction isn't understanding context. I was still the only one who saw the whole project. And I started to want an AI that saw it with me.

## Cursor: when I thought the credit belonged to the tool

I started watching Lucas Montano's videos talking about some tool called Cursor and I was blown away. The tool wrote, refactored, pulled context from the project, and did it all with absurd ease. Once again, I refused to be left out. I subscribed on January 12, 2026, for three months. It was the US$ 20 plan, which came to about R$ 120 — I thought it was outrageous: it was the first time I'd be paying to work.

Most of the time, I was an okay user. I'd think of a feature, describe the classes, the patterns, the names, and the AI would write far faster than I would by hand. It was already a huge gain, and it reinforced my belief at the time: if I described the solution well, my work was practically done — the rest was up to the tool.

But there was one task that, looking back, was different from all the others. We needed to cut costs with the Google Maps API. The idea was to stop calling the API all the time and build an internal address-lookup engine, because we'd already recorded the addresses that most orders came from. If the data already exists, you don't need to pay to fetch it again.

And what I did, almost without realizing it, was process. I researched how to solve it. I brainstormed with the AI in search of the best approach, explaining the case, the constraints, and the rules. I validated it with the team before writing a single line. I drew a diagram of how it would work and what the entities would be. Only after all of that did I hand it to the AI — and it implemented it too fast. I just tested it. It was the first task I remember nailing completely.

At the time, I gave all the credit to Cursor. "Look how good this tool is." Today I see the opposite: what made it work wasn't Cursor, it was the research, the brainstorm, the validation with the team, the diagram. Cursor just quickly typed what I had already thought through carefully. And where I skipped the process, it made me pay — I didn't write unit tests and had to make up for it with a mountain of manual testing.

It was the first glimpse of what would become my way of working. Except I didn't notice. I still thought the credit belonged to the tool, and that the next one, smarter, would be the real turning point. It didn't help that the plan's limit ran out too fast: I used it with fear, only when I had something very well defined, so as not to waste tokens for nothing. And while I was worrying, there were devs at the company who didn't have to worry about that.

## Antigravity: too much scale, too little care

Two more senior developers got access to the Google Ultra plan to run a pilot and validate whether it was worth it. I was stunned. I remember things we'd always wanted to do that kept getting pushed off, because they were too laborious or for lack of time. With AI — especially with Claude Opus 4.5 available in Antigravity — those things started to get off the ground.

I'd ask: how did you do that? How long did it take? How much did it cost? When I found out they had a massive quota, renewing every five hours, I got envious. It was so much power in hand. And my belief at the time fit into one sentence: what would unlock me was scale. With enough quota and agents, I'd deliver more.

Some time later the subsidy reached me and other devs. It was incredible. I'd open several tabs, each with an agent handling a different part. I canceled Cursor on the spot — I had a new toy. And the funniest part is how quickly you get used to it: a delivery volume that would have seemed absurd before became the new normal. That's where the danger lies. When the bar rises, you forget how far off the curve it still is, and you start to trust too much.

It was on a delivery for a new type of order that the bill came due. I didn't have that much time for that project, but I was working on a part of the code I knew well — it was all in my head. So I delegated heavily: it was almost just writing, citing examples, and explaining how to follow the pattern. The quality wasn't the best, but it was good enough for the deadline. In the end, the code only exists because of the product, and the customer who pays for it.

The problem is that, this time, I delegated more than typing — I delegated pieces of architecture. And the bugs came. To hunt them down, I used even more AI, and I caught myself slightly lost in my own code: I knew roughly where the problem was, but not exactly what it was. That's the price of delegating the thinking along with the work. Under volume, I had traded the care I'd taken on the address engine for pure speed. I had more power and more responsibility — and less control.

I still tried to blame the tool. Watching Montano use Claude Code, I decided to configure Antigravity the same way. Except I went and tuned my tool expecting it to be a different one — and I came away more frustrated than if I'd done something simple and decent. Antigravity had quota to spare and was powerful, but I treated it as if it were Claude Code. The frustration wasn't just that it was a bit blind. It was, again, wrong expectations on my part. But by that point an idea had already stuck: if it was Claude Code that Montano used, maybe it was time to stop improvising and go straight to the source.

## Claude Code Pro: the right tool, used the wrong way

I subscribed to Claude Code Pro, the US$ 20 plan, on March 30. And I did what seems obvious in hindsight, but was so me at the time: I used it expecting everything to come ready-made. I didn't stop to understand the tool, I didn't configure anything, I didn't study how to improve the workflow. I just used it.

There's something that might be distorting this memory: I was — and still am — very biased by Montano, and I admire this tool far too much, the one I use for almost everything today. So it's hard to say whether I actually performed better at the start, or whether part of that is affectionate memory. Distrusting your own enchantment is annoying, but it's necessary.

Setting the enchantment aside, there was still a real difference compared to Antigravity, and it was in the effort Claude Code put into understanding what I was asking. It took a little longer, but it saw exactly the points I was leaving ambiguous — instead of guessing and moving on, it pushed back on my lack of clarity. Deep down, it handed me back my own problem: when I asked badly, it showed me that I'd asked badly.

It was in this phase too that I discovered how good it is at hunting bugs. It even found some of the ones I'd left behind in the Antigravity task — the ones I knew roughly where they were, but not exactly what they were.

The problem was still the quota. I used it sparingly, afraid of spending, trying to make each interaction count. I had the right tool in my hands and still treated it as a luxury item — without ever stopping to build a way of working on top of it. That only changed a little later, when I started splitting a Max 20x account with a coworker. That's when things got serious.

## Claude Max with Emerson: when I stopped asking which tool is better

In the first few weeks, Emerson and I used Claude Code relentlessly. I lived with multiple agents running in parallel — since I use `tmux`, it was common to have several tabs open, each handling a different part. Even so, by the end of the week, we didn't even hit 50% of the quota.

I was indignant. Anthropic was profiting off me and I was leaving money on the table. I decided to change that. Except that, trying to use it more, I discovered the opposite of what I expected: the gain didn't come from using it more. It came from using it better. And "better," for me, still had no process behind it whatsoever.

I owe a lot to Emerson. Every day he'd bring a video, a reading, a conversation about AI — and that's seriously awesome. He's the one who did the most to level up my skill and my prompting. A good tool helps, but talking daily with someone who's also testing, failing, and refining accelerates you in a way no quota can buy. A good part of what I know today came out of those exchanges.

It was in this phase that I started to build a way of working that held up: an agent orchestrator, skills that use different models, hooks to load the right skill at the right time, more MCPs and, over time, my own MCPs. It wasn't a grand plan. It was one piece at a time.

An example of how that exchange turned into practice: on a task that joined WhatsApp with a real-time chat, we had no idea where to start. It was Emerson who showed me the `superpowers` plugin, and we started using it mainly to write the action plans and drive the implementation with sub-agents. After a long brainstorm session with the AI, just to get it off the ground, the result was wild: we started on a Friday or a Saturday and, by Monday, it was already in staging. It wasn't perfect code or perfect architecture — but it fit the scenario we were in and met expectations. I'll never forget how fast and insane that was. And it wasn't the process alone or the tool alone: it was the right tool unlocking a process that, by hand, I wouldn't have been able to run.

From the outside, it might have looked like I had a mega setup and knew a lot. The truth is I didn't. I was just improving one piece at a time. And maybe that's the most important lesson of the whole journey: the workflow gets better when you understand how you work and apply AI to specific parts — not when you try to automate your entire life all at once.

It was also when the question that guided everything finally changed:

> My workflow started to change when I stopped asking: "which tool is better?"
>
> And started asking: "which part of my work does this tool improve?"

## Mythos: the model that let me stop thinking

Then came Mythos, Anthropic's most advanced model at that moment. For debugging, it was different from anything I'd used: it found things other models didn't find — and, worse, things I hadn't even thought to look for.

It clicked on a side project, on the day I delegated 100% of the reasoning to it. I gave a generic prompt, the lazy kind, and the result was wild: it pointed out all the ambiguous points, the missing business rules, the fragile snippets. Everything I should have thought about before asking, and didn't, it thought for me. It was more autonomous and more incisive than anything I'd seen.

And that was exactly where the poison lay. The addiction wasn't speed — it was getting to stop thinking. I only had to answer what it asked me. For the first time, the tool didn't demand my process: it replaced it. I went into a frenzy and used it for everything. In three days, our weekly quota hit 91%.

Then, on the day the reset should have happened, came the announcement: Mythos would be blocked for non-Americans. A bucket of cold water. But what hurt wasn't really losing the tool — it was what its absence revealed.

It clicked for good when I ran into a hard take from Akita. The idea was roughly this: Mythos and Opus are more alike than the hype made it seem, and in many cases Opus is even better. You can reach the same result with both — the difference is that, with Opus, you have to put more effort into prompting, into structure, and into reasoning. You can't outsource the thinking.

It was a punch. Because it meant Mythos had never made me better. It had only let me skip the hard part — which was precisely my part. I did my job as a software engineer: I questioned Akita, I questioned Montano and, above all, I questioned what I'd done all that time. The conclusion was uncomfortable: I'd spent too much time enchanted with tools and too little structuring process. Without Mythos, I realized I'd unlearned how to think on my own for a few days. And that's when I went back to the beginning of this story — because, deep down, it was always a skill issue.

## What stuck

Today I consider myself a more mature user. Not because I know everything — but because, for the first time, I have a process, and it's almost the opposite of that intern who copied, pasted, and hoped. And yes, I was just an intern turning junior — maybe that's why the bottleneck was so obviously me. But I suspect it holds at any level: the ceiling is always the person, it just changes height.

When I pick up a task, I usually have two or three tabs open in `tmux`, but I don't start with any of them. I start by thinking: what needs to be done and how I would do it. Only then do I open a brainstorm with Claude Code to give context — the task, the goal, the constraints, and how I imagine the solution. Then I ask it for alternatives, to check whether the path I thought of is really the best one. With that, I put together an action plan, review it and, if needed, refine it. Only when the plan is standing do I let the AI implement in automatic mode — and I come back when it's "done," to review and polish.

Notice what I don't delegate: the rules, the goals, and the definition of done. That's my role, and it's the one piece I won't outsource for anything. The AI writes, investigates, suggests — but the one who decides what's "right" is me. That was the lesson that cost me the whole journey: you can delegate the doing, never the deciding. The rule I wish I'd had at the start is more practical than that: delegate what you can verify; don't delegate what defines what's "right." If you can't tell whether the output is right, there's nothing to outsource — there's something to learn.

And the most concrete sign that this became real work isn't a pretty prompt. It's what I build. Today I keep an MCP hooked up to the company's database that has helped me insanely with debugging — because not every error is in the code; a lot of the time it's a value in the database that doesn't add up. I'm refining it to put it on a server for the whole team to use, from dev to product, since AI has become everyone's tool here.

Looking back, there's a nice irony in this. I started this story taking down the database with a query I didn't understand. Today, I build a tool to see that same database before it goes down. The database is the same. The one who changed was me.
