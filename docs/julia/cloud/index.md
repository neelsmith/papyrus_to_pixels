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