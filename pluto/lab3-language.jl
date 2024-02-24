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

# ╔═╡ ec90119e-6c25-4162-8b93-620a6cc4a554
begin
	using PhyloNetworks
	using Downloads
	using HypertextLiteral
	using PlutoUI
	md"""*Unhide this cell to see the Julia environment.*"""
end

# ╔═╡ 9f51f0da-2f32-4b34-b510-106991af5e9a
md"""*Notebook version*: **TBA** *See version info*: $(@bind showversions CheckBox())"""

# ╔═╡ cf04fb10-c82a-4f99-84c6-24fb2da174ce
begin
	if showversions
		md"""
- **1.0.0**: initial release version to use in Bio114 class meeting in S'23.
		
"""
	else
		md""
	end
end

# ╔═╡ 833be39a-4eba-46f1-a009-b0a53c5a7433
md"""


## Limitations of this notebook

For purposes of comparing languages, this notebook is limited in the following ways:

- it offers only a phonetic comparison of vocabulary: there is no consideration of language structure or syntax
- it only looks at the phonetic similarity of the *initial* sound
- the phonetic model of sounds is simplistic
- some  consonant sounds are not analyzed when the same alphabetic symbol is used for very different sounds in the writing systems used for different languages (e.g., `h`, `j` and `y` in different languages using the Roman alphabet)

"""

# ╔═╡ cffb1c37-f231-4354-bf52-e50070834e41
md"""
### Questions to think about in comparing terms

- what observations about the initial sound of a word might suggest that words descend from a common ancestor language?  Linguists would say that such words are *cognate*: like  *homology* in biology, this means they have a common ancestor.
- can we distinguish similarities that might be due to *borrowing*?  Like *analogy* in biology, this means the terms are similar but do *not* have a common origin.  Unlike analogy in biology, word borrowings may be directly taken from another language.
- how can you use observations about multiple features to group more closely related languages together?  How can you decide whether one group is prior to another in evolutionary terms?

"""

# ╔═╡ e6f5fe38-cb09-11ed-093a-89974c867831
md"""## Comparison of phonetic features"""

# ╔═╡ 8e1a8736-2ca4-4d04-802f-4ef51c9219ac
md"""## Draw a tree"""

# ╔═╡ e4d4df04-5ad6-4bea-86c3-6113a77cdd5b
md"""*Start your tree by copying and pasting this list into your diagram*:"""

# ╔═╡ 7df0a9ab-7c7e-4d2b-a284-0a1ca2967ef3
md"""## Evaluate your tree"""

# ╔═╡ b50fee84-95c6-4e2b-b28e-ddf379e211d4
md"""*Choose dataset to analyze*: $(@bind dataset Select(["f22" => "Fall '22 dataset", "s24" => "Spring '24 dataset"], default = "s24"))"""

# ╔═╡ d575f55c-35fc-458d-a014-882aaddf8125
html"""

<br/><br/><br/><br/><br/><br/><br/>

<br/><br/><br/><br/><br/><br/><br/>

<br/><br/><br/><br/><br/><br/><br/>
"""

# ╔═╡ 26afc76c-211d-4b78-8f8f-c6de2cf2be83
md"""> Computation of phonology values"""

# ╔═╡ 281fe574-cf9d-4a19-8557-52cfe13fd9f1
function featurelabels(idxlist, features)
	if isempty(idxlist)
		[]
	else
		termlist = []
		for i in idxlist
			t = features[i, 1]
			for phonoprop in ["place","voice","manner"]
				push!(termlist, string(t,"_", phonoprop))
			end
		end
		termlist
	end
end

# ╔═╡ ca496151-93e8-418b-8906-151b653f1541
codingdict = Dict([
	"labial" => 1,
	"dental" => 2,
	"palatal" => 3,
	"vowel" => 4,
	"voiced" => 1,
	"unvoiced" => 2,
	"plosive" => 1,
	"fricative" => 2
])


# ╔═╡ 8c079fc8-50c1-4d1d-8708-82139a7136b2
"""Encode data in a `Phonology` structure as integer values for 
computation of parsimony in a tree model.
"""
function encodestruct(phono, codedict = codingdict)
	if isnothing(phono)
		[0,0,0]
	else
		# place, voice, manner
		placeval = haskey(codedict, phono.place) ? codedict[phono.place] : 0
		voiceval = haskey(codedict, phono.voice) ? codedict[phono.voice] : 0
		mannerval = haskey(codedict, phono.manner) ? codedict[phono.manner] : 0
		
		[placeval,voiceval,mannerval]
	end
