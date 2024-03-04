### A Pluto.jl notebook ###
# v0.19.38

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

# ╔═╡ d6d9ea5e-9895-4013-871c-8cbeb88820cb
begin
	using Downloads
	using PlutoUI
	# using VectorAlignments
	using StatsBase, OrderedCollections
	md"""*To see the Julia environment, unhide this cell.*"""
end

# ╔═╡ 66deb0e9-f3f7-4a49-a2e2-b52c887ba182
TableOfContents()

# ╔═╡ 8389ee5e-d993-11ee-1cd3-ff3165294839
md"""# Comparing translations"""

# ╔═╡ 616eab90-8a7b-497d-b576-a254fe23dca3
md"""!!! tip "Improve this!"

    Improve the results of this analysis by writing a better function to tokenize text.
"""

# ╔═╡ 25f4a836-b4d8-47da-9c93-3f9df2d81ecf
function tokenizetext(txt)
	split(txt)
end

# ╔═╡ 1bd3e785-0e51-4500-ac4a-d0e9667b741f
md"""## Overview of corpus"""

# ╔═╡ 32c8450e-fcfc-4292-a5c6-babeed7bfab9
md"""## "Stop words" to ignore"""

# ╔═╡ 991ce7b9-c99e-4e23-b53b-643494d8dad1
md"""!!! note "Instructions"

    Choose stop words from a list of `n` most frequent terms across all texts, then use the `Submit` button.
"""

# ╔═╡ 0a3e7769-487e-4a28-9c77-5e08f6667203
md"""*Value for* `n`: $(@bind n Slider(10:10:500, show_value=true))"""

# ╔═╡ b18b9057-79ef-4473-8878-855826c0467b
md"""## Selected contents"""

# ╔═╡ 97c90eb0-c6ac-4782-9f43-084fb0f688ad
html"""
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ 1cfb8992-1de2-4f63-9135-eff34d370e67
md"""> # Stuff you don't need to look at"""

# ╔═╡ 9cbd31fb-1927-4bea-a8c4-74851c250797
md"""> ## Total SCS and feature table of scores"""

# ╔═╡ 0ef17be4-8159-42d4-a862-3d5a77af19f3
"""Compute normalized freqeuncies for tokens in a list and return a dictionary of their counts.""" 
function normscores(tknlist)
	total = length(tknlist)
	freqs = countmap(tknlist)
	normeddict = OrderedDict()
	for k in keys(freqs)
		normeddict[k] = freqs[k] / total
	end
	sort(normeddict)
end

# ╔═╡ 0c4c9c3a-e533-476f-be14-56a5a010f611
md"""> ## Characterizing contents"""

# ╔═╡ 0e37b191-da47-4066-b7e2-8c883387b730
"""Format Markdown table summarizing contents"""
function summarytable(xlations, bklists, vrscounts, tknlists, vocab)
	mdlines = ["| Translation | Books | Verses | Tokens | Vocabulary size |",
	"| --- | --- | --- | --- | --- |",	
	]

	for (i, title) in enumerate(xlations)
		row = string("| ", title, " | ", length(bklists[i]), " |", vrscounts[i], " |", length(tknlists[i]), " |" , length(vocab[i]), " |")
		push!(mdlines, row)
	end
	join(mdlines,"\n")
end

# ╔═╡ 87dc6cfe-44e9-4604-a6c1-d2a6fef17328
md"""> ## Selected contents"""

# ╔═╡ c3ec5291-2f3f-405f-a04f-b0e7df9770b4
md"""> ## Global tokenizations"""

# ╔═╡ 0f4f7370-526a-494d-a668-d2d95e47298c
md"""> ## Load data"""

# ╔═╡ 89a8f473-0440-4792-842e-e877c2eb93d7
metadataurl = "https://raw.githubusercontent.com/neelsmith/papyrus_to_pixels/main/data/texts/bibles/sources.cex"

# ╔═╡ 21303eb5-eaed-48be-8814-47dd6ad393aa
baseurl = "https://raw.githubusercontent.com/neelsmith/papyrus_to_pixels/main/data/texts/bibles/"

