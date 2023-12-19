### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 632940f0-0f5d-4f7d-b5be-70ab6b06a0db
begin
	using PlotlyJS
end

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

# ╔═╡ 85ea2362-746f-4350-b90d-8f477acfd0fb
md"""## From features matrix to similarity matrix"""

# ╔═╡ 09dc4528-7a5a-4b1a-ad85-8f57470da586
matrix1

# ╔═╡ 850a7831-2aaf-4cc6-a98a-fc6e01290c4b
rowlabels  = ["penguin", "shark", "dodo"]

# ╔═╡ 7ed29dcb-6ba2-46ce-9f75-7b190a0eb519
columnlabels = ["wings","flies","swims"]

# ╔═╡ ac23b18b-9b1b-494e-94e5-13ca81ced55f
matrix1 |> length

# ╔═╡ 69aec10f-fb9d-4094-977f-a8100b729ffd
matrix1 |> ndims

# ╔═╡ b005d922-a2f0-44cc-a25a-0a6e1a02c182
matrix1 |> size

# ╔═╡ 227173cd-e5e0-45d4-8a98-11323c90f92a
matrix1 |> axes

# ╔═╡ cf073fd5-b12f-422a-b470-ccc9cfc7c448
matrix1 |> strides

# ╔═╡ 68ed28d9-6830-47b1-beca-5c75d4c3ba9d
matrix1

# ╔═╡ d80aecbc-eefa-4a46-b28b-113deb0b2994
matrix1[CartesianIndex(2,3)]

# ╔═╡ 2bd2e44f-65c5-4dd6-a34a-28edbafbe295
md"""Maybe look at [https://www.geeksforgeeks.org/manipulating-matrices-in-julia/](https://www.geeksforgeeks.org/manipulating-matrices-in-julia/)"""

# ╔═╡ 4d275c83-5523-46a9-a9b1-c2ef6c559132
firstindex(matrix1, 1)

# ╔═╡ 18129cc0-d4a5-4edf-928a-59e64adc997f
eachindex(matrix1)

# ╔═╡ 883a396b-e346-4a04-acb0-59240b5d4496
matrix1[1,:]

# ╔═╡ 8000c26c-4250-4604-b1ed-2bc0b68bca2f
matrix1 |> size

# ╔═╡ 1b30421e-a1b1-4912-abcb-5b49083f12c5
(rows, cols) = size(matrix1)

# ╔═╡ e43ab7be-8305-4dcd-9ae4-e5ba69b6eaef
# ╠═╡ show_logs = false
begin
	similaritymatrix = Array{Bool}(undef, 3,3)
	#println("$(rows) rows, $(cols) columns")
	for r in 1:rows
		println("Look at $(rowlabels[r])")
		for c in 1:cols
			println("Compare along $(columnlabels[c])")
			for r2 in 1:rows
				println("Compare with $(rowlabels[r2])")
				similaritymatrix[r,r2] = matrix1[r, c] == matrix1[r2, c]
			end
			#println("col $(c)")
			#println(string(r,":",c))
			#println(string(rowlabels[r],": ", columnlabels[c]," = ", matrix1[r,c]))
		end
	end
	similaritymatrix
end

# ╔═╡ ee0a622b-05c0-4d5a-ab44-75dadf515932
begin
	hdr = "| | Penguin | Shark | Dodo |\n|---|---|---|---|\n "
	datalines = []
	for r in 1:rows
		currrowvals = [  rowlabels[r]]
		for c in 1:cols
			#push!(datalines, string("| ", rowlabels[r], "|"))
			
			push!(currrowvals,string(similaritymatrix[r,c]))
			
		end
		push!(datalines, join(currrowvals, "|"))
	end
	hdr * join(datalines, "\n") |> Markdown.parse
end

# ╔═╡ 5d52ae87-acad-4e49-883c-2980c37972e7
md"""Also for plotting maybe [https://discourse.julialang.org/t/how-to-plot-matrix-as-gradient-grid/82187/7](https://discourse.julialang.org/t/how-to-plot-matrix-as-gradient-grid/82187/7)"""

# ╔═╡ a52246c3-1533-45e5-b6d0-3dd26b6571ff
similarityints = map(tf -> tf ? 1 : 0, similaritymatrix)

# ╔═╡ 26766bcb-002a-444e-b8b9-67928604b6f2
md"""> ### => *Flip the order of rows or columns to get traditional diagonal from TL to BR*"""

# ╔═╡ f26aebfc-20d7-498a-9eab-8036bfc5b617
Plot(
    heatmap(
        x=rowlabels,
        y=rowlabels,
        z= similarityints,
    ),
    Layout(xaxis_side="top",
		height = 400,
		yaxis_scaleratio = 1,
		xaxis_scaleratio = 1
	)
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a"

[compat]
PlotlyJS = "~0.18.11"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "e974633589b93b5eb36a3efc079a5bbfe6569c15"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Blink]]
deps = ["Base64", "Distributed", "HTTP", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Pkg", "Reexport", "Sockets", "WebIO"]
git-tree-sha1 = "b1c61fd7e757c7e5ca6521ef41df8d929f41e3af"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.8"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43032da5832754f58d14a91ffbe86d5f176acda9"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.2.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "a7cefa21a2ff993bff0456bf7521f46fc077ddf1"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.19"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "MbedTLS", "Pkg", "Sockets"]
git-tree-sha1 = "0bdaa479939d2a1f85e2f93e38fbccfcb73175a5"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "3db9e7724e299684bf0ca8f245c0265c4bdd8dc6"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.11"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "0eef0765186f7452e52236fa42ca8c9b3c11c6e3"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.21"

[[deps.WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "4162e95e05e79922e44b9952ccbc262832e4ad07"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.6.0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═632940f0-0f5d-4f7d-b5be-70ab6b06a0db
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
# ╟─85ea2362-746f-4350-b90d-8f477acfd0fb
# ╠═09dc4528-7a5a-4b1a-ad85-8f57470da586
# ╠═850a7831-2aaf-4cc6-a98a-fc6e01290c4b
# ╠═7ed29dcb-6ba2-46ce-9f75-7b190a0eb519
# ╠═ac23b18b-9b1b-494e-94e5-13ca81ced55f
# ╠═69aec10f-fb9d-4094-977f-a8100b729ffd
# ╠═b005d922-a2f0-44cc-a25a-0a6e1a02c182
# ╠═227173cd-e5e0-45d4-8a98-11323c90f92a
# ╠═cf073fd5-b12f-422a-b470-ccc9cfc7c448
# ╠═68ed28d9-6830-47b1-beca-5c75d4c3ba9d
# ╠═d80aecbc-eefa-4a46-b28b-113deb0b2994
# ╟─2bd2e44f-65c5-4dd6-a34a-28edbafbe295
# ╠═4d275c83-5523-46a9-a9b1-c2ef6c559132
# ╠═18129cc0-d4a5-4edf-928a-59e64adc997f
# ╠═883a396b-e346-4a04-acb0-59240b5d4496
# ╠═8000c26c-4250-4604-b1ed-2bc0b68bca2f
# ╠═1b30421e-a1b1-4912-abcb-5b49083f12c5
# ╠═e43ab7be-8305-4dcd-9ae4-e5ba69b6eaef
# ╟─ee0a622b-05c0-4d5a-ab44-75dadf515932
# ╟─5d52ae87-acad-4e49-883c-2980c37972e7
# ╠═a52246c3-1533-45e5-b6d0-3dd26b6571ff
# ╟─26766bcb-002a-444e-b8b9-67928604b6f2
# ╠═f26aebfc-20d7-498a-9eab-8036bfc5b617
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