end

# ╔═╡ fa737dfb-8306-4eaf-8554-6d473c8e8e60
md"""> ## Stuff behind the scenes you can ignore


> ### Source data
>
> Read data from file and organize it into a 2-dimensional matrix,
> with each row representing a word and each column a language.

"""

# ╔═╡ 59ce4fe7-c8fc-4b4a-bf15-ed4a7b3ba95e
url = "https://raw.githubusercontent.com/neelsmith/papyrus_to_pixels/main/data/languages/$(dataset).cex"

# ╔═╡ 8cf14601-04ac-4197-b05a-cecdaea21c44
"Download data and format for analysis."
function loaddata(u)
	tmp = Downloads.download(u)
	all_lines = readlines(tmp)
	rm(tmp)
	lang_names = split(all_lines[1], "|")
	datalines =  filter(ln -> ! isempty(ln), all_lines[2:end]) 
	lang_names, datalines
end

# ╔═╡ cc80b08c-98b3-4ad3-b6b4-af0c250634ef
langnames, srcdata = loaddata(url)

# ╔═╡ cf0bf814-7679-40b3-ae0f-8b0dbdde5834
md""" # Language evolution

## Can we reconstruct an evolutionary tree for languages?

You can use this notebook to compare observations about $(length(srcdata)) vocabulary items in $(length(langnames)) languages.

You can think of each language as a species, and each vocabulary item as a location in the lexical DNA of the species.

Using the data about individual vocabulary items to group species together, you can apply the same principles of parsimony that you use in studying biology to derive an evolutionary tree for the $(length(langnames)) languages covered here.

"""

# ╔═╡ fc71a3b1-5be6-4f83-a511-b316d8e3790d
join(langnames,"\n\n") |> Markdown.parse

# ╔═╡ 020da4a6-3251-49bc-bbb8-19339965a53b


# ╔═╡ fb63a544-ca46-43e4-810f-af5a6ae526e5
# Read data into a set of global arrays
featuremtrx = begin
	datamtrx =  Array{String}(undef, length(srcdata),length(langnames)) 
	for (rownum,ln) in enumerate(srcdata)
		cols = split(ln, "|")
		if length(cols) == length(langnames)
			for (colnum, col) in enumerate(cols)
				datamtrx[rownum, colnum] = col
			end
		end
	end
	datamtrx
end

# ╔═╡ 5e05badd-982c-48e5-9111-da5180e7616a
# Read data into a set of global arrays
begin
	for ln in srcdata
		cols = split(ln, "|")
		if length(cols) == 7 
			push!(english, cols[1])
			push!(dutch, cols[2])
			push!(french, cols[3])
			push!(german, cols[4])
			push!(latin, cols[5])
			push!(spanish, cols[6])
			push!(turkish, cols[7])
			
			
		end
	end
end

# ╔═╡ 3946304a-a0db-418d-b470-d8b035d42776
md"""> ### Phonological analysis
>
> Phonology data and functions to analyze and look up phonology for the initial sound of a string"""

# ╔═╡ 987fd8d1-6f47-4db9-8338-d5889ddd8e09
"""Structure for phonology of a consonant"""
struct Phonology
	place
	voice
	manner
end
	