# ╔═╡ 4e20cb12-51f3-4b57-9057-392dffbc4af6
filenames = [
	"eng-asv_vpl.txt",
	"eng-kjv_vpl.txt",
	"eng-rv_vpl.txt",
	"eng-web_vpl.txt",
	"engPEV_vpl.txt",
	"enggnv_vpl.txt",
	"engwyc2017_vpl.txt"
	
]

# ╔═╡ 9ef93e1f-0cd3-4175-bd60-8a1dad69279d
"""Structure for a citable Biblical passage."""
struct Passage
	version
	book
	ref
	text
end

# ╔═╡ 10612973-ee18-4382-9800-ae33d2520742
"""Read lines from remote URL."""
function readdata(u)
	tmp = Downloads.download(u)
	datalines = readlines(tmp)
	rm(tmp)
	datalines
end
	

# ╔═╡ 96dec338-79be-41b4-810e-00d95372b4d0
"""Parse ebibles data format into a Julia struct.
"""
function parselinesformat(lines, versionid)
	re = r"([^ ]+) ([^ ]+) (.+)"
	passages = []
	for (i, ln) in enumerate(lines)
		m = match(re, ln)
		if ! isnothing(m)
			bk, ref, psg = m.captures
			push!(passages, Passage(versionid, bk, ref, psg))
		end
	end
	passages
end

# ╔═╡ 7007c64a-e990-49be-9829-f2662d671bd4
datalines = readdata(metadataurl)

# ╔═╡ 8b1237c7-e5c1-428d-8e7f-26a243387329
menu = map(datalines[2:end]) do ln
	cols = split(ln, "|")
	cols[4] => cols[1]
end

# ╔═╡ edf1fa49-d50c-49ba-92f0-9a87e8fcb839
 textdict = Dict(menu)

# ╔═╡ 33dbf434-7d91-48a8-a200-35499993cc1a
labels = [textdict[fname] for fname in filenames]

# ╔═╡ e2fae900-c222-4eee-9c94-959bfe68987e
textdata = map(filenames) do f
	readdata(baseurl * f)
end

# ╔═╡ 67021d14-f5fd-4da6-8702-83833b5ac848
map(v -> length(v), textdata)

# ╔═╡ 5be24375-6ee6-4394-8587-45dded4e805a
citable = [parselinesformat(txt, filenames[i]) for (i,txt) in enumerate(textdata)]

# ╔═╡ 1f0e2b6c-4651-4133-aeef-81939fed926a
books = [unique(map(psg -> psg.book, txt)) for txt in citable]

# ╔═╡ aaead9f6-a21e-4288-95a9-9138f7aefefc
@bind booklist confirm(MultiCheckBox((books[4]), select_all=true))

# ╔═╡ 208dbc9f-57bb-4c08-a0c1-9262bd665c27
md"""*Contents of translations for book(s)* **$(join(booklist, ", "))**:"""

# ╔═╡ a07d7d3e-a469-4489-ac15-d6aa05774300
verses = [length(txt) for txt in  citable]

# ╔═╡ 037d2ac9-9f71-4a84-890a-223a7900cc41
selectedpsgs = [filter(psg -> psg.book in booklist, psglist) for psglist in citable]

# ╔═╡ 25c5ce38-4b53-4eba-9569-24ccc1ed05c8
 selectedbooks = [unique(map(psg -> psg.book, txt)) for txt in selectedpsgs]

# ╔═╡ ad360374-0437-470c-ab87-7b0f3c398454
selectedverses = [length(txt) for txt in  selectedpsgs]

# ╔═╡ 5c6e91a1-ac1b-4579-9c7e-bd484248838f
selectedtext = [join(map(psg -> psg.text, txt)," ") for txt in selectedpsgs]

# ╔═╡ fcd8b5cb-9bd3-4373-96ae-65f1dadbd714
selectedtokens = [tokenizetext(txt) for txt in selectedtext]

# ╔═╡ 62844d27-a061-49aa-bc0f-236df6e67b72
vocablist = [sort(unique(tkns)) for tkns in selectedtokens]

