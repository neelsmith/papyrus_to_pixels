### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 7e2f96e0-72f8-4468-addc-42a3196c1cb5
begin
	using Downloads
	using PlutoUI
	using StatsBase, OrderedCollections
	md"""*Unhide this cell to see the Julia environment.*"""
end

# ╔═╡ 80bb377e-ee63-4695-9345-9891018f9687
TableOfContents()

# ╔═╡ 86f1a6f4-d738-488d-aecc-3eae85d853a8
md"""*Template notebook: last modified* **Mar. 21, 2024.**"""

# ╔═╡ f9dc0eec-63ce-49ea-8ef9-b26b71f90958
md"""
!!! alert "Requirements for assignment: preparing a \"bag of words\" model of a text"

    1. Follow the guidelines in this notebook to develop a function for tokenizing an English translation of the Bible.
    3. When you have completed all missing sections of code and discussion, save your notebook as a file named {LASTNAME}-lab4.jl substituting your last name for {LASTNAME}, and add the file to your personal folder on the course Google drive.
    4. Make sure everyone in your group has submitted a notebook with identical solutions to the problem.  Include your individual thoughts in the final reflection section of the notebook.

"""


# ╔═╡ 3d793a37-fe2e-48e1-b264-379e24cf0dc1
md"""## Publication"""

# ╔═╡ b0c53af2-be14-47f5-9e57-b6b1e6a30b9c
md"""
*Authors*: **-->ALL NAMES OF COLLABORATORS HERE<--**


*Date last modified*: **-->DATE HERE<--**

"""

# ╔═╡ a5bbf210-ad59-4e54-a4fe-4ff18cf0f905
md"""*License* : 
**[CC BY-SA 4.0 DEED](https://creativecommons.org/licenses/by-sa/4.0/deed.en)** [![](https://upload.wikimedia.org/wikipedia/commons/a/a9/CC-BY-SA.png)](https://creativecommons.org/licenses/by-sa/4.0/deed.en)
"""

# ╔═╡ 2f5167aa-e5fb-11ee-151c-290eefd7b2f3
md"""# Lab 4: preparing a "Bag of Words" model of text"""

# ╔═╡ c2960c64-fd0e-4cb1-90e5-7aa74e51e81a
md"""## 1. Defining the goal


"""

# ╔═╡ f3aebae5-9596-4516-92ec-0c0082df6556
md"""
!!! note "Goal"

    In this notebook, we want to develop a function to find a unique set of tokens for a text.

    You will need to define what is an appropriate token for the larger, collective assignment where we will compare vocabulary sets across different translations of the Bible. You will have to decide what is a meaningful token for that purse, and complete a function to implement your definition.

"""

# ╔═╡ bb449550-079f-4785-b8ba-4e859ba0a056
md"""## 2. Breaking down the problem

"""

# ╔═╡ 566a03be-04df-49a4-ba7d-1a069bdd4e31
md"""
!!! note "Breaking down the problem"

    Your function will be given one required parameter: a single string of text.  You will need to clean up, or *normalize* your input, and then split it up into tokens. Finally, you'll want to get the list of *unique* tokens in the text.
"""

# ╔═╡ b7b6a889-ae04-432a-bfd1-dfc88b338991
md"""### A. Developing your function"""

# ╔═╡ 98d80b1b-11bf-41f3-b40b-68570731c9c3
md"""After you submit this notebook, we'll apply your solution to a large collection of English translations of the Bible. You can more conveniently develop your function on a small test set.
"""

# ╔═╡ d2f8932c-825c-4dc4-8d83-37fe73e4818c
"""**-->ADD DOCUMENTATION HERE OF WHAT YOUR FUNCTION DOES<--**"""
function tokenizetext(txt)
	split(txt) |> unique |> sort
end

# ╔═╡ 3b1f6738-023f-486e-a568-9a7ade7f43c3
md"""For a quick impression of what your function does, here's a test on a few words of hand-typed text:"""

# ╔═╡ 73bf3a30-d0ea-47ab-bb56-b5371971b5ca
tokenizetext("This is not a very long text.")