# ╔═╡ b8351248-9abb-487d-8e8f-151d01c83762
"Dictionary mapping consonant sounds to `Phonology` structures."
phonologydata = Dict(
	"b" => Phonology("labial", "voiced", "plosive"),
	"p" => Phonology("labial", "unvoiced", "plosive"),
	"f" => Phonology("labial", "unvoiced", "fricative"),
	"v" => Phonology("labial", "voiced", "fricative"),



	"б" => Phonology("labial", "voiced", "plosive"),
	"в" => Phonology("labial", "voiced", "fricative"),
	"п" => Phonology("labial", "unvoiced", "plosive"),

	
	"d" => Phonology("dental", "voiced", "plosive"),
	"t" => Phonology("dental", "unvoiced", "plosive"),
	"th" => Phonology("dental", "unvoiced", "fricative"),
	"к" => Phonology("palatal", "unvoiced", "plosive"),

	"д" =>  Phonology("dental", "voiced", "plosive"),
	"т" => Phonology("dental", "unvoiced", "plosive"),
	

	"g" => Phonology("palatal", "voiced", "plosive"),
	"k" => Phonology("palatal", "unvoiced", "plosive"),
	"г"  => Phonology("palatal", "voiced", "plosive"),

	"ч" => Phonology("palatal", "unvoiced", "fricative"),
	
	"qu" => Phonology("labiovelar", "unvoiced", "plosive"),

	
	"m" => Phonology("liquid", "", ""),
	"n" => Phonology("liquid", "", ""),
	"r" => Phonology("liquid", "", ""),
	"l" => Phonology("liquid", "", ""),
	
	"н"  => Phonology("liquid", "", ""),
	"м" => Phonology("liquid", "", ""),
	"л"  => Phonology("liquid", "", ""),

	"р" => Phonology("liquid", "", ""),
		
	"s" => Phonology("sibilant","unvoiced", ""),
	"z" => Phonology("sibilant","voiced", ""),


	"ш"  => Phonology("sibilant","unvoiced", ""),
	"с" => Phonology("sibilant","unvoiced", ""),
	"з"  => Phonology("sibilant","voiced", ""),
	
	"a" => Phonology("vowel","", ""),
	"e" => Phonology("vowel","", ""),
	"i" => Phonology("vowel","", ""),
	"o" => Phonology("vowel","", ""),
	"u" => Phonology("vowel","", ""),

	"а" => Phonology("vowel","", ""),
	"е"  => Phonology("vowel","", ""),
	"о"  => Phonology("vowel","", ""),
)

	


# ╔═╡ 4bc2cf7d-a2f2-4851-a93c-fc99f9bb450b
"""Look up phonology data for a consonant."""
function phonology_for(c, phones)
	cval = lowercase(c) |> string
	if haskey(phones, cval)
		phones[cval]
	else
		nothing
	end
end

# ╔═╡ 1c6ee4cd-fa93-4733-8ac1-add2b35f664c
"""Find initial phoneme in `s`"""
function initialsound(raw)
	if isempty(raw)
		raw
	else
		s = lowercase(raw)
		clusters = ["sh", "sch",
			"th",
			"qu", "cu",
		]
	
		initial = 	s[1]
		for cl in clusters
			if startswith(s, cl)
				initial = cl
			end
		end
		if startswith(s, r"c[ei]")
			initial = "s"
		elseif startswith(s, "cu")
			initial = "qu"
		elseif startswith(s,r"c[ao]")
			initial = "k"
		end
		initial
	end
end

# ╔═╡ b54cf045-15d3-4267-95f8-399fe71e4672
"""Compute numeric features for user's current seledtion of terms."""
function encodeterms(datalines)
	if isempty(datalines)
		[]
	else
		numcols = length(datalines)  * 3
		numrows = length(split(datalines[1], "|"))

		termscores = []
		for ln in datalines # i:i+1 will be your col number
			termlist = split(ln, "|") # these are the terms for each lang.
			phonostructs = [phonology_for(initialsound(wd), phonologydata) for wd in termlist]
			
			phonoscores = [encodestruct(phono) for phono in phonostructs] |> Iterators.flatten |> collect
			push!(termscores, phonoscores) 
		end

		flatscores = termscores |> Iterators.flatten |> collect
		# We now have one vector fo each term. We want to reshape this
		# to have one vector for each language.
		scores = zeros(Int8, numrows, numcols)	
		scoreidx = 0
		for row in 1:numrows
			for col in 1:numcols
				scoreidx = scoreidx + 1
				scores[row,col] = flatscores[scoreidx]
			end
		end
		
		scores 
	end
end

# ╔═╡ 3bf86905-c1a0-447a-b3a6-b45f51beaf1b
"""For a row of data in delimited-text format, compute its Phonology structures
and convert them to numeric representation.

Parameters:

- `delimited`: a string of data delimted by `|`
- `phonologydict`: a dictionary mapping consonant strings to `Phonology` structures
- `codesdict`: a dictionary to use in converting `Phonology` structures to numeric sequences

"""
function coderow(delimited, phonologydict, codesdict = codingdict)
	cols = split(delimited, "|")
	phonostructs = [phonology_for(initialsound(wd), phonologydict) for wd in cols]
	
	digital = map(phonostructs) do phono
		if isnothing(phono)
			[0,0,0]
		else
			encodestruct(phono, codedict = codesdict)
		end
	end
	digital |> Iterators.flatten |> collect
	
	#phonostructs
