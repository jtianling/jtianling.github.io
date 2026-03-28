---
layout: post_en
title: "Spec Only, No Code: Perhaps This Will Become a New Way to Release Software"
date: 2026-03-14 21:52:56 +0800
comments: true
categories: Essay
published: true
tags:
- OpenAI
- Code Agent
- Software Engineering
- Open Source
- Spec
---

I recently came across [openai/symphony](https://github.com/openai/symphony), and my first reaction wasn't "I want to try this implementation" — it was "this release approach is interesting."

Because the first option in its README isn't teaching you how to install the official implementation. Instead, it directs you to build your own based on [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md). Of course, they also included an experimental Elixir reference implementation, but that's listed as the second option. This ordering itself is telling: what OpenAI really wants to convey first may not be a specific piece of code, but the design of the system.

I think this is worth noting. As code agents become increasingly capable, the "release" of some software in the future may not necessarily require a complete source code package. Instead, it could start with a sufficiently clear spec, letting everyone implement it in their own preferred language and runtime environment. Code will still exist, but it's starting to look more like an instance of the spec rather than the sole deliverable.

<!-- more -->

### Why I Find This Interesting

Previously, when we saw an open source project, the default understanding was: the source code in the repository is the product itself, and documentation merely helps you understand and use it. Even if a project had protocols, language standards, or design documents, those were usually supporting players.

But `Symphony` felt different to me this time. Its README puts "Option 1. Make your own" front and center, pointing to that lengthy `SPEC.md`. This isn't "if you're interested, you can also check out the design docs" — it's clearly positioning "implement it yourself based on this spec" as a first-class entry point.

This shift in posture is interesting because it implies a new premise: for some software, the act of "implementation" itself is becoming cheap — cheap enough that authors can now reasonably assume that readers don't necessarily have to use the official code and can instead bring the author's ideas into their own familiar tech stack.

Though admittedly, OpenAI also gets you to consume more tokens this way — killing two birds with one stone.

### Why This Is Starting to Work Today

I think the core variable is that code agents have gotten stronger.

A few years ago, "just implement it yourself based on the spec" would have sounded more like a joke. Because no matter how clearly a spec was written, there was still a massive amount of mechanical, tedious implementation work between document and working code. Many people didn't fail to understand the design — they simply didn't have the energy to fully realize it.

But things are different now. Especially for a project like `Symphony`, whose core value isn't some hard-to-replicate low-level algorithm, but rather a set of system boundary definitions and workflow designs: what's the problem, what's the goal, what are the core components, what's the domain model, how are in-repo contracts like `WORKFLOW.md` organized, how is configuration parsed, how do the agent runner and issue tracker coordinate. Once these things are written into a spec, the essential "structural skeleton" has been laid out.

The remaining code is often more like translating that skeleton into a particular language and engineering style. And "translation" is precisely what code agents are getting increasingly good at.

### This Is Different from Traditional "Standards"

Of course, "spec first, implementation second" isn't a new concept. Protocols, language standards, file format standards have always existed. But what I think is different this time is that it's not a mature ecosystem slowly distilling a standards document after years of evolution.

It's more like treating the spec as the primary deliverable from the very beginning.

And there's an additional premise that wasn't as strong before: the publisher can now reasonably assume that the reader has a capable enough coding agent nearby to quickly turn the spec into a working version. In other words, this spec isn't just targeting patient human engineers who read documentation — it's also targeting an implementation agent that can start working at any time.

This transforms "spec" from a static, archival document into a publication medium that can be directly executed upon.

### What I Think Might Emerge

I'm increasingly feeling that a certain class of software projects may genuinely move toward this "spec-first" release approach.

That is, the core content an author publishes would become:

- A sufficiently clear spec
- A document describing system boundaries and constraints / workflow prompts
- A set of tests or examples that can verify behavior
- Perhaps a reference implementation, but it wouldn't necessarily be the only implementation

Then on the user's end, it's no longer just "git clone and run it," but rather "hand the spec to my own agent and let it generate a version in my preferred language, framework, and deployment approach."

The benefits are significant.

First, different teams can more naturally align with their own tech stacks. Some want Elixir, some want Go, some want Rust, some just want to absorb the core ideas into their existing system — none of them need to be tightly bound to the official implementation.

Second, the author's focus shifts from "this specific code" to "this design." This way, a project's influence can sometimes actually be greater, because what others adopt isn't just a repository but the methodology behind it.

Third, for many tools in the agent era, the lifespan of a reference implementation may not matter as much as before. What truly endures may be the spec, the tests, and the workflow constraints; the actual code can be continually localized, rewritten, and replaced.

### Of Course, This Doesn't Suit All Software

That said, I don't think this path works everywhere.

If a project's core value lies in extremely detailed performance optimization, heavy engineering accumulation, or an interactive experience that's hard to fully describe in text, then a spec alone clearly isn't enough. There are also things like model weights, specific training results, and processed datasets that can't simply be "given a spec and rebuilt."

So the types of things most likely to go spec-first, I'd guess, are:

- Orchestration / workflow tools
- Protocol and service glue layers
- Systems where enterprises really just want to implement the ideas, not necessarily stick to the official implementation
- Infrastructure components that already emphasize contracts

Additionally, if specs are truly to become the primary deliverable, I think they'll need to be paired with more supporting materials — conformance tests, standard example inputs and outputs, and even implementation hints for agents. Otherwise, no matter how long the spec is, different implementations will easily drift apart.

### A Change I Find Quite Fresh

Linus Torvalds once said, "Talk is cheap, show me the code." That quote might not hold as well today. Because now, "code is cheap." As code agents mature, we may start seeing a different reality: the truly stable part isn't necessarily a particular piece of source code, but the spec behind it.

Source code becomes a momentary projection of the spec — it can be implemented in this language, reimplemented in that one; organized this way today, rewritten with a different framework tomorrow. As long as the spec and behavioral constraints remain, what the author truly wanted to express is still there.

If things really develop in this direction, then the very act of "releasing software" may look quite different from today. What gets released wouldn't just be code, but design, constraints, and a specification clear enough for an agent to continue producing code from.

I think this is quite interesting. `Symphony` is certainly far from the endpoint of this trend, and it still comes with a reference implementation. But at least it has brought something that previously didn't look like a "formal release approach" very naturally to the forefront.