# ╔═╡ 8128bbbb-8e5a-4891-88a8-127e8bdd9246
totaltokens = [length(tkns) for tkns in selectedtokens]

# ╔═╡ 9bc5ff9c-77a5-45c0-a9dd-b286fe34d658
tokenscores = [normscores(tlist) for tlist in selectedtokens]

# ╔═╡ 572e8630-9fac-4aea-8ae7-1d75d546a8ca
sort(tokenscores[1], byvalue = true, rev = true)

# ╔═╡ 5f0818fe-b47c-4a7b-9116-646f7a62e374
selectedvocab = [sort(unique(tlist)) for tlist in selectedtokens]

# ╔═╡ 73090143-3914-4b7f-b73b-d8469c45a491
summarytable(labels, selectedbooks, selectedverses, selectedtokens, selectedvocab) |> Markdown.parse

# ╔═╡ 86c12ab8-163f-43bd-8f3d-248ef2555e97
textonly = [map(psg -> psg.text, txt) for txt in citable ]
	

# ╔═╡ 00a1ff11-8d26-47fb-8535-cfa8282a2111
alltext = join(textonly, "\n")

# ╔═╡ ef13e58e-4a84-435f-bbfb-280bd04bb1b7
allfreqs_raw = countmap(tokenizetext(alltext)) |> OrderedDict

# ╔═╡ 6a6e762c-6ad8-4939-855e-0cfa98052438
allfreqs = sort(allfreqs_raw, byvalue=true, rev=true)

# ╔═╡ fc22cc31-2ffc-430e-9d9a-e0604f13c369
stopcandidates = collect(keys(allfreqs))[1:n]

# ╔═╡ 5e7aa912-abba-4f75-9217-14e2204f15b5
@bind stoppers confirm(MultiCheckBox(stopcandidates, select_all = true))

# ╔═╡ 9389e8bf-0959-44d4-9a79-784357997d33
stoppers

# ╔═╡ 9933af7c-7b29-4250-83c4-4b2ccf2b9055
filteredtokens = [sort(filter(t -> ! (t in stoppers), tkns)) for tkns in selectedtokens]

# ╔═╡ efbb1285-d7b3-4509-9151-29935649c6cd
tokenfreqs = [OrderedDict(countmap(tkns)) for tkns in filteredtokens]

# ╔═╡ 2eced09d-30ed-4448-96ab-80348d2bba17
tokens = [tokenizetext(join(txt,"\n")) for txt in textonly]

# ╔═╡ 63ca826f-8e9e-4dbe-891d-b6e7b5855d55
vocab = [sort(unique(tlist)) for tlist in tokens]

# ╔═╡ a800ec25-354d-4370-958b-05b06b278ad8
summarytable(labels, books, verses, tokens, vocab) |> Markdown.parse

# ╔═╡ 287a3417-1b7a-4a6d-8784-f1b7a6d6ff25
rawfreqs = [OrderedDict(countmap(tknlist)) for tknlist in tokens]