end

# ╔═╡ 443e2b97-445b-48bc-8934-526ff00c315f
md""">### User interface: build user-selectable menu
>
> Extract the first column of the data matrix (presumed to be English), and
> build a `Select` menu from it.
"""

# ╔═╡ cba0774e-6ffa-4312-ba0a-2ebcfc3c1be4
# Construct menu for selecting term to examine
begin
	menu = Pair{Int, String}[0 => ""]
	for (i,w) in enumerate(featuremtrx[:, 1])
		push!(menu, i => w)
	end
end

# ╔═╡ 034ac389-be75-43a7-bfe7-a976a7dae8b7
md"""

## Overview of what this notebook does


Each term in the homework assignment's list of *$(length(menu)) English terms* is aligned with a corresponding term (where one exists) in *$(length(langnames) - 1) other languages* that we documented: *$(join(langnames[2:end - 1], ", "))*, and *$(langnames[end])*. The notebook analyzes terms by looking at the *initial* sound of the word: a single consonant sound or vowel sound. 

Consonant sounds are categorized on three criteria, which we will introduce in class:

- the place of articulation
- the manner of articulation
- whether the sound is voiced or unvoiced 


When you select a term, the categorization of the initial sound of each word is  summarized in a table so that you can easily see correspondences across the set of languages surveyed.
"""

# ╔═╡ 3fa6ffb2-8e09-40dc-9356-47743e912a32
md"""From the following alphabetized list of $(length(menu[2:end])) English terms, choose one to compare with terms in other languages:

"""

# ╔═╡ 499181ee-1c7b-49ff-ab3a-1889ae285d1d
md"""*English term*: $(@bind termidx Select(menu))"""

# ╔═╡ d6fa7afc-d3e3-4205-8d35-639dee64cfc2
begin
	if termidx > 0
		lines = ["Phonology of words corresponding to English *$(featuremtrx[ termidx, 1])*",
			"",
			"| Language | Term | Place | Voice | Manner |", 
		"| --- | --- | --- |--- | --- |"
		]
		for lang in 1:length(langnames)
			wd = featuremtrx[termidx, lang]			
			wordinitial = initialsound(wd)
			phono = phonology_for(initialsound(wd), phonologydata)
			row = ""
			if isnothing(phono)
				row = "| **" * langnames[lang] * "** | $(wd) | - | - | - |"
			else
				row = "| **" * langnames[lang] * "** | " * join([wd, phono.place, phono.voice, phono.manner], " | ") *  " |"
				
			end
			push!(lines, row)
		
		end
		join(lines, "\n") |> Markdown.parse
		
	else
		md""
	end
end

# ╔═╡ c8f4fd19-e4e9-4277-b4ee-6f073891c8d5
@bind termsidx MultiCheckBox(menu[2:end], select_all=true)

# ╔═╡ 36bdd651-c69c-42d1-baa8-a35dc8a336ac
featurelabels(termsidx, featuremtrx)

# ╔═╡ 1570fe48-d964-4306-9ca8-588fceb8e73a
dataselection = [srcdata[i] for i in termsidx]

# ╔═╡ be3eb016-4474-4089-9e8e-5d87882c5de2
scores = encodeterms(dataselection)

# ╔═╡ 57a98d63-c3c6-451e-baab-50829d6a6d20
"""Implement interpreting Mermaid diagram."""
function mermaid(s)
	@htl """
	<html>
		<body>
			<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"/>
			<script>
				mermaid.initialize({ startOnLoad: true });
			</script>
			<pre class="mermaid">
			$s
			</pre>
		</body>
	</html>"""
end


# ╔═╡ 9dde598a-dd5b-450a-ac0a-88b6eeca2dfc
dirmenu = [
	"BT" => "Bottom to top (BT)",
	"TB" => "Top to bottom (TB)",
	"LR" => "Left to right (LR)",
	"RL" => "Right to left (RL)",
	]

