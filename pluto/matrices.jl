### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 72e4c43c-9bee-11ee-3343-99f776f74115
md"""# Working with matrices"""

# ╔═╡ 19d3b207-683c-47f0-bfce-e5aae8a42863
md"""The order of our individuals is penguin, shark, dodo:"""

# ╔═╡ 212ee21b-7ae4-4368-bf62-335ec799046b
wings = [true, false, true]

# ╔═╡ f12e591f-49ae-45fc-9c5c-fdb4aa0570ca
flies = [false, false, true]

# ╔═╡ 3e4e9a54-64bc-4d99-a8c9-0fa04cfc965b
swims = [true, true, false]

# ╔═╡ e88bb63a-2794-4e91-b356-bc9d24c2d0bd
md"""The `hcat` function lets you concatenate columns *horizontally* (i.e., as rows) to get a matrix:"""

# ╔═╡ 1c87fae3-3375-46a9-8c05-12aa8754d338
featurematrix = hcat(wings, flies, swims)

# ╔═╡ 1a1da2f9-5174-45ec-ad67-33227e111891
md"""## So you've got a matrix...

What can you do with it?
"""

# ╔═╡ 09dc4528-7a5a-4b1a-ad85-8f57470da586
featurematrix

# ╔═╡ c5c6e7c5-9d51-4874-bc50-e9325f763123
md"""`length` finds the total number of cells in the matrix."""

# ╔═╡ ac23b18b-9b1b-494e-94e5-13ca81ced55f
featurematrix |> length

# ╔═╡ f8215fca-cb03-4e44-879f-c9c1e75301d8
md"""Mapping works exactly the same way it works with a 1-Dimensional Array (or Vector). The following cell transforms each boolean value into a string.  The result is a 3x3 matrix of string values."""

# ╔═╡ 9c1ad4be-4388-4d71-9187-29fb9dab15a0
map(featurematrix) do tf
	if tf 
		 "✅" 
	else
		 "❌"
	end
end

# ╔═╡ 70781a1d-5d70-4152-8019-62405cdb6a0e
md"""You can also `filter` matrices, but think about what that means: we're only keeping *some* of the elements of the original matrix, so we lose the dimensional structure. 

If we filter our feature matrix to keep only true values, for example, we get a Vector of boolean values, all of which are `true`.  This could be useful if, for example, you wanted to count how many often features are present in the matrix.

"""

# ╔═╡ ee92c9e9-d119-4605-baef-3301ad8ecd06
filter(feature -> feature, featurematrix)

# ╔═╡ 29562552-f684-4e86-a885-06c6ab38029f
md"""`ndims` finds the number of dimensions. Our feature matrix is a 2-dimensional matrix with 9 total cells."""

# ╔═╡ 69aec10f-fb9d-4094-977f-a8100b729ffd
featurematrix |> ndims

# ╔═╡ c00f7e95-6697-4224-b78d-e665a5d335d7
md"""`size` finds the size of each dimension.  Our 2-D matrix is 3 rows by 3 columns."""

# ╔═╡ 8000c26c-4250-4604-b1ed-2bc0b68bca2f
featurematrix |> size

# ╔═╡ b5206366-5a1d-4504-a7f5-4265274fa7c3
md"""Notice that `size` gives us a *group* of integers in parentheses.  This kind of group is called a *tuple* in Julia.  We can assign its output to a tuple of variable names."""

# ╔═╡ 1b30421e-a1b1-4912-abcb-5b49083f12c5
(rows, cols) = size(featurematrix)

# ╔═╡ 0a22746f-0824-46a2-bfbf-669ba92d3744
md"""Now we have handy variable for the number of rows and columns in our matrix."""

# ╔═╡ 61d85649-8525-4d62-bd50-b6ff624e58cb
rows

# ╔═╡ 9c2e0932-1ed1-4e3c-bbdc-2d8781a4f1eb
cols

# ╔═╡ 1501271c-e4c0-4b3f-8a41-889deff54db6
md"""Just as you can use indexing values in square brackets to refer elements of a Vector, you can use multiple comma-separated indexes to refer to an element of an array. `1,1` refers to row 1, column 1, for example."""

# ╔═╡ 47e49a06-6464-4f4d-8a17-7723afe0d2bd
featurematrix[1,1]

# ╔═╡ 0de119d4-6148-40e5-8961-583f64f52f78
md"""In Julia, a semicolon means "all values for that dimension." This cell finds all column values for row 1.  In effect, we've extracted row 1 from the matrix.
"""

# ╔═╡ e491841b-d99b-480f-9339-9a9cbdffe20e
featurematrix[1,:]

# ╔═╡ 3857e027-a776-44ed-8375-8bb989486c15
md"""Likewise this cell extracts column 2 from the matrix."""

# ╔═╡ ea96c50c-91c3-449c-aa96-fc6df149a697
featurematrix[:,2]

# ╔═╡ 85ea2362-746f-4350-b90d-8f477acfd0fb
md"""## From features matrix to similarity matrix"""

# ╔═╡ 894012eb-eb5c-4576-b5c8-855775709009
md"""You can nest for loops to look at value of a matrix."""

# ╔═╡ 4ba9f79d-0e9c-4e22-99b6-db98ed1b79f3
indexes_true = begin
	
end

# ╔═╡ 883a396b-e346-4a04-acb0-59240b5d4496
featurematrix[1,:]

# ╔═╡ ad839f21-b811-44f6-a4fd-473d763d98b9
"""Convert Boolean value to emoji."""
function emojifybool(tf::Bool)
	tf ? "✅" : "❌"
end