# ╔═╡ 09806e87-efe3-4dac-8cc7-8346ef3e7375
md"""### B. Test your function"""

# ╔═╡ e2d15699-8217-40a1-a18b-08c6c32c4fa2
md"""You can test your function here on a larger set of test data by selecting up to 100 verses of either the American Standard Version or the King James Version, and visually inspecting up to 200 of the most frequent tokens """

# ╔═╡ bb29c0d1-0ad5-473a-8dc4-2b8af53b75ad
md"""*Test tokenize function on verses [1-100]*: $(@bind psgcount Slider(1:100, show_value = true))"""

# ╔═╡ 214039a0-ec1f-49e3-8fbb-fac4107884f0
md"""*View resulting tokens [5-200]*: $(@bind outputcount Slider(5:5:200, show_value=true))"""

# ╔═╡ ad17c175-5ca8-4ec0-aa63-7377c90dbdc3
md"""### C. Next steps"""

# ╔═╡ 8f822699-45ec-49d0-a6d8-fd120e371188
md"""
!!! note "Next steps"

    Are there other factors you might want to consider in comparing vocabuary lists for different translations? For example, should proper names (people, places) be included, or are those too similar to inform us about translators' choices?
"""

# ╔═╡ e227492a-05f8-4571-8b80-9240865bc009
md"""## 3. Reflection
"""

# ╔═╡ 7da4a61a-3bd9-4a83-8d82-c313b1ec88cc
md"""
!!! note "Reflection: preparing a \"bag of words\" model of text"


    In this lab, you developed a generic function that we'll use in a larger project. As you're beginning to work on a longer project, can you transfer this experience to planning your project work? How can you segment tasks you need to complete for your project so that you can test small pieces and verify that they work reliably before trying to use them in a more complex project?

"""

# ╔═╡ 6672cfa0-b353-4ce7-8baa-7b71386bf5bb
html"""
<br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/>
"""

# ╔═╡ 0a5c17af-eb6c-4977-9d76-82698b05a880
md"""> ## Stuff you can ignore"""

# ╔═╡ 9fa625fb-318c-4bbc-8ee3-2a5f9b318ece
md"""> ### UI"""

# ╔═╡ b6879a45-1ce8-4ddd-af29-8458f1536bd5
#mdtable(countdicts[txtidx], labels[txtidx], outputcount) |> Markdown.parse

# ╔═╡ ecf65633-eee5-4d25-8ff3-1eeac34f6b5a
""" Compose markdown table for an ordered dictionary.
"""
function mdtable(countsdict, title, rowsmax)
	n = length(countsdict)
	keylist = keys(countsdict)  |> collect
	rows = minimum([rowsmax, length(keylist)])

	mdlines = [
		#"### Frequencies for $(n) tokens in $(title)","",
		"| Token | Count |",
		"| --- | --- "
	]
	for k in  keylist[1:rows]
		ln = string("| ", k, " | ", countsdict[k] , " |")
		push!(mdlines, ln)
	end
	join(mdlines,"\n")

end

# ╔═╡ 5f5b36a3-7517-45c2-a7a1-2d1d450e3829
md"""> ### Tokenize"""

# ╔═╡ 4c641bc3-e6d0-4b91-9da1-f6d767b1fd23


# ╔═╡ 4bf6f682-4b02-4747-ac55-9fc16f066be0
"""Use `tokenizetext` function to compute frequencies of tokens in multiple texts,
limiting consideration to the first `passagecount` passages of each text.
"""
function tokenlists(textcontents, passagecount)
	results = []
	
	textcount  = length(textcontents)
	for i in 1:textcount
		textvector = []
		for j in 1:passagecount
			tkns = tokenizetext(textcontents[i][j])
			push!(textvector, tkns)
		end
		tknlist = textvector |> Iterators.flatten |> collect
		push!(results, sort(unique(tknlist)))
	end
	results 
end