# ╔═╡ 70f93115-a9bc-414f-8aa3-05543b3847f8
md"""*Choose a direction for your tree*: $(@bind direction Select(dirmenu))"""

# ╔═╡ 11d8ffcc-cb70-49cb-b6ae-e2e00a2e2983
languages = """
flowchart $(direction)

English 
"""

# ╔═╡ 572b9936-2301-44ea-90ca-a77d16b78d9f
mermaid(languages)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PhyloNetworks = "33ad39ac-ed31-50eb-9b15-43d0656eaa72"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.5"
PhyloNetworks = "~0.16.3"
PlutoUI = "~0.7.57"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.1"
manifest_format = "2.0"
project_hash = "6f41c9aa6984bdd789aac5e940cfbc4544e55192"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "588e0d680ad1d7201d4c6a804dcb1cd9cba79fbb"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.3"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BioGenerics]]
deps = ["TranscodingStreams"]
git-tree-sha1 = "7bbc085aebc6faa615740b63756e4986c9e85a70"
uuid = "47718e42-2ac5-11e9-14af-e5595289c2ea"
version = "0.1.4"

[[deps.BioSequences]]
deps = ["BioSymbols", "PrecompileTools", "Random", "Twiddle"]
git-tree-sha1 = "6fdba8b4279460fef5674e9aa2dac7ef5be361d5"
uuid = "7e6ae17a-c86d-528c-b3b9-7f778a29fe59"
version = "3.1.6"

[[deps.BioSymbols]]
deps = ["PrecompileTools"]
git-tree-sha1 = "e32a61f028b823a172c75e26865637249bb30dff"
uuid = "3c28c6f8-a34d-59c4-9654-267d177fcfa9"
version = "5.1.3"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "679e69c611fff422038e9e21e270c4197d49d918"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.12"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

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

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "d2c021fbdde94f6cdaa799639adfeeaa17fd67f5"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.13.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "ac67408d9ddf207de5cfa9a97e114352430f01ed"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.16"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "7c302d7a5fec5214eb8a5a4c466dcf7a51fcf169"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.107"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.FASTX]]
deps = ["Automa", "BioGenerics", "PrecompileTools", "StringViews", "TranscodingStreams"]
git-tree-sha1 = "bff5d62bf5e1c382a370ac701bcaea9a24115ac6"
uuid = "c2308a5c-f048-11e8-3e8a-31650f418d12"
version = "2.1.4"
weakdeps = ["BioSequences"]

    [deps.FASTX.extensions]
    BioSequencesExt = "BioSequences"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "166c544477f97bbadc7179ede1c1868e0e9b426b"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.7"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "273bd1cd30768a2fddfa3fd63bbc746ed7249e5f"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.9.0"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

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

[[deps.NLopt]]
deps = ["NLopt_jll"]
git-tree-sha1 = "d1d09c342c3dd9b3bae985b088bd928632e4d79e"
uuid = "76087f3c-5699-56af-9a33-bf431cd00edd"
version = "1.0.1"

    [deps.NLopt.extensions]
    NLoptMathOptInterfaceExt = ["MathOptInterface"]

    [deps.NLopt.weakdeps]
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"

