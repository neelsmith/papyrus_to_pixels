### A Pluto.jl notebook ###
# v0.19.37

using Markdown
using InteractiveUtils

# ╔═╡ d4da7ffb-5762-4102-86a7-d43862cff156
using Downloads

# ╔═╡ 9cb48a23-c145-4553-87db-b5f5feb77961
md"""The following parallel vectors of features are loaded in this notebook:

- `years`
- `places`
- `winners`
- `losers`
- `winningscores`
- `losingscores`
"""

# ╔═╡ 403bb8b5-bcea-46d0-8318-06e0eed041f6
md"""### Using dictionaries to coordinate parallel feature sets"""

# ╔═╡ 565eec2e-91df-4775-b4ba-03d75ca73e3e
md"""

- a one-to-one relation: years -> winners
- some one-to-many relations: 
    - winners -> years
    - winners -> losers
"""

# ╔═╡ 23cfe25d-0ec1-41c5-b53f-530105b10223
html"""
<br/><br/><br/><br/>
<br/><br/><br/><br/>
<br/><br/><br/><br/>
<br/><br/><br/><br/>

"""

# ╔═╡ 564b6289-0031-413c-aff6-b785ed202c07
md"""
---
"""

# ╔═╡ 8af84745-9b72-4ab1-9463-18d5f108d227
md"""> Load and parse data set"""

# ╔═╡ 77c56d56-9812-469f-b58d-60e3ddc764d9
url = "https://raw.githubusercontent.com/neelsmith/papyrus_to_pixels/main/data/superbowls/superbowls.cex"

# ╔═╡ 2cb629ce-4880-4566-bf9b-9453fda6d4a5
"""## Superbowl history 


### Data set
- Source for data: ESPN's "Superbowl history" page,  [https://www.espn.com/nfl/superbowl/history/winners](https://www.espn.com/nfl/superbowl/history/winners)
- See the [delimited text file]($(url)) made from the ESPN data
""" |> Markdown.parse

# ╔═╡ ec3324c7-4022-4409-b7c1-54b6149704b9
data = begin
	tmp = Downloads.download(url)
	datalines = readlines(tmp)[2:end]
	rm(tmp)
	datalines
end

# ╔═╡ 6bb3c454-67c2-452c-85a3-fa732a54f8c7
years = map(data) do ln
	parse(Int,split(ln,"|")[1])
end

# ╔═╡ 508b5d09-b21e-42e5-96e1-d1e8e9b3d2f3
places = map(data) do ln
	split(ln,"|")[2]
end

# ╔═╡ f4b340fd-ae7d-48f8-bd0f-ffca086ae959
winners = map(data) do ln
	split(ln,"|")[3]
end

# ╔═╡ d24b16fb-da78-4101-9f9b-d73a7491f3ec
losers = map(data) do ln
	split(ln,"|")[5]
end

# ╔═╡ df65b12d-df80-43e1-98ce-e0f2e136f8e0
winningscores =  map(data) do ln
	parse(Int,split(ln,"|")[4])
end

# ╔═╡ 893f2c40-e1f3-4684-b9c7-26f9e257d359
losingscores =  map(data) do ln
	parse(Int,split(ln,"|")[6])
end

# ╔═╡ cabdb395-83e1-4422-ba37-939a6bf5ecad
md"""What years has each team won?"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "bfd6b21f28942ebf81c6008a25e304e2d1c95415"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"
"""

# ╔═╡ Cell order:
# ╟─2cb629ce-4880-4566-bf9b-9453fda6d4a5
# ╟─9cb48a23-c145-4553-87db-b5f5feb77961
# ╟─403bb8b5-bcea-46d0-8318-06e0eed041f6
# ╟─565eec2e-91df-4775-b4ba-03d75ca73e3e
# ╟─23cfe25d-0ec1-41c5-b53f-530105b10223
# ╟─564b6289-0031-413c-aff6-b785ed202c07
# ╟─8af84745-9b72-4ab1-9463-18d5f108d227
# ╠═d4da7ffb-5762-4102-86a7-d43862cff156
# ╟─ec3324c7-4022-4409-b7c1-54b6149704b9
# ╟─77c56d56-9812-469f-b58d-60e3ddc764d9
# ╟─6bb3c454-67c2-452c-85a3-fa732a54f8c7
# ╟─508b5d09-b21e-42e5-96e1-d1e8e9b3d2f3
# ╟─f4b340fd-ae7d-48f8-bd0f-ffca086ae959
# ╟─d24b16fb-da78-4101-9f9b-d73a7491f3ec
# ╟─df65b12d-df80-43e1-98ce-e0f2e136f8e0
# ╟─893f2c40-e1f3-4684-b9c7-26f9e257d359
# ╟─cabdb395-83e1-4422-ba37-939a6bf5ecad
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
