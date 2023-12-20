### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 7a90d749-6955-4e1b-8c50-3f2a8e023caa
md"""
*Notebook version*: **1.0.0**

*Version history*:

- **1.0.0**: initial release
"""

# ╔═╡ 72e4c43c-9bee-11ee-3343-99f776f74115
md"""# Modeling features with a 2-dimensional matrix

> *This notebook shows you two ways you can create a **feature matrix** in Julia.*
"""

# ╔═╡ 41bebee1-fc3a-4ff1-8fc1-7e30e1f19422
md"""
### The model

We'll create an artificially simple model recording three features for each individual. We'll create a 2-dimensional matrix that records the presence or absence of each feature for each individual as a true/false value.

We can represent that in Julia like this: 

- individuals are represented as *rows* of the matrix
- features are representd as *columns* of the matrix
- values of each cell of the matrix are `Bool`s (i.e., their only possible values are `true` or `false`)
"""

# ╔═╡ 3b544242-2bcb-426c-b5e5-0773079c83bd
md"""### Made-up, trivial example

Our made-up example will record three features for each individual: whether it has wings, whether it can fly and whether it swims.  We'll observe three indiviudals who happen to be a penguin, a shark and a dodo bird. To summarize, our matrix will have:

- 3 features: "has wings", "flies", "swims"
- 3 individuals: belong to species penguin, shark, dodo
"""

# ╔═╡ c9e47520-2745-4cf1-8cc0-1f6d5d8907d4
md"""We can equally record our observations feature by feature, or individual by individual. In Julia, the process will be very similar either way,"""

# ╔═╡ 84117809-d01b-443b-926d-764bade0400f
md"""### Method 1: record by column/feature"""

# ╔═╡ 19d3b207-683c-47f0-bfce-e5aae8a42863
md"""
To record our observations by column, we will create a simple Vector for each column. """

# ╔═╡ ce40bfd8-feb9-496f-9695-cb37d548c824
md"""We have to be sure to make our observations in **the same order of individuals** each time.  We'll use the sequence penguin, shark, dodo for our observations, so for the feature "has wings" we can record:"""

# ╔═╡ 212ee21b-7ae4-4368-bf62-335ec799046b
wings = [true, false, true]

# ╔═╡ b9365086-4817-4617-9251-7ea064d559bc
md"""We'll follow the same order for the features "can fly" and "swims"."""

# ╔═╡ f12e591f-49ae-45fc-9c5c-fdb4aa0570ca
flies = [false, false, true]

# ╔═╡ 3e4e9a54-64bc-4d99-a8c9-0fa04cfc965b
swims = [true, true, false]

# ╔═╡ e88bb63a-2794-4e91-b356-bc9d24c2d0bd
md"""Now we have three vectors, each representing one column of our feature matrix.

Julia's `hcat` function lets you concatenate columns *horizontally* (i.e., aligning their rows) to get a matrix.  You can include as many parameters to `hcat` as you want; each parameter should be the Vector for one column. In our example, the rsult is a 3x3 matrix (i.e., a matrix with 3 rows and 3 columns."""

# ╔═╡ 1c87fae3-3375-46a9-8c05-12aa8754d338
featurematrix = hcat(wings, flies, swims)

# ╔═╡ 206689bb-92d0-48f3-90ac-7a41ff36c885
md"""!!! tip "Syntax note"
    Each parameter to `hcat` is a list (Vector); you can directly pass any number of comma-separated parameters.
"""

# ╔═╡ c9c0f093-962d-4113-be26-9d89f84c4993
md"""### Method 2: record by row/individual

Alternatively, we could record our observations by individual. We'll create a simple Vector of values for each individual, and will similarly be careful to **record features in the same order**.  
"""

# ╔═╡ aed59cb2-161a-4b20-9a9b-886c3b19ae77
md"""We'll use the order "has wings", "can fly", and "swims" for our penguin:
"""

# ╔═╡ 04d6c5f4-53c5-45bb-b467-c0d578ebbcaf
penguin = [true, false, true]

# ╔═╡ 37f2b9fd-e87f-4210-98f1-df81ac591673
md"""And we'll use the same order for our other individuals."""

