### A Pluto.jl notebook ###
# v0.19.32

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
	using PlutoUI
end

# ╔═╡ 9f51f0da-2f32-4b34-b510-106991af5e9a
md"""*Notebook version*: **1.1.0** *See version info*: $(@bind showversions CheckBox())"""

# ╔═╡ cf04fb10-c82a-4f99-84c6-24fb2da174ce
begin
	if showversions
		md"""
- **1.1.0**: starting work on feature matrix
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

# ╔═╡ 26a77be4-1ae4-42d0-befa-37bfe7627765
md"""Map terms in matrix to values for each of

- place
- voice
- manner
"""

# ╔═╡ fdd8fc52-ce1a-47f4-a060-660e710542e0
md"""Then offer choice of property and show similarity matrix
"""

# ╔═╡ c23798ab-e68f-43c0-8678-4e89468804ef
md"""Maybe offer a cumluative score similarity matrix?"""

# ╔═╡ d575f55c-35fc-458d-a014-882aaddf8125
html"""

<br/><br/><br/><br/><br/><br/><br/>

<br/><br/><br/><br/><br/><br/><br/>

<br/><br/><br/><br/><br/><br/><br/>
"""

# ╔═╡ fa737dfb-8306-4eaf-8554-6d473c8e8e60
md"""> ## Stuff behind the scenes you can ignore


> ### Source data
>
> Read data from file and organize it into a 2-dimensional matrix,
> with each row representing a word and each column a language.

"""

# ╔═╡ d14eb600-90eb-4e06-94cf-b3fba0ff2378

f = "data.cex"

# ╔═╡ cc80b08c-98b3-4ad3-b6b4-af0c250634ef
langnames = split(readlines(f)[1],"|")	

# ╔═╡ 8c520beb-0e2f-406c-9e64-e9a301a8d319
langnames

# ╔═╡ 020da4a6-3251-49bc-bbb8-19339965a53b
srcdata = readlines(f)[2:end]

# ╔═╡ cf0bf814-7679-40b3-ae0f-8b0dbdde5834
md""" # Language evolution

## Can we reconstruct an evolutionary tree for languages?

You can use this notebook to compare observations about $(length(srcdata)) vocabulary items in $(length(langnames)) languages.

You can think of each language as a species, and each vocabulary item as a location in the lexical DNA of the species.

Using the data about individual vocabulary items to group species together, you can apply the same principles of parsimony that you use in studying biology to derive an evolutionary tree for the $(length(langnames)) languages covered here.

"""

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

# ╔═╡ bb62b466-3b45-4b0e-b9ed-d10d1a9d5a0f
featuremtrx

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

# ╔═╡ 443e2b97-445b-48bc-8934-526ff00c315f
md""">### User interface: build user-selectable menu
>
> Extract the first column of the data matrix (presumed to be English), and
> build a `Select` menu from it.
"""

# ╔═╡ d17775e2-7d54-472a-b719-6bcb4b5070ec
english = featuremtrx[: , 1]

# ╔═╡ 034ac389-be75-43a7-bfe7-a976a7dae8b7
md"""

## Overview of what this notebook does


Each term in the homework assignment's list of *$(length(english)) English terms* is aligned with a corresponding term (where one exists) in *$(length(langnames) - 1) other languages* that we documented: *$(join(langnames[2:end - 1], ", "))*, and *$(langnames[end])*. The notebook analyzes terms by looking at the *initial* sound of the word: a single consonant sound or vowel sound. 

Consonant sounds are categorized on three criteria, which we will introduce in class:

- the place of articulation
- the manner of articulation
- whether the sound is voiced or unvoiced 


When you select a term, the categorization of the initial sound of each word is  summarized in a table so that you can easily see correspondences across the set of languages surveyed.
"""

# ╔═╡ 3fa6ffb2-8e09-40dc-9356-47743e912a32
md"""From the following alphabetized list of $(length(english)) English terms, choose one to compare with terms in other languages:

"""

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

# ╔═╡ cba0774e-6ffa-4312-ba0a-2ebcfc3c1be4
# Construct menu for selecting term to examine
begin
	menu = Pair{Int, String}[0 => ""]
	for (i,w) in enumerate(featuremtrx[:, 1])
		push!(menu, i => w)
	end
end

# ╔═╡ 499181ee-1c7b-49ff-ab3a-1889ae285d1d
md"""*English term*: $(@bind termidx Select(menu))"""

# ╔═╡ d6fa7afc-d3e3-4205-8d35-639dee64cfc2
begin
	if termidx > 0
		lines = ["### Phonology of words corresponding to English *$(featuremtrx[ termidx, 1])*",
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "d8b0bbb312600ec81f2769bd72048a77429debd9"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

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
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

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

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
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
# ╟─3fa6ffb2-8e09-40dc-9356-47743e912a32
# ╟─499181ee-1c7b-49ff-ab3a-1889ae285d1d
# ╟─d6fa7afc-d3e3-4205-8d35-639dee64cfc2
# ╠═8c520beb-0e2f-406c-9e64-e9a301a8d319
# ╠═bb62b466-3b45-4b0e-b9ed-d10d1a9d5a0f
# ╟─26a77be4-1ae4-42d0-befa-37bfe7627765
# ╟─fdd8fc52-ce1a-47f4-a060-660e710542e0
# ╟─c23798ab-e68f-43c0-8678-4e89468804ef
# ╟─d575f55c-35fc-458d-a014-882aaddf8125
# ╟─fa737dfb-8306-4eaf-8554-6d473c8e8e60
# ╟─d14eb600-90eb-4e06-94cf-b3fba0ff2378
# ╟─cc80b08c-98b3-4ad3-b6b4-af0c250634ef
# ╟─020da4a6-3251-49bc-bbb8-19339965a53b
# ╟─fb63a544-ca46-43e4-810f-af5a6ae526e5
# ╟─5e05badd-982c-48e5-9111-da5180e7616a
# ╟─3946304a-a0db-418d-b470-d8b035d42776
# ╟─987fd8d1-6f47-4db9-8338-d5889ddd8e09
# ╟─b8351248-9abb-487d-8e8f-151d01c83762
# ╟─4bc2cf7d-a2f2-4851-a93c-fc99f9bb450b
# ╟─1c6ee4cd-fa93-4733-8ac1-add2b35f664c
# ╟─443e2b97-445b-48bc-8934-526ff00c315f
# ╠═d17775e2-7d54-472a-b719-6bcb4b5070ec
# ╠═cba0774e-6ffa-4312-ba0a-2ebcfc3c1be4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