# ╔═╡ 4a8c2a4c-5639-44b2-bb0c-9826e833f695
"""Use `tokenizetext` function to compute frequencies of tokens in multiple texts,
limiting consideration to the first `passagecount` passages of each text.
"""
function tokenfreqs(textcontents, passagecount)
	textcount  = length(textcontents)
	tokendicts = OrderedDict[]
	for i in 1:textcount
		textvector = []
		for j in 1:passagecount
			tkns = tokenizetext(textcontents[i][j])
			push!(textvector, tkns)
		end
		tkndict = textvector |> Iterators.flatten |> collect |> countmap |> OrderedDict
		push!(tokendicts, sort!(tkndict, rev=true, byvalue=true))
	end
	tokendicts
end

# ╔═╡ b4cb56e3-1e65-4fd6-b09e-89deb17001bb
md"""> ### Load data"""

# ╔═╡ eded19cf-a78d-4e7b-ba26-58e296aee2c2
baseurl = "https://raw.githubusercontent.com/neelsmith/papyrus_to_pixels/main/data/texts/bibles/"

# ╔═╡ acc0720a-1012-4ff9-9719-0f9f22b4a774
fnames = ["eng-asv_vpl.txt",
	"eng-kjv_vpl.txt"
]

# ╔═╡ 406941ce-1a47-4a0c-a4b8-592db01da689
labels = ["American Standard Version", "King James Version"]

# ╔═╡ 90701252-8a17-44ad-8224-5d74b0385091
menu = [
	1 => labels[1],
	2 => labels[2]
]

# ╔═╡ a544e01b-bb80-4929-affd-1616ddca957c
md"""*See results for*: $(@bind txtidx Select(menu))"""

# ╔═╡ c4bc1729-8319-4b81-bded-976e4c3f165b
psgcount == 1 ? md"""
**Results**: tokens (up to $(outputcount)) for 1 verse in the $(labels[txtidx])
""" : md"""
**Results**: tokens (up to $(outputcount)) for $(psgcount) verses in the $(labels[txtidx])
"""

# ╔═╡ f2295d0d-adfb-4eb2-b57e-e0ea44743ed7
urls = [baseurl * fname for fname in fnames]

# ╔═╡ e3997da1-ca4d-42aa-b768-e4a04ad9cf2d
"""Read lines from remote URL."""
function readdata(u)
	tmp = Downloads.download(u)
	datalines = readlines(tmp)
	rm(tmp)
	datalines
end
	

# ╔═╡ 24e57f52-177e-4471-b94a-39530a1e63dc
datasets = [readdata(url) for url in urls]

# ╔═╡ 81936dd9-7bb1-435a-87b6-89ab3a49e1c9
"""Parse ebibles data format into a Julia struct.
"""
function parsetextdata(lines)
	re = r"([^ ]+) ([^ ]+) (.+)"
	passages = []
	for ln in lines
		m = match(re, ln)
		if ! isnothing(m)
			bk, ref, psg = m.captures
			push!(passages,  psg)
		end
	end
	passages
end

# ╔═╡ 51d5fe49-c386-44e4-be31-faf1aff0e9be
textdata = [parsetextdata(dataset) for dataset in datasets]

# ╔═╡ a29611e9-b989-4285-abdd-e8239aac92db
tkns = tokenlists(textdata,psgcount)

# ╔═╡ 3cce3d47-a4f5-4c47-b49b-80ab9213ca04
begin
	rows = minimum([outputcount, length(tkns[1])])
	items = map(t -> "- " * t, tkns[txtidx][1:rows])
	join(items, "\n") |> Markdown.parse

end