# ╔═╡ 43a12168-af4a-4ab3-b868-2d6f687cd4c3
shark = [false, false, true]

# ╔═╡ 41a66fe9-e5fb-4911-b2bd-5d8cce43ebeb
dodo = [true, true, false]

# ╔═╡ ff3dcbbe-3e81-45ea-9634-e8ce54e3e61b
md"""
We now have three Vectors, one for each row of our matrix.  You can use Julia's `stack` function to "stack" a list of rows together vertically in a matrix.

Note one difference in syntax between `hcat` and `stack`.  `stack` requires a single parameter, a list or Vector. We use square brackets to create a Vector of our three individuals, `penguin`, `shark` and `dodo` as the one parameter to `stack`. (Of course you could include any number of items in that single list.)

For our purposes, each element in the list we pass to `stack` is itself a Vector representing one individual (one row of the matrix).  
 
"""

# ╔═╡ 68e70305-0a5f-4fdc-b9f6-8a01f748634f
matrix2 = stack([penguin, shark, dodo])

# ╔═╡ 82e4cc99-fd01-4638-9a13-53572b4ab16d
md"""!!! tip "Syntax note"
    Pass a single parameter to `stack`: a list of lists (Vector of Vector). Notice that the previous cell puts `penguin`, `shark` and `dodo` in a Vector that is the sole parameter to `stack`.
"""

# ╔═╡ 367d1356-4a01-48d5-8cd1-01ec505957e5
md"""### Both methods work!"""

# ╔═╡ ecb54c48-e2a3-4de4-b600-2888bc7ce86c
md"""Whether we record our observations by row or by column, the end result is the same:"""

# ╔═╡ 4ec9a484-3329-4cac-a104-e05fa899e9ad
featurematrix == matrix2

# ╔═╡ 834cf28b-2757-41bc-98b5-53fec8aad3f0
html"""

<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ c6ef7ab6-0695-4f6c-a80a-29c72a0bac9d
md"""
---


> **Just for fun...**

"""

# ╔═╡ a7738887-489e-4c3a-bf63-7c4dc9cf9009
md"""
If you're curious about how the table displayed above is craeated, you can peek at the following cells.