[[deps.NLopt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9b1f15a08f9d00cdb2761dcfa6f453f5d0d6f973"
uuid = "079eb43e-fd8e-5478-9966-2cf3e3edb778"
version = "2.7.1+0"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.PhyloNetworks]]
deps = ["BioSequences", "BioSymbols", "CSV", "Combinatorics", "DataFrames", "DataStructures", "Dates", "Distributed", "Distributions", "FASTX", "Functors", "GLM", "LinearAlgebra", "NLopt", "Printf", "Random", "StaticArrays", "Statistics", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "414065ef095aba2fc7d76d38c43cbdff2ab02943"
uuid = "33ad39ac-ed31-50eb-9b15-43d0656eaa72"
version = "0.16.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "a6783c887ca59ce7e97ed630b74ca1f10aefb74d"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.57"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

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

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

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

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "7b0e9c14c624e435076d19aea1e5cbdec2b9ca37"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.2"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

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

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsAPI", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "5cf6c4583533ee38639f73b880f35fc85f2941e0"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.7.3"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.StringViews]]
git-tree-sha1 = "f7b06677eae2571c888fd686ba88047d8738b0e3"
uuid = "354b36f9-a18e-4713-926e-db85100087ba"
version = "1.3.3"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "54194d92959d8ebaa8e26227dbe3cdefcdcd594f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.3"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.Twiddle]]
git-tree-sha1 = "29509c4862bfb5da9e76eb6937125ab93986270a"
uuid = "7200193e-83a8-5a55-b20d-5d36d44a0795"
version = "1.1.2"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

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
# ╟─ec90119e-6c25-4162-8b93-620a6cc4a554
# ╟─9f51f0da-2f32-4b34-b510-106991af5e9a
# ╟─cf04fb10-c82a-4f99-84c6-24fb2da174ce
# ╟─cf0bf814-7679-40b3-ae0f-8b0dbdde5834
# ╟─034ac389-be75-43a7-bfe7-a976a7dae8b7
# ╟─833be39a-4eba-46f1-a009-b0a53c5a7433
# ╟─cffb1c37-f231-4354-bf52-e50070834e41
# ╟─e6f5fe38-cb09-11ed-093a-89974c867831
# ╟─b50fee84-95c6-4e2b-b28e-ddf379e211d4
# ╟─3fa6ffb2-8e09-40dc-9356-47743e912a32
# ╟─499181ee-1c7b-49ff-ab3a-1889ae285d1d
# ╟─d6fa7afc-d3e3-4205-8d35-639dee64cfc2
# ╟─8e1a8736-2ca4-4d04-802f-4ef51c9219ac
# ╟─70f93115-a9bc-414f-8aa3-05543b3847f8
# ╟─e4d4df04-5ad6-4bea-86c3-6113a77cdd5b
# ╟─fc71a3b1-5be6-4f83-a511-b316d8e3790d
# ╠═11d8ffcc-cb70-49cb-b6ae-e2e00a2e2983
# ╟─572b9936-2301-44ea-90ca-a77d16b78d9f
# ╟─7df0a9ab-7c7e-4d2b-a284-0a1ca2967ef3
# ╟─c8f4fd19-e4e9-4277-b4ee-6f073891c8d5
# ╠═36bdd651-c69c-42d1-baa8-a35dc8a336ac
# ╠═be3eb016-4474-4089-9e8e-5d87882c5de2
# ╟─d575f55c-35fc-458d-a014-882aaddf8125
# ╟─26afc76c-211d-4b78-8f8f-c6de2cf2be83
# ╠═1570fe48-d964-4306-9ca8-588fceb8e73a
# ╟─281fe574-cf9d-4a19-8557-52cfe13fd9f1
# ╟─b54cf045-15d3-4267-95f8-399fe71e4672
# ╟─8c079fc8-50c1-4d1d-8708-82139a7136b2
# ╟─3bf86905-c1a0-447a-b3a6-b45f51beaf1b
# ╟─ca496151-93e8-418b-8906-151b653f1541
# ╟─fa737dfb-8306-4eaf-8554-6d473c8e8e60
# ╟─59ce4fe7-c8fc-4b4a-bf15-ed4a7b3ba95e
# ╠═cc80b08c-98b3-4ad3-b6b4-af0c250634ef
# ╟─8cf14601-04ac-4197-b05a-cecdaea21c44
# ╟─020da4a6-3251-49bc-bbb8-19339965a53b
# ╟─fb63a544-ca46-43e4-810f-af5a6ae526e5
# ╟─5e05badd-982c-48e5-9111-da5180e7616a
# ╟─3946304a-a0db-418d-b470-d8b035d42776
# ╟─987fd8d1-6f47-4db9-8338-d5889ddd8e09
# ╟─b8351248-9abb-487d-8e8f-151d01c83762
# ╟─4bc2cf7d-a2f2-4851-a93c-fc99f9bb450b
# ╟─1c6ee4cd-fa93-4733-8ac1-add2b35f664c
# ╟─443e2b97-445b-48bc-8934-526ff00c315f
# ╠═cba0774e-6ffa-4312-ba0a-2ebcfc3c1be4
# ╟─57a98d63-c3c6-451e-baab-50829d6a6d20
# ╟─9dde598a-dd5b-450a-ac0a-88b6eeca2dfc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