# ╔═╡ ae51c7a2-9665-4213-95b7-16d1faaeed39
countdicts = tokenfreqs(textdata, psgcount)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
OrderedCollections = "~1.6.3"
PlutoUI = "~0.7.58"
StatsBase = "~0.34.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "c1c89b58a18062b130451cbc248f09a756d1c83e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "0f4b5d62a88d8f59003e43c25a8a90de9eb76317"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.18"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "71a22244e352aa8c5f0f2adde4150f62368a3f2e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.58"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─80bb377e-ee63-4695-9345-9891018f9687
# ╟─7e2f96e0-72f8-4468-addc-42a3196c1cb5
# ╟─86f1a6f4-d738-488d-aecc-3eae85d853a8
# ╟─f9dc0eec-63ce-49ea-8ef9-b26b71f90958
# ╟─3d793a37-fe2e-48e1-b264-379e24cf0dc1
# ╟─b0c53af2-be14-47f5-9e57-b6b1e6a30b9c
# ╟─a5bbf210-ad59-4e54-a4fe-4ff18cf0f905
# ╟─2f5167aa-e5fb-11ee-151c-290eefd7b2f3
# ╟─c2960c64-fd0e-4cb1-90e5-7aa74e51e81a
# ╟─f3aebae5-9596-4516-92ec-0c0082df6556
# ╟─bb449550-079f-4785-b8ba-4e859ba0a056
# ╟─566a03be-04df-49a4-ba7d-1a069bdd4e31
# ╟─b7b6a889-ae04-432a-bfd1-dfc88b338991
# ╟─98d80b1b-11bf-41f3-b40b-68570731c9c3
# ╠═d2f8932c-825c-4dc4-8d83-37fe73e4818c
# ╟─3b1f6738-023f-486e-a568-9a7ade7f43c3
# ╠═73bf3a30-d0ea-47ab-bb56-b5371971b5ca
# ╟─09806e87-efe3-4dac-8cc7-8346ef3e7375
# ╟─e2d15699-8217-40a1-a18b-08c6c32c4fa2
# ╟─bb29c0d1-0ad5-473a-8dc4-2b8af53b75ad
# ╟─a544e01b-bb80-4929-affd-1616ddca957c
# ╟─214039a0-ec1f-49e3-8fbb-fac4107884f0
# ╟─c4bc1729-8319-4b81-bded-976e4c3f165b
# ╟─3cce3d47-a4f5-4c47-b49b-80ab9213ca04
# ╟─ad17c175-5ca8-4ec0-aa63-7377c90dbdc3
# ╟─8f822699-45ec-49d0-a6d8-fd120e371188
# ╟─e227492a-05f8-4571-8b80-9240865bc009
# ╟─7da4a61a-3bd9-4a83-8d82-c313b1ec88cc
# ╟─6672cfa0-b353-4ce7-8baa-7b71386bf5bb
# ╟─0a5c17af-eb6c-4977-9d76-82698b05a880
# ╟─9fa625fb-318c-4bbc-8ee3-2a5f9b318ece
# ╟─90701252-8a17-44ad-8224-5d74b0385091
# ╟─b6879a45-1ce8-4ddd-af29-8458f1536bd5
# ╟─ecf65633-eee5-4d25-8ff3-1eeac34f6b5a
# ╟─5f5b36a3-7517-45c2-a7a1-2d1d450e3829
# ╠═4c641bc3-e6d0-4b91-9da1-f6d767b1fd23
# ╟─a29611e9-b989-4285-abdd-e8239aac92db
# ╠═4bf6f682-4b02-4747-ac55-9fc16f066be0
# ╟─ae51c7a2-9665-4213-95b7-16d1faaeed39
# ╟─4a8c2a4c-5639-44b2-bb0c-9826e833f695
# ╟─b4cb56e3-1e65-4fd6-b09e-89deb17001bb
# ╟─eded19cf-a78d-4e7b-ba26-58e296aee2c2
# ╟─acc0720a-1012-4ff9-9719-0f9f22b4a774
# ╟─406941ce-1a47-4a0c-a4b8-592db01da689
# ╟─f2295d0d-adfb-4eb2-b57e-e0ea44743ed7
# ╟─24e57f52-177e-4471-b94a-39530a1e63dc
# ╟─51d5fe49-c386-44e4-be31-faf1aff0e9be
# ╟─e3997da1-ca4d-42aa-b768-e4a04ad9cf2d
# ╟─81936dd9-7bb1-435a-87b6-89ab3a49e1c9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