The table is the output of a function defined below called `tablify`.  It takes a matrix, and lists of labels for row and column values, and [formats a table of those values in Markdown](https://www.markdownguide.org/extended-syntax/#tables).
"""

# ╔═╡ 2f5ea367-07d9-4e34-b29e-bbaafa69c033
md"""
We transform true/false values to the strings ✅  or ❌ with a simple functoin called `emojifybool`.
"""

# ╔═╡ ad839f21-b811-44f6-a4fd-473d763d98b9
"""Convert Boolean value to emoji."""
function emojifybool(tf::Bool)
	if tf 
		"✅" 
	else
		"❌"
	end
end

# ╔═╡ 92e7cc7c-53ba-4cdd-b9f0-f46cc65a9566
md"""You can `map` a matrix just as you do a Vector:"""

# ╔═╡ eab33ece-0606-4ec2-9176-079728edf538
stringfeatures = map(tf -> emojifybool(tf), featurematrix)

# ╔═╡ 210b88bf-899e-470b-8722-5ca43cb76d15
md"""We manually define labels for rows and columns."""

# ╔═╡ 45052da2-cee9-45b5-8908-858cd0dfb829
rowlabels = ["penguin", "shark","dodo"]

# ╔═╡ 7ed29dcb-6ba2-46ce-9f75-7b190a0eb519
columnlabels = ["wings","flies","swims"]

# ╔═╡ cf4f8736-754c-457d-a015-6a39fb8e3cfa
md"""

`tablify` uses a few Julia shorthands and conveniences to write the Markdown syntax for a table, but the core of the function is very simple.  It uses nested `for` loops to cycle through each row, and each column with a row.  It formats one row at a time as markdown, and builds up a Vector of string values, one for each row.  Finally it uses Julia's `join` function to join rows in a single string value, joining them together with a new-line character.

(You can learn about tables in markdown [here](https://www.markdownguide.org/extended-syntax/#tables).)
"""

# ╔═╡ d90fe6e0-34e2-4594-9033-a5be1be82f4a
"""Compose a markdown table for matrix `m`, labelling rows and columns
using the lists of strings `rlabels` and `clabels`.  It's up to you to make
sure you've got the right dimensions for those lists!
"""
function tablify(m, rlabels, clabels)
	formatline = repeat("| --- ", length(clabels) + 1) * " |"
	hdrline = join(vcat(["|  "], clabels), " | ") * " |"
	mdlines = [hdrline, formatline]

	(rows, columns) = size(m)
	for r in 1:rows
		current_row = [rlabels[r]]
		for c in 1:columns
			push!(current_row, m[r,c])
		end
		push!(mdlines, 
			string(join(current_row, " | "), 
			" | ")
		)
	end

	join(mdlines, "\n")
end

# ╔═╡ 682960fb-95fd-4c09-a2f2-97339a896815
tablify(stringfeatures, rowlabels, columnlabels) |> Markdown.parse

# ╔═╡ Cell order:
# ╟─7a90d749-6955-4e1b-8c50-3f2a8e023caa
# ╟─72e4c43c-9bee-11ee-3343-99f776f74115
# ╟─41bebee1-fc3a-4ff1-8fc1-7e30e1f19422
# ╟─3b544242-2bcb-426c-b5e5-0773079c83bd
# ╟─c9e47520-2745-4cf1-8cc0-1f6d5d8907d4
# ╟─84117809-d01b-443b-926d-764bade0400f
# ╟─19d3b207-683c-47f0-bfce-e5aae8a42863
# ╟─ce40bfd8-feb9-496f-9695-cb37d548c824
# ╟─212ee21b-7ae4-4368-bf62-335ec799046b
# ╟─b9365086-4817-4617-9251-7ea064d559bc
# ╟─f12e591f-49ae-45fc-9c5c-fdb4aa0570ca
# ╟─3e4e9a54-64bc-4d99-a8c9-0fa04cfc965b
# ╟─e88bb63a-2794-4e91-b356-bc9d24c2d0bd
# ╠═1c87fae3-3375-46a9-8c05-12aa8754d338
# ╟─206689bb-92d0-48f3-90ac-7a41ff36c885
# ╟─c9c0f093-962d-4113-be26-9d89f84c4993
# ╟─aed59cb2-161a-4b20-9a9b-886c3b19ae77
# ╟─04d6c5f4-53c5-45bb-b467-c0d578ebbcaf
# ╟─37f2b9fd-e87f-4210-98f1-df81ac591673
# ╟─43a12168-af4a-4ab3-b868-2d6f687cd4c3
# ╟─41a66fe9-e5fb-4911-b2bd-5d8cce43ebeb
# ╟─ff3dcbbe-3e81-45ea-9634-e8ce54e3e61b
# ╠═68e70305-0a5f-4fdc-b9f6-8a01f748634f
# ╟─82e4cc99-fd01-4638-9a13-53572b4ab16d
# ╟─367d1356-4a01-48d5-8cd1-01ec505957e5
# ╟─ecb54c48-e2a3-4de4-b600-2888bc7ce86c
# ╠═4ec9a484-3329-4cac-a104-e05fa899e9ad
# ╟─682960fb-95fd-4c09-a2f2-97339a896815
# ╟─834cf28b-2757-41bc-98b5-53fec8aad3f0
# ╟─c6ef7ab6-0695-4f6c-a80a-29c72a0bac9d
# ╟─a7738887-489e-4c3a-bf63-7c4dc9cf9009
# ╟─2f5ea367-07d9-4e34-b29e-bbaafa69c033
# ╠═ad839f21-b811-44f6-a4fd-473d763d98b9
# ╠═92e7cc7c-53ba-4cdd-b9f0-f46cc65a9566
# ╠═eab33ece-0606-4ec2-9176-079728edf538
# ╠═210b88bf-899e-470b-8722-5ca43cb76d15
# ╠═45052da2-cee9-45b5-8908-858cd0dfb829
# ╠═7ed29dcb-6ba2-46ce-9f75-7b190a0eb519
# ╟─cf4f8736-754c-457d-a015-6a39fb8e3cfa
# ╠═d90fe6e0-34e2-4594-9033-a5be1be82f4a
