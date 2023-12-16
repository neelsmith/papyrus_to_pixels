using TOML
using Dates
calfile = joinpath(pwd(), "S24", "calendar.toml")    
config = TOML.parsefile(calfile)

duedates = filter(pr -> occursin("due", pr[2]), config["fixedDates"])

function formatpair(pr)
    evtdate = Date(pr[1])
    string("- ", Dates.monthname(evtdate), " ", Dates.day(evtdate), ": ", pr[2])
end

md = join(map(pr -> formatpair(pr), duedates), "\n")


hdg = """---
title: "Due dates"
layout: page
nav_order: 3
---

## Checklist of important due dates



"""

open(joinpath(pwd(), "docs", "duedates", "index.md"), "w") do io
    write(io, hdg * md)
end