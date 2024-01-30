---
layout: page
title: "Working with collections of data"
parent: "Schedule"
nav_order: 3
---


# Working with collections of data

In our previous class, we discussed modelling different types of data. When we define a model, we're describing what one instance of that type of object looks like: for example, "a beetle has six legs", or perhaps it has a specific DNA sequence; perhaps a funerary oration always has a beginning, middle and end (Aristotle thought so), or always makes reference to the dead people being commemorated. But the power of modeling, especially when we work with digital material, is that it gives us a simplified view that we can effectively apply to *many* instances of a particular type of object, whether beetles or speeches.

In today's class, we'll introduce important structures in Julia for working with *collections* of data, and will emphasize two important ways to manipulate collections: *filtering* and *mapping*. 

By *filtering*, we mean *selecting some subset* of a collection. Filtering a collection could leave you as few as zero items, or as many as the original collections. If we filtered our class roster to keep only students younger than 10, we would have zero roster entries (an empty collection); if we filtered it to keep only students younger than 30, we would have the same number of entries as the original roster; if we filtered the roster to keep only sophomores, we would have a number of entries somewhere between those extremes.

By *mapping*, we mean *transforming every element* of a collection. If we had a class list that had entries for each student, and recorded their name and score on each of four labs (five total pieces of data for each student), we could *map* that to a list of names plus a total score on all the labs (only two pieces of data). Mapping always produces exactly the same number of items as the original collection. (We'll have a total score for every student in the class.)

> **Thought question**: Filtering and mapping are both *actions*: what kind of implementation do you think they might correspond to in Julia?


## Class preparation: review

Use [this Pluto notebook](https://neelsmith.github.io/papyrus_to_pixels/julia/julia-nouns-verbs.html) to review what we learned about the "nouns and verbs" of the Julia language. It's saved as a web page (HTML format), so you'll have to save it in notebook format (Pluto notebook with filename ending in `.jl`) and open that in Pluto. (If you need to review how to save or open Pluto notebooks, you can use [this page](https://neelsmith.github.io/papyrus_to_pixels/julia/pluto/) for help.)


## Class preparation: thinking about collections

In class today, we'll begin to work with collections of data, and learn how to filter and map them using Julia. Reread your model for rhetorical style, and think about whether we can implement your model as a collection of features that we can filter or map.



No written submission required.