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

# ╔═╡ d6d9ea5e-9895-4013-871c-8cbeb88820cb
begin
	using Downloads
	using PlutoUI
	using VectorAlignments
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

# ╔═╡ 0f853ac2-72f4-4108-88e4-44948bb49831
"""Find candidates for proper names in a text."""
function findpn(txt)
	tkns = split(txt) |> unique
	uc = filter(tkns) do wd
		isuppercase(wd[1])
	end
	lc = filter(tkns) do wd
		! isuppercase(wd[1])
	end
	filter(uc) do wd
		(lowercase(wd) in lc) == false
	end
end

# ╔═╡ 25f4a836-b4d8-47da-9c93-3f9df2d81ecf
"""Complete this function."""
function tokenizetext(txt; droppn = true)
	tidier = filter(txt) do c
		#c == ' ' || isletter(c)
		! ispunct(c) && ! isdigit(c)
	end
	lctkns = split(lowercase(tidier))
	if droppn
		pnlist = findpn(tidier) .|> lowercase
		filter(lctkns) do tkn
			(tkn in pnlist) == false
		end
	else
		lctkns
	end
end

# ╔═╡ 1bd3e785-0e51-4500-ac4a-d0e9667b741f
md"""## Overview of corpus"""

# ╔═╡ 70689e61-2ca3-496f-96b0-9598ecbf94a6
md"""!!! note "Select books"

    Check books of the Bible to include in your analysis, then use the `Submit` button to set your list. 
"""

# ╔═╡ b18b9057-79ef-4473-8878-855826c0467b
md"""## Selected contents"""

# ╔═╡ 306f9e06-3f82-45c2-9c29-2efd51bdc3e9
md"""*Number of vocab items to compare*: $(@bind ntokens confirm(Slider(100:10:4000, show_value=true)))"""

# ╔═╡ 97c90eb0-c6ac-4782-9f43-084fb0f688ad
html"""
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ 1cfb8992-1de2-4f63-9135-eff34d370e67
md"""> # Stuff you don't need to look at"""

# ╔═╡ 55c18fd4-0e8f-41fd-b2fe-93bd4dabbb82
md"""!!! tip "Under the hood"

    The rest of this notebook does a lot of background work: it loads texts and sets up data for the user interface at the top of the notebook. Different functions are grouped together under headings if you want to look at how anything is done.

"""

# ╔═╡ 9cbd31fb-1927-4bea-a8c4-74851c250797
md"""> ## Total SCS and feature table of scores"""

# ╔═╡ 9bc5ff9c-77a5-45c0-a9dd-b286fe34d658
#tokenscores = [normscores(tlist) for tlist in selectedtokens]

# ╔═╡ 572e8630-9fac-4aea-8ae7-1d75d546a8ca
#sort(tokenscores[1], byvalue = true, rev = true)

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

# ╔═╡ fc22cc31-2ffc-430e-9d9a-e0604f13c369
#stopcandidates = collect(keys(allfreqs))[1:n]

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
	"engwyc2017_vpl.txt",
	"eng-Brenton_vpl.txt"
	
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

# ╔═╡ 2d019c52-854f-415e-acec-8933fdfb32ae
engmenu = filter(map(datalines[2:end]) do ln
	cols = split(ln, "|")
	cols[4] in filenames ? string(cols[4]) => string(cols[1]) : "" => ""
end) do pr
	! isempty(pr[1])
end

# ╔═╡ fb190754-943b-43f8-b349-1182791b7118
@bind engchoice confirm(MultiCheckBox(engmenu, select_all = true))

# ╔═╡ 33dbf434-7d91-48a8-a200-35499993cc1a
labels = [textdict[fname] for fname in engchoice]

# ╔═╡ e2fae900-c222-4eee-9c94-959bfe68987e
textdata = isempty(engchoice) ? [] : map(engchoice) do f
	readdata(baseurl * f)
end

# ╔═╡ 67021d14-f5fd-4da6-8702-83833b5ac848
map(v -> length(v), textdata)

# ╔═╡ 5be24375-6ee6-4394-8587-45dded4e805a
citable = [parselinesformat(txt, filenames[i]) for (i,txt) in enumerate(textdata)]

# ╔═╡ 1f0e2b6c-4651-4133-aeef-81939fed926a
books = [unique(map(psg -> psg.book, txt)) for txt in citable]

