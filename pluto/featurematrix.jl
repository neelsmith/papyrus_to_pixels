### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 72e4c43c-9bee-11ee-3343-99f776f74115
md"""# 2D matrices for features in Julia"""

# ╔═╡ 41bebee1-fc3a-4ff1-8fc1-7e30e1f19422
md"""
### Model

- individuals are *rows*
- features are *columns*
- values are `Bool`s (simple presence/absence of feature)
"""

# ╔═╡ 3b544242-2bcb-426c-b5e5-0773079c83bd
md"""### Made-up, trivial example

- 3 features: "has wings", "flies", "swims"
- 3 individuals: belong to species penguin, shark, dodo
"""

# ╔═╡ 84117809-d01b-443b-926d-764bade0400f
md"""### Method 1: record by column/feature"""

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
matrix1 = hcat(wings, flies, swims)

# ╔═╡ 206689bb-92d0-48f3-90ac-7a41ff36c885
md"""!!! tip "Syntax note!"
    Each parameter to `hcat` is a list (Vector); you can directly pass any number of comma-separated parameters.
"""

# ╔═╡ c9c0f093-962d-4113-be26-9d89f84c4993
md"""### Method 2: record by row/individual"""

# ╔═╡ aed59cb2-161a-4b20-9a9b-886c3b19ae77
md"""The order of our features is has wings, flies, swims:"""

# ╔═╡ 04d6c5f4-53c5-45bb-b467-c0d578ebbcaf
penguin = [true, false, true]

# ╔═╡ 43a12168-af4a-4ab3-b868-2d6f687cd4c3
shark = [false, false, true]

# ╔═╡ 41a66fe9-e5fb-4911-b2bd-5d8cce43ebeb
dodo = [true, true, false]

# ╔═╡ ff3dcbbe-3e81-45ea-9634-e8ce54e3e61b
md"""The `stack` function "stacks" a list of rows together vertically to get a matrix:"""

# ╔═╡ 68e70305-0a5f-4fdc-b9f6-8a01f748634f
matrix2 = stack([penguin, shark, dodo])

# ╔═╡ 82e4cc99-fd01-4638-9a13-53572b4ab16d
md"""!!! tip "Syntax note!"
    Pass a single parameter to `stack`: a list of lists (Vector of Vector). Notice that the previous cell puts `penguin`, `shark` and `dodo` in a Vector that is the sole parameter to `stack`.
"""

# ╔═╡ 367d1356-4a01-48d5-8cd1-01ec505957e5
md"""### Both methods work!"""

# ╔═╡ ecb54c48-e2a3-4de4-b600-2888bc7ce86c
md"""The results are the same:"""

# ╔═╡ 4ec9a484-3329-4cac-a104-e05fa899e9ad
matrix1 == matrix2

# ╔═╡ Cell order:
# ╟─72e4c43c-9bee-11ee-3343-99f776f74115
# ╟─41bebee1-fc3a-4ff1-8fc1-7e30e1f19422
# ╟─3b544242-2bcb-426c-b5e5-0773079c83bd
# ╟─84117809-d01b-443b-926d-764bade0400f
# ╟─19d3b207-683c-47f0-bfce-e5aae8a42863
# ╟─212ee21b-7ae4-4368-bf62-335ec799046b
# ╟─f12e591f-49ae-45fc-9c5c-fdb4aa0570ca
# ╟─3e4e9a54-64bc-4d99-a8c9-0fa04cfc965b
# ╟─e88bb63a-2794-4e91-b356-bc9d24c2d0bd
# ╠═1c87fae3-3375-46a9-8c05-12aa8754d338
# ╟─206689bb-92d0-48f3-90ac-7a41ff36c885
# ╟─c9c0f093-962d-4113-be26-9d89f84c4993
# ╟─aed59cb2-161a-4b20-9a9b-886c3b19ae77
# ╟─04d6c5f4-53c5-45bb-b467-c0d578ebbcaf
# ╟─43a12168-af4a-4ab3-b868-2d6f687cd4c3
# ╟─41a66fe9-e5fb-4911-b2bd-5d8cce43ebeb
# ╟─ff3dcbbe-3e81-45ea-9634-e8ce54e3e61b
# ╠═68e70305-0a5f-4fdc-b9f6-8a01f748634f
# ╟─82e4cc99-fd01-4638-9a13-53572b4ab16d
# ╟─367d1356-4a01-48d5-8cd1-01ec505957e5
# ╟─ecb54c48-e2a3-4de4-b600-2888bc7ce86c
# ╠═4ec9a484-3329-4cac-a104-e05fa899e9ad
