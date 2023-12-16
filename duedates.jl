using TOML
calfile = joinpath(pwd(), "S24", "calendar.toml")    
config = TOML.parsefile(calfile)

duedates = filter(pr -> occursin("due", pr[2]), config["fixedDates"])

function formatpair(pr)
    string("- ", pr[1], ": ", pr[2])
end

md = join(map(pr -> formatpair(pr), duedates), "\n")


hdg = """---
title: "Due dates"
layout: page
nav_order: 3
---

## Checklist of due dates



"""

open(joinpath(pwd(), "docs", "duedates", "index.md"), "w") do io
    write(io, hdg * md)
end