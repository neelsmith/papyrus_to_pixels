### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 1dd13816-9b71-11ee-2a8a-ff9a75452653
md"""## Modelling species by features"""

# ╔═╡ db65b0fd-d5d6-4663-b576-45ae4d3ba96e
md"""### Option: define a `struct`"""

# ╔═╡ 4e2c77c1-1459-4e1d-884f-93143c2226ff
struct Critter
	feature1
	feature2
	feature3
end

# ╔═╡ e34dbd57-b275-4542-bb94-59e67cb2bc37
md"""Then make a vector of those..."""

# ╔═╡ 9fba7f94-1ca5-4f88-ba90-9eac80be17ad
critter1 = Critter("two wings", "unable to fly", "swims")

# ╔═╡ a9d17ac1-091c-4cb5-9286-b8e90fa69097
critter2 = Critter("two wings", "flies", "unable to swim")

# ╔═╡ adde81ff-f4fa-4f79-9e2a-724aabfd8956
crittercollection = [critter1, critter2]

# ╔═╡ c6857803-0345-47f2-92ce-170dea52ca06
md"""## Option just a matrix of values

"Feels" more Julian... and in any case is close to a lot of computation we'll be doing.

We're "close to the metal"

"""

# ╔═╡ 361680eb-b4d3-49ed-bca1-d973964dbb76
indiv1 = [1,0,1]

# ╔═╡ 820e2deb-7da4-4b30-8459-a484e5378894
indiv2 = [1,1,0]

# ╔═╡ 48f669f0-6d2d-4ea9-8a7d-e65da90c8c26
mtrx = [indiv1;  indiv2]

# ╔═╡ f9cad338-992b-409d-a7e6-25ddf49b31f3
# reshape

# ╔═╡ 304dd853-0d1a-42d1-9412-51f71e2e6ff1
mtrx |> typeof

# ╔═╡ Cell order:
# ╟─1dd13816-9b71-11ee-2a8a-ff9a75452653
# ╟─db65b0fd-d5d6-4663-b576-45ae4d3ba96e
# ╠═4e2c77c1-1459-4e1d-884f-93143c2226ff
# ╟─e34dbd57-b275-4542-bb94-59e67cb2bc37
# ╠═9fba7f94-1ca5-4f88-ba90-9eac80be17ad
# ╠═a9d17ac1-091c-4cb5-9286-b8e90fa69097
# ╠═adde81ff-f4fa-4f79-9e2a-724aabfd8956
# ╟─c6857803-0345-47f2-92ce-170dea52ca06
# ╠═361680eb-b4d3-49ed-bca1-d973964dbb76
# ╠═820e2deb-7da4-4b30-8459-a484e5378894
# ╠═48f669f0-6d2d-4ea9-8a7d-e65da90c8c26
# ╠═f9cad338-992b-409d-a7e6-25ddf49b31f3
# ╠═304dd853-0d1a-42d1-9412-51f71e2e6ff1