# ╔═╡ d90fe6e0-34e2-4594-9033-a5be1be82f4a
"""Compose a markdown table for matrix `m`, labelling rows and columns
using the lists of strings `rlabels` and `clabels`.  It's on you to make
sure you've got the right dimensions!
"""
function tablify(m, rlabels, clabels)
	formatline = repeat("| --- ", length(clabels) + 1) * " |"
	hdrline = join(vcat(["|  "], clabels), " | ") * " |"
	mdlines = [hdrline, formatline]

	(rows, columns) = size(m)
	for r in 1:rows
		current_row = [rlabels[r]]
		for c in 1:columns
			push!(current_row, emojifybool(m[CartesianIndex(r,c)]))
		end
		push!(mdlines, 
			string(join(current_row, " | "), 
			" | ")
		)
	end

	join(mdlines, "\n")
end

# ╔═╡ b005d922-a2f0-44cc-a25a-0a6e1a02c182
featurematrix |> size

# ╔═╡ 850a7831-2aaf-4cc6-a98a-fc6e01290c4b
rowlabels  = ["penguin", "shark", "dodo"]

# ╔═╡ 7ed29dcb-6ba2-46ce-9f75-7b190a0eb519
columnlabels = ["wings","flies","swims"]

# ╔═╡ 10ead651-85ad-4128-96c8-0d4797f274d9
vcat([""], columnlabels)

# ╔═╡ 68ed28d9-6830-47b1-beca-5c75d4c3ba9d
featurematrix

# ╔═╡ d80aecbc-eefa-4a46-b28b-113deb0b2994
featurematrix[CartesianIndex(2,3)]

# ╔═╡ 2bd2e44f-65c5-4dd6-a34a-28edbafbe295
md"""Maybe look at [https://www.geeksforgeeks.org/manipulating-matrices-in-julia/](https://www.geeksforgeeks.org/manipulating-matrices-in-julia/)"""

# ╔═╡ 4d275c83-5523-46a9-a9b1-c2ef6c559132
firstindex(featurematrix, 1)

# ╔═╡ 18129cc0-d4a5-4edf-928a-59e64adc997f
eachindex(featurematrix)

# ╔═╡ Cell order:
# ╟─72e4c43c-9bee-11ee-3343-99f776f74115
# ╟─19d3b207-683c-47f0-bfce-e5aae8a42863
# ╟─212ee21b-7ae4-4368-bf62-335ec799046b
# ╟─f12e591f-49ae-45fc-9c5c-fdb4aa0570ca
# ╟─3e4e9a54-64bc-4d99-a8c9-0fa04cfc965b
# ╟─e88bb63a-2794-4e91-b356-bc9d24c2d0bd
# ╠═1c87fae3-3375-46a9-8c05-12aa8754d338
# ╟─1a1da2f9-5174-45ec-ad67-33227e111891
# ╠═09dc4528-7a5a-4b1a-ad85-8f57470da586
# ╟─c5c6e7c5-9d51-4874-bc50-e9325f763123
# ╠═ac23b18b-9b1b-494e-94e5-13ca81ced55f
# ╟─f8215fca-cb03-4e44-879f-c9c1e75301d8
# ╠═9c1ad4be-4388-4d71-9187-29fb9dab15a0
# ╟─70781a1d-5d70-4152-8019-62405cdb6a0e
# ╠═ee92c9e9-d119-4605-baef-3301ad8ecd06
# ╟─29562552-f684-4e86-a885-06c6ab38029f
# ╠═69aec10f-fb9d-4094-977f-a8100b729ffd
# ╟─c00f7e95-6697-4224-b78d-e665a5d335d7
# ╟─8000c26c-4250-4604-b1ed-2bc0b68bca2f
# ╟─b5206366-5a1d-4504-a7f5-4265274fa7c3
# ╠═1b30421e-a1b1-4912-abcb-5b49083f12c5
# ╟─0a22746f-0824-46a2-bfbf-669ba92d3744
# ╠═61d85649-8525-4d62-bd50-b6ff624e58cb
# ╠═9c2e0932-1ed1-4e3c-bbdc-2d8781a4f1eb
# ╟─1501271c-e4c0-4b3f-8a41-889deff54db6
# ╠═47e49a06-6464-4f4d-8a17-7723afe0d2bd
# ╟─0de119d4-6148-40e5-8961-583f64f52f78
# ╠═e491841b-d99b-480f-9339-9a9cbdffe20e
# ╟─3857e027-a776-44ed-8375-8bb989486c15
# ╠═ea96c50c-91c3-449c-aa96-fc6df149a697
# ╟─85ea2362-746f-4350-b90d-8f477acfd0fb
# ╠═894012eb-eb5c-4576-b5c8-855775709009
# ╠═4ba9f79d-0e9c-4e22-99b6-db98ed1b79f3
# ╠═883a396b-e346-4a04-acb0-59240b5d4496
# ╠═d90fe6e0-34e2-4594-9033-a5be1be82f4a
# ╠═10ead651-85ad-4128-96c8-0d4797f274d9
# ╠═ad839f21-b811-44f6-a4fd-473d763d98b9
# ╠═b005d922-a2f0-44cc-a25a-0a6e1a02c182
# ╠═850a7831-2aaf-4cc6-a98a-fc6e01290c4b
# ╠═7ed29dcb-6ba2-46ce-9f75-7b190a0eb519
# ╠═68ed28d9-6830-47b1-beca-5c75d4c3ba9d
# ╠═d80aecbc-eefa-4a46-b28b-113deb0b2994
# ╟─2bd2e44f-65c5-4dd6-a34a-28edbafbe295
# ╠═4d275c83-5523-46a9-a9b1-c2ef6c559132
# ╠═18129cc0-d4a5-4edf-928a-59e64adc997f
