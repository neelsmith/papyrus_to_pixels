### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 4b42f990-c6a1-11ee-27ed-cd999e457180
md"""## Preparing to build a dictionary"""

# ╔═╡ 7e0a1ec2-d6a8-4b5c-a6f0-6071f7f6a458
md"""### A pattern: working with parallel lists of data

"""

# ╔═╡ 16e043df-9745-4c1c-b3b4-13e7b8e20d02
students = ["Bryce", "Connor",  "Emma", "Frank","Meredith", "Luke"]

# ╔═╡ 22219994-2c9d-4bce-8b27-160b70145128
groups = [6,5,6, 5,6,5]

# ╔═╡ 5775f791-cc25-43a2-9f35-909e3e9851b9
students[1]

# ╔═╡ bdd6e9a8-9c55-429f-8d52-2593a28a96cd
groups[1]

# ╔═╡ fba3a93f-931b-4c20-9994-cb9a7ed16c96
string(students[1], " is in  ", groups[1])

# ╔═╡ ea55bb25-522c-4a85-90ba-446793f2c82f
enumerate(students) |> collect

# ╔═╡ e32458e2-b7f6-4b73-90ba-2df173a120b0
md"""Not just a mapping: two data sets!"""

# ╔═╡ e6225504-d50e-494d-8326-00fccc0c64ee
function labelstudents(studentlist, grouplist)
	labels = []
	for (index, student) in enumerate(studentlist)
		label = string(student, " => ", grouplist[index])
		push!(labels, label)
	end
	labels
end

# ╔═╡ fa51fbbe-9b2e-4b60-8f80-c00b8ec56593
labelstudents( students, groups)

# ╔═╡ 7b0d576f-7164-454f-9822-091fa9aaf96c
xlabels = []


# ╔═╡ 790f9e10-650c-48bd-8b68-63863de93cf5
md"""### Manipulating vectors"""

# ╔═╡ dd0a8408-cea9-4e10-8ae6-dcd4f426fd08
"""Create a new vector by adding an item to an exising vector."""
function additem(vect, item)
	newlist = vcat(vect, [item])
	newlist
end

# ╔═╡ fe05e37c-8b09-4f7c-9e59-43d1b5d42b66
newstudents = additem(students, "Matt")

# ╔═╡ 3c61c424-8964-450a-9c14-13ed825ea253
newgroups = additem(groups, 3)

# ╔═╡ b6430ccd-b09d-42f7-aece-b2b48041bcb4


# ╔═╡ c13368ce-36cf-421d-b07e-e6c977c9e554
md"""### Building a dictionary"""

# ╔═╡ 15b6efba-b22c-4257-a02e-67d24472f18b
function indexlists(keylist, valueslist)
	dict = Dict()

	for (key, index) in enumerate(keylist)
		if haskey(dict, key)
			push!(dict[key], valueslist[index])
		else
			dict[key] = [valueslist[index]]
		end
	end
	dict
end

# ╔═╡ 39d40937-e85c-46a3-b59c-37bcee864bf5
indexlists(groups, students)

# ╔═╡ 5d939e07-90b6-46bb-aa37-8eea58d5585e


# ╔═╡ 01d4c0a7-6ac8-48dd-b11c-164567b5ceb0
md"""## A syntax note"""

# ╔═╡ 6cbdc467-070f-400c-be66-4367245de1cb
md"""Compose functions with pipe"""

# ╔═╡ ca4cb7ec-9329-46b0-be89-9efd6a449e20
groups

# ╔═╡ 8c338678-7896-4f6a-a40e-9cdcc7db67f3
groupset = unique(groups)

# ╔═╡ 9a17aa3c-6315-4771-8264-a645256a6725
length(groupset)

# ╔═╡ df3e5f66-f9ae-4c7a-b77d-3ab19d90615b
length(unique(groups))

# ╔═╡ e4061e0c-cb64-47c2-8536-c69755348e3a
unique(groups) |> length

# ╔═╡ Cell order:
# ╟─4b42f990-c6a1-11ee-27ed-cd999e457180
# ╟─7e0a1ec2-d6a8-4b5c-a6f0-6071f7f6a458
# ╠═16e043df-9745-4c1c-b3b4-13e7b8e20d02
# ╠═22219994-2c9d-4bce-8b27-160b70145128
# ╠═5775f791-cc25-43a2-9f35-909e3e9851b9
# ╠═bdd6e9a8-9c55-429f-8d52-2593a28a96cd
# ╠═fba3a93f-931b-4c20-9994-cb9a7ed16c96
# ╠═ea55bb25-522c-4a85-90ba-446793f2c82f
# ╠═e32458e2-b7f6-4b73-90ba-2df173a120b0
# ╠═e6225504-d50e-494d-8326-00fccc0c64ee
# ╠═fa51fbbe-9b2e-4b60-8f80-c00b8ec56593
# ╠═7b0d576f-7164-454f-9822-091fa9aaf96c
# ╟─790f9e10-650c-48bd-8b68-63863de93cf5
# ╠═dd0a8408-cea9-4e10-8ae6-dcd4f426fd08
# ╠═fe05e37c-8b09-4f7c-9e59-43d1b5d42b66
# ╠═3c61c424-8964-450a-9c14-13ed825ea253
# ╠═b6430ccd-b09d-42f7-aece-b2b48041bcb4
# ╟─c13368ce-36cf-421d-b07e-e6c977c9e554
# ╠═15b6efba-b22c-4257-a02e-67d24472f18b
# ╠═39d40937-e85c-46a3-b59c-37bcee864bf5
# ╠═5d939e07-90b6-46bb-aa37-8eea58d5585e
# ╟─01d4c0a7-6ac8-48dd-b11c-164567b5ceb0
# ╟─6cbdc467-070f-400c-be66-4367245de1cb
# ╠═ca4cb7ec-9329-46b0-be89-9efd6a449e20
# ╠═8c338678-7896-4f6a-a40e-9cdcc7db67f3
# ╠═9a17aa3c-6315-4771-8264-a645256a6725
# ╠═df3e5f66-f9ae-4c7a-b77d-3ab19d90615b
# ╠═e4061e0c-cb64-47c2-8536-c69755348e3a
