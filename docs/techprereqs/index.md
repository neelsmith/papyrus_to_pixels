---
title: "Preparing to work with Julia"
parent: "Resources for working with Julia"
layout: page
nav_order: 5
has_children: true
---


# Preparing to work with Julia


## 1. Installing Julia


One reason that Julia is an appealing language is that it is easy to install, and runs in many different environments.


- Download Julia [here](https://julialang.org/downloads/)
- Follow these instructions to install Julia:
    - [installing Julia on Windows](https://julialang.org/downloads/platform/#windows)
    - [installing Julia on Mac OS](https://julialang.org/downloads/platform/#macos)
    - [installing Julia on Linux](https://julialang.org/downloads/platform/#linux_and_freebsd)

Throughout the semester, we will stress the importance of defining tests before we write code: how can we know if our code is functioning correctly?

To test whether you have installed Julia correctly, try to open a julia terminal (or REPL, for "Read-Evaluate-Print-Loop").  You should see something like this:

![img](../../imgs/julia-REPL.png)
    
If you do, great!  At the `julia>` prompt, enter `exit()` to quit the REPL.




## 2. Setting up Pluto notebooks

For much of our course work, we will use [Pluto](https://plutojl.org/), a reactive notebook system written in Julia. 

To prepare your computer to use Pluto:

1. open a Julia REPL, and type `]` to enter "package mode."
2. at the `pkg` prompt, enter `add Pluto`. It will take a while to download and build all of the Julia packages that Pluto uses, but you won't have to repeat this.
3. When you are done, use the Delete key to return to Julia mode.  You may now work in Julia or use `exit()` to quit.

To run Pluto:

1. open a Julia REPL if you have not already.
2. at the `julia` prompt, enter `using Pluto; Pluto.run()`. This will start a Pluto notebook server on your computer, and open your default web browser when everything is ready. When you're through, enter `Ctl-C` (the control key + `c`) at the Julia prompt to stop the server.  This will put you back at the `julia` prompt in your REPL.  You may continue to work in Julia or use `exit()` to quit.




