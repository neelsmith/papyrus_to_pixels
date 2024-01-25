---
parent: "Resources for working with Julia"
title: "Using Pluto in the cloud"
layout: page
nav_order: 2
---


# Using Pluto in the cloud

## Binder


You can open any notebook file on binder, a free service that runs a virtual machine in the cloud (!). Here's how to do it from a notebook saved as a web page.

1. Open the web. Here's an example with [an almost empty notebook you can use for practice like a Julia REPL](./pseudorepl.html).
2. At the top right of the page, clicke the "Edit or run this notebook" button.
3. In the dialog that pops up, click the "binder"  button in the section labelled "In the cloud (experimental).

Binder will then build an entire virtual machine on the fly (!!), install Julia, start up a Pluto notebook server, and open your notebook!  That's amazing -- but not fast.  Once your notebook is open and running, however, it will run normally.


## JuliaHub

It is also possible to run Pluto notebooks on a hosted service at [JuliaHub](https://juliahub.com/ui/Notebooks). This is a commercial service but claims to give individuals 20 free hours of usage per calendar month, resetting the count to 0 monthly. The remote machines and Pluto servers are already running so unlike Binder your startup time is more or less instantaneous.  I'm exploring optoins for students to use JuliaHub for free for course work.