# ╔═╡ aaead9f6-a21e-4288-95a9-9138f7aefefc
@bind booklist confirm(MultiCheckBox((books[1]), select_all=true))

# ╔═╡ 208dbc9f-57bb-4c08-a0c1-9262bd665c27
md"""*Contents of translations for book(s)* **$(join(booklist, ", "))**:"""

# ╔═╡ a2280dcb-79b9-4bfb-9fab-f6e02c6c41b4
booklist

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

# ╔═╡ 9933af7c-7b29-4250-83c4-4b2ccf2b9055
filteredtokens = unique.(selectedtokens) .|> sort# [sort(filter(t -> ! (t in stoppers), tkns)) for tkns in selectedtokens]

# ╔═╡ 176158ff-fa52-453e-a30b-755462a8fb04
filteredtokens[1] |> length

# ╔═╡ a6fa7ae2-9d8f-499f-9d73-d0e8bad3d8e5
tokensdata = if isempty(filteredtokens)
	[]
else
	map(filteredtokens) do v
		if length(v) >= ntokens
			v[1:ntokens]
		else
			v
		end
	end
end

# ╔═╡ 05666760-2908-4dee-95dc-7b80b9d0008a
mtrx = isempty(tokensdata) ? nothing : featurematrix(tokensdata...)

# ╔═╡ 2e674a8e-fe3f-4788-a21f-8fc5c0efea6f
mrows, mcols = size(mtrx)

# ╔═╡ 96e54e52-d6c6-47b1-b8c8-3ef6d0de0b5d
md"""*Number of comparisons to display*: $(@bind rowstoshow confirm(Slider(10:5:mrows, show_value=true)))"""

# ╔═╡ bb073fd6-6314-4250-9a2c-6b580d1dd279
mtrx[2,:]

# ╔═╡ 67bac9d4-1829-459d-acf7-aecb13aabfc7
map(v -> length(v), tokensdata)

# ╔═╡ efbb1285-d7b3-4509-9151-29935649c6cd
tokenfreqs = [OrderedDict(countmap(tkns)) for tkns in filteredtokens]

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

# ╔═╡ be270b6a-5ca6-494f-b040-59da310132eb
engchoice

# ╔═╡ 2a33d07e-2646-41e5-922d-816a9fea28d8
md"""> ## Remove work on stop words"""

# ╔═╡ 991ce7b9-c99e-4e23-b53b-643494d8dad1
#= md"""!!! note "Instructions"

    Choose stop words from a list of `n` most frequent terms across all texts, then use the `Submit` button.
"""
=#

# ╔═╡ 5e7aa912-abba-4f75-9217-14e2204f15b5
# @bind stoppers confirm(MultiCheckBox(stopcandidates, select_all = true))

# ╔═╡ 0a3e7769-487e-4a28-9c77-5e08f6667203
#md"""*Value for* `n`: $(@bind n Slider(10:10:500, show_value=true))"""

# ╔═╡ 32c8450e-fcfc-4292-a5c6-babeed7bfab9
#md"""## "Stop words" to ignore"""

# ╔═╡ bdfc8a60-f7bf-48e5-a51c-13f650fd708c
md"""> ## Display feature matrix"""

# ╔═╡ da85c72e-93bc-442b-b786-c8164d093594
"""Format a matrix as a markdown table."""
function mdtable(m, labels, limit)
	
	r, c = size(m)
	mdlines = ["| " *  join(labels, " | " ) * " |",
		repeat("| --- ", length(labels)) * " |"
	]
	for r in 1:limit
		row = "| " * join(m[r,:], " | ") * " |"
		push!(mdlines, row)
	end

	join(mdlines, "\n")
	
end

# ╔═╡ 2ce4ddc9-b68f-4e2b-a17e-5865137b8168
mdtable(mtrx, labels, rowstoshow) |> Markdown.parse

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
VectorAlignments = "137e0234-31ad-43b7-8b27-b236525e28e1"

[compat]
OrderedCollections = "~1.6.3"
PlutoUI = "~0.7.58"
StatsBase = "~0.34.2"
VectorAlignments = "~0.2.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.1"
manifest_format = "2.0"
project_hash = "f1a119a346f326a7d7e9b2c7d603701099a2405e"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

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
version = "1.1.0+0"

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

