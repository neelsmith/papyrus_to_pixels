---
layout: page
title: "Project workshop: developing a working plan"
parent: "Schedule"
nav_order: 22
---

# Project workshop: developing a working plan


## Background

In developing your projects, you will be writing code as well as writing English prose.  The two kinds of writing share many similarities. The process of writing will clarify your thinking about your topic: it's quite common to find when you first complete a draft that you understand the topic better than when you began, and are now ready to try to write a concise summary of your work, or a much clearer introductory paragraph.  Writing prose or code, your work will improve as you *rewrite*. Writing about developing software, the computer scientist Fred Brooks advises:

> In most projects, the first system built is barely usable...Hence plan to throw one away; you will, anyhow.

(Brooks, *The Mythical Man-Month*)

When you are writing prose, you can be pretty loose about how you treat sections of an early draft. A terrible paragraph might not advance your argument, but it won't prevent you or another reader from getting through it. In that respect, code is different. If you try to work on your whole project idea at once by just banging away at it, the odds are high that you will produce something that doesn't even get to the level of Brooks' "barely usable" first system, and will be hard to debug.

It's important to have a clear idea of what you are trying to do overall, and to break that down into small pieces that you can isolate, work on, and test separately. For example, in lab 4, you might define your goals in tokenization as isolating *lexical* tokens ("words"). You might then decide that to implement that, you want to eliminate all non-alphabetical characters. You might further decide to make your lexicon case-insensitive, and choose to implement that by making all characters lower case.  You could then work *separately* (perhaps sequentially) on the problems of eliminating non-alphabetic characters and converting characters to lower-case for a *single* "word", and testing that thoroughly. Separately, you could decide how to then separate single words from a longer text. At the end of all that, you might have a single function that takes one long string as a parameter, and produces a list of lexical tokens as its output.

But then you might want to refine your tokenizer. What if you wanted to eliminate proper names from your lexical list, so that your tokenizer gives you something like the *linguistic lexicon* of your text, without names? You might have to rethink your design. Depending on how you chose to identify proper names, you might decide to rewrite your tokenizer from the ground up -- the throw the first one away, as Brooks suggests.


## In class

Remember that your first draft of your project is due in one week. In today's class, your group will work on designing a plan to reach that milestone. You will:

1. review your project proposal and identify your project goal in one sentence
2. outline your ideas for implementation as a series of steps. As you write these down, think carefully about the sequence of steps you are planning.
3. annotate each step in your outline with a status note, on a scale like this:
    1. completely implemented and tested
    2. tests designed but implementation not passing
    3. we have a concrete plan but haven't started work on this step yet
    2. we don't know how to do this step, but we have an idea we can try
    1. we don't know how to do this step and need help
4. review your annotated outline.  Decide how to prioritize implementing each step. Which ones should you complete first? (The easiest, because then we can get them out of the way? The hardest, because they'll need the most time? Some particular step or steps because other steps depend on them and we can't proceed until they're done?)    

With this design in hand, your group will begin work on the highest priority step(s).  For each step you work on:

1. define how you will test whether your implementation is correct
2. try to implement, then test your work

Repeat the cycle of implementing and testing until you are satisfied.

## To submit today

Before leaving class today, submit your project outline as a plain-text file. Add it to your individual folder on the course Google drive with the name `{LASTNAME}-project-outline.txt`, replacing `{LASTNAME}` with your last name.