# ╔═╡ 8632c027-c552-4fe4-8074-16a968b217b6
sorted = [ sort(freqs, rev=true, byvalue=true) for freqs in rawfreqs]

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
git-tree-sha1 = "1fb174f0d48fe7d142e1109a10636bc1d14f5ac2"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.17"

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
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9e8fed0505b0c15b4c1295fd59ea47b411c019cf"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.2"

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
# ╟─d6d9ea5e-9895-4013-871c-8cbeb88820cb
# ╟─66deb0e9-f3f7-4a49-a2e2-b52c887ba182
# ╟─8389ee5e-d993-11ee-1cd3-ff3165294839
# ╟─616eab90-8a7b-497d-b576-a254fe23dca3
# ╠═25f4a836-b4d8-47da-9c93-3f9df2d81ecf
# ╟─1bd3e785-0e51-4500-ac4a-d0e9667b741f
# ╟─a800ec25-354d-4370-958b-05b06b278ad8
# ╟─32c8450e-fcfc-4292-a5c6-babeed7bfab9
# ╟─991ce7b9-c99e-4e23-b53b-643494d8dad1
# ╟─0a3e7769-487e-4a28-9c77-5e08f6667203
# ╟─5e7aa912-abba-4f75-9217-14e2204f15b5
# ╟─9389e8bf-0959-44d4-9a79-784357997d33
# ╟─b18b9057-79ef-4473-8878-855826c0467b
# ╟─aaead9f6-a21e-4288-95a9-9138f7aefefc
# ╟─208dbc9f-57bb-4c08-a0c1-9262bd665c27
# ╟─73090143-3914-4b7f-b73b-d8469c45a491
# ╟─97c90eb0-c6ac-4782-9f43-084fb0f688ad
# ╟─1cfb8992-1de2-4f63-9135-eff34d370e67
# ╟─9cbd31fb-1927-4bea-a8c4-74851c250797
# ╟─62844d27-a061-49aa-bc0f-236df6e67b72
# ╠═8128bbbb-8e5a-4891-88a8-127e8bdd9246
# ╠═9bc5ff9c-77a5-45c0-a9dd-b286fe34d658
# ╠═572e8630-9fac-4aea-8ae7-1d75d546a8ca
# ╟─0ef17be4-8159-42d4-a862-3d5a77af19f3
# ╟─0c4c9c3a-e533-476f-be14-56a5a010f611
# ╟─0e37b191-da47-4066-b7e2-8c883387b730
# ╠═67021d14-f5fd-4da6-8702-83833b5ac848
# ╟─33dbf434-7d91-48a8-a200-35499993cc1a
# ╟─1f0e2b6c-4651-4133-aeef-81939fed926a
# ╠═a07d7d3e-a469-4489-ac15-d6aa05774300
# ╠═63ca826f-8e9e-4dbe-891d-b6e7b5855d55
# ╟─87dc6cfe-44e9-4604-a6c1-d2a6fef17328
# ╟─037d2ac9-9f71-4a84-890a-223a7900cc41
# ╠═25c5ce38-4b53-4eba-9569-24ccc1ed05c8
# ╠═ad360374-0437-470c-ab87-7b0f3c398454
# ╠═5c6e91a1-ac1b-4579-9c7e-bd484248838f
# ╠═fcd8b5cb-9bd3-4373-96ae-65f1dadbd714
# ╠═9933af7c-7b29-4250-83c4-4b2ccf2b9055
# ╟─5f0818fe-b47c-4a7b-9116-646f7a62e374
# ╟─c3ec5291-2f3f-405f-a04f-b0e7df9770b4
# ╟─fc22cc31-2ffc-430e-9d9a-e0604f13c369
# ╟─6a6e762c-6ad8-4939-855e-0cfa98052438
# ╠═00a1ff11-8d26-47fb-8535-cfa8282a2111
# ╠═ef13e58e-4a84-435f-bbfb-280bd04bb1b7
# ╠═86c12ab8-163f-43bd-8f3d-248ef2555e97
# ╠═2eced09d-30ed-4448-96ab-80348d2bba17
# ╠═efbb1285-d7b3-4509-9151-29935649c6cd
# ╠═287a3417-1b7a-4a6d-8784-f1b7a6d6ff25
# ╠═8632c027-c552-4fe4-8074-16a968b217b6
# ╟─0f4f7370-526a-494d-a668-d2d95e47298c
# ╟─89a8f473-0440-4792-842e-e877c2eb93d7
# ╟─21303eb5-eaed-48be-8814-47dd6ad393aa
# ╟─4e20cb12-51f3-4b57-9057-392dffbc4af6
# ╟─9ef93e1f-0cd3-4175-bd60-8a1dad69279d
# ╟─10612973-ee18-4382-9800-ae33d2520742
# ╟─96dec338-79be-41b4-810e-00d95372b4d0
# ╟─5be24375-6ee6-4394-8587-45dded4e805a
# ╟─7007c64a-e990-49be-9829-f2662d671bd4
# ╟─8b1237c7-e5c1-428d-8e7f-26a243387329
# ╟─edf1fa49-d50c-49ba-92f0-9a87e8fcb839
# ╟─e2fae900-c222-4eee-9c94-959bfe68987e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