[[deps.DeepDiffs]]
git-tree-sha1 = "9824894295b62a6a4ab6adf1c7bf337b3a9ca34c"
uuid = "ab62b9b5-e342-54a8-a765-a90f495de1a6"
version = "1.2.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "AbstractTrees", "Base64", "CodecZlib", "Dates", "DocStringExtensions", "Downloads", "Git", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "MarkdownAST", "Pkg", "PrecompileTools", "REPL", "RegistryInstances", "SHA", "TOML", "Test", "Unicode"]
git-tree-sha1 = "4a40af50e8b24333b9ec6892546d9ca5724228eb"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "1.3.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Git]]
deps = ["Git_jll"]
git-tree-sha1 = "04eff47b1354d702c3a85e8ab23d539bb7d5957e"
uuid = "d7ba0133-e1db-5d97-8f8c-041e4b3a1eb2"
version = "1.3.1"

[[deps.Git_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "LibCURL_jll", "Libdl", "Libiconv_jll", "OpenSSL_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "12945451c5d0e2d0dca0724c3a8d6448b46bbdf9"
uuid = "f8c6e375-362e-5223-8a59-34ff63f689eb"
version = "2.44.0+1"

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

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "8f7f3cabab0fd1800699663533b6d5cb3fc0e612"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.2.2"

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

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

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

[[deps.MarkdownAST]]
deps = ["AbstractTrees", "Markdown"]
git-tree-sha1 = "465a70f0fc7d443a00dcdc3267a497397b8a3899"
uuid = "d0879d2d-cac2-40c8-9cee-1863dc0c7391"
version = "0.1.2"

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
version = "0.3.23+4"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60e3045590bd104a16fefb12836c00c0ef8c7f8c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

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

[[deps.RegistryInstances]]
deps = ["LazilyInitializedFields", "Pkg", "TOML", "Tar"]
git-tree-sha1 = "ffd19052caf598b8653b99404058fce14828be51"
uuid = "2792f1a3-b283-48e8-9a74-f99dce5104f3"
version = "0.1.0"

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

[[deps.TestSetExtensions]]
deps = ["DeepDiffs", "Distributed", "Test"]
git-tree-sha1 = "3a2919a78b04c29a1a57b05e1618e473162b15d0"
uuid = "98d24dd4-01ad-11ea-1b02-c9a08f80db04"
version = "2.0.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "3caa21522e7efac1ba21834a03734c57b4611c7e"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.4"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

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

[[deps.VectorAlignments]]
deps = ["DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "83576524528063a8e2829f488a2ad4ca24132b62"
uuid = "137e0234-31ad-43b7-8b27-b236525e28e1"
version = "0.2.5"

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
# ╠═d6d9ea5e-9895-4013-871c-8cbeb88820cb
# ╠═66deb0e9-f3f7-4a49-a2e2-b52c887ba182
# ╟─8389ee5e-d993-11ee-1cd3-ff3165294839
# ╟─616eab90-8a7b-497d-b576-a254fe23dca3
# ╠═25f4a836-b4d8-47da-9c93-3f9df2d81ecf
# ╟─0f853ac2-72f4-4108-88e4-44948bb49831
# ╟─1bd3e785-0e51-4500-ac4a-d0e9667b741f
# ╟─fb190754-943b-43f8-b349-1182791b7118
# ╟─a800ec25-354d-4370-958b-05b06b278ad8
# ╟─70689e61-2ca3-496f-96b0-9598ecbf94a6
# ╟─aaead9f6-a21e-4288-95a9-9138f7aefefc
# ╟─73090143-3914-4b7f-b73b-d8469c45a491
# ╟─b18b9057-79ef-4473-8878-855826c0467b
# ╟─208dbc9f-57bb-4c08-a0c1-9262bd665c27
# ╟─306f9e06-3f82-45c2-9c29-2efd51bdc3e9
# ╠═176158ff-fa52-453e-a30b-755462a8fb04
# ╟─05666760-2908-4dee-95dc-7b80b9d0008a
# ╟─96e54e52-d6c6-47b1-b8c8-3ef6d0de0b5d
# ╠═2ce4ddc9-b68f-4e2b-a17e-5865137b8168
# ╠═2e674a8e-fe3f-4788-a21f-8fc5c0efea6f
# ╠═bb073fd6-6314-4250-9a2c-6b580d1dd279
# ╟─a6fa7ae2-9d8f-499f-9d73-d0e8bad3d8e5
# ╠═67bac9d4-1829-459d-acf7-aecb13aabfc7
# ╟─97c90eb0-c6ac-4782-9f43-084fb0f688ad
# ╟─1cfb8992-1de2-4f63-9135-eff34d370e67
# ╟─55c18fd4-0e8f-41fd-b2fe-93bd4dabbb82
# ╟─9cbd31fb-1927-4bea-a8c4-74851c250797
# ╟─62844d27-a061-49aa-bc0f-236df6e67b72
# ╠═8128bbbb-8e5a-4891-88a8-127e8bdd9246
# ╠═9bc5ff9c-77a5-45c0-a9dd-b286fe34d658
# ╠═572e8630-9fac-4aea-8ae7-1d75d546a8ca
# ╟─0ef17be4-8159-42d4-a862-3d5a77af19f3
# ╟─0c4c9c3a-e533-476f-be14-56a5a010f611
# ╟─0e37b191-da47-4066-b7e2-8c883387b730
# ╠═67021d14-f5fd-4da6-8702-83833b5ac848
# ╠═33dbf434-7d91-48a8-a200-35499993cc1a
# ╟─1f0e2b6c-4651-4133-aeef-81939fed926a
# ╠═a07d7d3e-a469-4489-ac15-d6aa05774300
# ╠═63ca826f-8e9e-4dbe-891d-b6e7b5855d55
# ╟─87dc6cfe-44e9-4604-a6c1-d2a6fef17328
# ╠═a2280dcb-79b9-4bfb-9fab-f6e02c6c41b4
# ╠═037d2ac9-9f71-4a84-890a-223a7900cc41
# ╠═25c5ce38-4b53-4eba-9569-24ccc1ed05c8
# ╠═ad360374-0437-470c-ab87-7b0f3c398454
# ╠═5c6e91a1-ac1b-4579-9c7e-bd484248838f
# ╠═fcd8b5cb-9bd3-4373-96ae-65f1dadbd714
# ╠═9933af7c-7b29-4250-83c4-4b2ccf2b9055
# ╟─5f0818fe-b47c-4a7b-9116-646f7a62e374
# ╟─c3ec5291-2f3f-405f-a04f-b0e7df9770b4
# ╟─fc22cc31-2ffc-430e-9d9a-e0604f13c369
# ╠═6a6e762c-6ad8-4939-855e-0cfa98052438
# ╟─00a1ff11-8d26-47fb-8535-cfa8282a2111
# ╠═ef13e58e-4a84-435f-bbfb-280bd04bb1b7
# ╟─86c12ab8-163f-43bd-8f3d-248ef2555e97
# ╟─2eced09d-30ed-4448-96ab-80348d2bba17
# ╟─efbb1285-d7b3-4509-9151-29935649c6cd
# ╠═287a3417-1b7a-4a6d-8784-f1b7a6d6ff25
# ╠═8632c027-c552-4fe4-8074-16a968b217b6
# ╟─0f4f7370-526a-494d-a668-d2d95e47298c
# ╟─89a8f473-0440-4792-842e-e877c2eb93d7
# ╠═21303eb5-eaed-48be-8814-47dd6ad393aa
# ╠═4e20cb12-51f3-4b57-9057-392dffbc4af6
# ╟─9ef93e1f-0cd3-4175-bd60-8a1dad69279d
# ╟─10612973-ee18-4382-9800-ae33d2520742
# ╠═96dec338-79be-41b4-810e-00d95372b4d0
# ╠═5be24375-6ee6-4394-8587-45dded4e805a
# ╟─7007c64a-e990-49be-9829-f2662d671bd4
# ╠═8b1237c7-e5c1-428d-8e7f-26a243387329
# ╠═edf1fa49-d50c-49ba-92f0-9a87e8fcb839
# ╠═e2fae900-c222-4eee-9c94-959bfe68987e
# ╠═be270b6a-5ca6-494f-b040-59da310132eb
# ╟─2d019c52-854f-415e-acec-8933fdfb32ae
# ╟─2a33d07e-2646-41e5-922d-816a9fea28d8
# ╠═991ce7b9-c99e-4e23-b53b-643494d8dad1
# ╠═5e7aa912-abba-4f75-9217-14e2204f15b5
# ╠═0a3e7769-487e-4a28-9c77-5e08f6667203
# ╠═32c8450e-fcfc-4292-a5c6-babeed7bfab9
# ╟─bdfc8a60-f7bf-48e5-a51c-13f650fd708c
# ╟─da85c72e-93bc-442b-b786-c8164d093594
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
