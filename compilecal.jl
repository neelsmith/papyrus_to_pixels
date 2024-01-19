using Pkg
Pkg.activate(".")
Pkg.instantiate()
using CourseCalendar

calfile = joinpath(pwd(), "S24", "calendar.toml")
topics = joinpath(pwd(), "S24", "topics.txt")
sched = courseSchedule(calfile, topics)

md = mdcalendar(sched)

hdg = """---
title: "Daily schedule"
layout: page
nav_order: 1
has_children: true
---

## Daily schedule

Deadlines to note:

- 📓 Lab notebook or other written assignment due
- 🔛 Sections meet separately: CLAS 199 in Fenwick 415

"""

open(joinpath(pwd(), "docs", "schedule", "index.md"), "w") do io
    write(io, hdg * md)
end