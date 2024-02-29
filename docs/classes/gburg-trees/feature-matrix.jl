### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 169f4290-9997-47bb-a6e9-c70fb4f26d53
using PlutoUI

# ╔═╡ 40a1fe8a-5540-4f0a-b0bc-732b6648e64e
TableOfContents()

# ╔═╡ 93f2ffe0-d703-11ee-12d0-5b8877a8556e
md"""# Constructing feature matrices for comparison of ordered sequences"""

# ╔═╡ b63828f1-fc98-4ea1-8897-a887ca4ec65f
md"""## Three important concepts

- **longest common subsequence** (LCS):  a Vector with every element that is common to *all* the original sequences. (*This notebook includes a function `lcs` to find that*.)
- **shortest common supersequence** (SCS): a Vector with every element that occurs in *either* of the original sequences.  (*This notebook includes a function `scs` to find that*.)
- **alignment**: a list of vectors, each as long as the shortest commmon supersequence, placing the elements of each vector in the proper parallel position. (*This notebook includes a function `align` to do that*.)

"""

# ╔═╡ c2530727-d9be-4629-bf98-d1a5e1c1e53f
md"""## Examples"""

# ╔═╡ 5432bc6e-1bc3-4df0-87f5-769eab613a53
md"""We want to compare the contents of multiple vectors. They don't need to be of the same length, and could have any kind of content (text tokens, amino acids, anything else), but should all have the same kind of content (so we're comparing text tokens to text tokens, or amino acids to amino acids, or whatever)."""

# ╔═╡ 734fb507-fbec-4405-a53a-de143c622bc2
s1 = split("Now is the time")

# ╔═╡ e301a83e-5bb9-4ba6-bc33-1ddf81ffd20e
s2 = split("Now might be the time")

# ╔═╡ 7ffa65c7-5060-4375-b916-81d61fda6deb
s3 = split("Now is not the time")

# ╔═╡ b9d52f0f-c1d0-47fc-8366-6e120e33659a
s4 = split("Now might not be the time")

# ╔═╡ 9bfa7301-513c-4946-8048-6d5b48952482
md"""
The **longest common subsequence**:
"""

# ╔═╡ 613297b8-05d7-4e65-ba76-a70bb5369321
md"""The **shortest common supersequence**:"""

# ╔═╡ fe23cc02-2b8e-47bc-889b-a8fe1ccaab24
md"""The **alignment**:

"""

# ╔═╡ 3f36e91e-9a89-44d2-b0db-022abb232c62
md"""Here's a tabular display of the alignment:"""

# ╔═╡ 8c91da03-7afa-402a-b53a-d23b436e948c


# ╔═╡ 6f1ed4a1-5d61-4734-bc40-9b8993567796
md"""!!! tip "💡 This is a feature table! 💡"

    ☞ We could use this to **construct an evolutionary tree**!
"""

# ╔═╡ 269ff2a9-88b4-4103-a7e6-d7fd76cc09b6
html"""
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ c1bee1a0-038e-4e85-84dc-4be36e774f02
md"""---

> # Library
> 
> ## Utility functions for working with alignments
"""

# ╔═╡ 87e5bad4-bf52-4163-94a6-803024d1a713
"""Create a matrix scoring the alignment of two sequences, as used in
Needleman-Wunsch algorithm to solve longest common subsequence with dynamic programming.
"""
function alignmentmemo(a, b)
    lengths = zeros(Int, length(a) + 1, length(b) + 1)
    lastx = 0
    lasty = 0
    for (i, x) in enumerate(a)
        for (j, y) in enumerate(b)
            if x == y
                lengths[i+1, j+1] = lengths[i, j] + 1
            else
                lengths[i+1, j+1] = max(lengths[i+1, j], lengths[i, j+1])
            end
        end
    end
    rows, cols = size(lengths)
    lengths
end

# ╔═╡ 7666c1c9-19ac-4a63-a005-74dfa092d3de
alignmentmemo(s1, s2)

# ╔═╡ 3581dfbc-2acf-4cb6-aaea-2d8a06c0a1f0
"""Find shortest common supersequence for two sequences.
Walk back through a matrix of alignment scores to recover
all items in sequences `a` or `b`.
"""
function scspair(a, b)
	m = alignmentmemo(a,b)
    x,y = size(m)

    keepers = []
    while x > 1 && y > 1
        if m[x, y] == m[x-1, y]
            x -= 1
            push!(keepers, a[x])
        elseif m[x, y] == m[x, y-1]
            y -= 1
            push!(keepers, b[y])
        else
            @assert a[x-1] == b[y-1]
            push!(keepers, a[x-1])
            x -= 1
            y -= 1
        end
    end
    keepers |> reverse
end


# ╔═╡ 42db806e-0465-4e65-a8e8-e0443db1d2f0
"""Find shortest common supersequence for a vector of sequences."""
function scs(v...)
	if length(v) < 2
		v
	else 
		scs1 = scspair(v[1], v[2])
        length(v) == 2 ? scs1 : scs(scs1, v[3:end]...)
	end
end

# ╔═╡ bb0d0eb5-d6d0-49f2-bd57-8b7eb2096c98
scs(s1, s2, s3, s4)

# ╔═╡ 49d8f60e-9597-4a58-8998-9ddad27e4382
"""Align sequences s1 and s2 in a pair of vectors equal in length to the SCS.
First find the SCS of the two sequences, then align each element of s1 an s2 with an element in the SCS.
"""
function alignpair(s1,s2)
	slots = scs(s1, s2)
	s1align = []
	s2align = []

	s1seen = 1
	s2seen = 1
	for (i, item) in enumerate(slots)
		
		if slots[i] == s1[s1seen]
			push!(s1align, s1[s1seen])
			s1seen = s1seen + 1
		else
			push!(s1align, nothing)
		end
		
		if slots[i] == s2[s2seen]
			push!(s2align, s2[s2seen])
			s2seen = s2seen + 1
		else
			push!(s2align, nothing)
		end
		
	end
	s1align, s2align
end

# ╔═╡ 820b26e7-db9b-4d8b-916b-addde952677f
"""Compute the alignment of each sequence in a vector of sequences
to the SCS for the vector of sequences."""
function align(v...)
	maxseq = scs(v...)
	results = []
	for seq in v
		push!(results, alignpair(seq, maxseq)[1])
	end
	results
end

# ╔═╡ 6f39543f-2425-4886-aa9f-795aade94c17
align(s1, s2, s3, s4)

# ╔═╡ f84d467c-c4c6-4dca-a4f6-2e64db686f05
align(s1, s2, s3, s4)

# ╔═╡ 90029129-1ec9-41fa-a4a8-20bc9f42cdbd
scs(s1,s2, s3, s4)

# ╔═╡ c872eb6f-98fc-43c5-ba7a-d4cc4bc4ce85
"""Find longest common subsequence for two sequences.
Walk back through a matrix of alignment scores to find all items
that are common to sequences `a` and `b`.
"""
function lcspair(a, b)
	m = alignmentmemo(a,b)
    x,y = size(m)

    keepers = []
    while x > 1 && y > 1
        if m[x, y] == m[x-1, y]
            x -= 1
            
        elseif m[x, y] == m[x, y-1]
            y -= 1
            
        else
            @assert a[x-1] == b[y-1]
            push!(keepers, a[x-1])
            x -= 1
            y -= 1
        end
    end
    keepers |> reverse
end

# ╔═╡ b0a0157e-8184-4011-933a-4d7d78aeae0d
"""Find longest common subsequence for a vector of sequences."""
function lcs(v...)
	if length(v) < 2
		v
	else 
		lcs1 = lcspair(v[1], v[2])
        length(v) == 2 ? lcs1 : lcs(lcs1, v[3:end]...)
	end
end

# ╔═╡ 32abd3ab-3404-4882-85df-9e41164d957f
lcs(s1, s2, s3, s4)

# ╔═╡ fa6a8a8d-9bb5-43bc-a99f-d89943007203
lcs(s1, s2, s3, s4)

# ╔═╡ 25ab6ef7-c31c-4a53-bfe1-9f7e552e9593
"""Create a markdown table for two vectors of the same length
using each vector as a column of the table.
"""
function md_table_pair(s1,s2)
	mdlines = ["| Item | S1 | S2 |", "| --- |  --- | --- |"]
	@assert(length(s1) == length(s2))
	for (i,item) in enumerate(s1)
		s1val = isnothing(item) ? "" : item
		s2val = isnothing(s2[i]) ? "" : s2[i]
		push!(mdlines, string("| ", i, " | ", s1val, " | ", s2val, " |"))
	end
	join(mdlines,"\n")
	
end

# ╔═╡ 8011a76f-b086-4499-ac25-9b947bd5bdb8
"""Format a markdown table for n vectors of the same length using
each vector as a column of the table.
"""
function md_table(v...)
	mdlines = []
	colhdrs = ["| s$(i) " for i in 1:length(v)]
	push!(mdlines, "| Item " * join(colhdrs) * " |")
	push!(mdlines, "| --- " * repeat("| ---", length(v)) * " |")

	for seqidx in 1:length(v[1])
	
		
		rowdata = ["| $(seqidx) "]
		for colidx in 1:length(v)	

			colval = isnothing(v[colidx][seqidx] ) ? "" : v[colidx][seqidx] 
			push!(rowdata, string(" | ", colval ))

		end
		
		push!(mdlines, join(rowdata) * " |")
	end

	join(mdlines,"\n")
end

# ╔═╡ 41103cef-d122-4f74-8ea4-02ec2c519dd9
md_table(align(s1, s2, s3, s4)...) |> Markdown.parse

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.58"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "acf8a7d70217bc877a8d448fd5475fd91c6dd480"

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
version = "1.0.5+1"

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

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

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
# ╟─169f4290-9997-47bb-a6e9-c70fb4f26d53
# ╟─40a1fe8a-5540-4f0a-b0bc-732b6648e64e
# ╟─93f2ffe0-d703-11ee-12d0-5b8877a8556e
# ╟─b63828f1-fc98-4ea1-8897-a887ca4ec65f
# ╟─c2530727-d9be-4629-bf98-d1a5e1c1e53f
# ╟─5432bc6e-1bc3-4df0-87f5-769eab613a53
# ╟─734fb507-fbec-4405-a53a-de143c622bc2
# ╟─e301a83e-5bb9-4ba6-bc33-1ddf81ffd20e
# ╟─7ffa65c7-5060-4375-b916-81d61fda6deb
# ╟─b9d52f0f-c1d0-47fc-8366-6e120e33659a
# ╟─9bfa7301-513c-4946-8048-6d5b48952482
# ╠═32abd3ab-3404-4882-85df-9e41164d957f
# ╟─613297b8-05d7-4e65-ba76-a70bb5369321
# ╠═bb0d0eb5-d6d0-49f2-bd57-8b7eb2096c98
# ╟─fe23cc02-2b8e-47bc-889b-a8fe1ccaab24
# ╠═6f39543f-2425-4886-aa9f-795aade94c17
# ╟─3f36e91e-9a89-44d2-b0db-022abb232c62
# ╟─8c91da03-7afa-402a-b53a-d23b436e948c
# ╟─41103cef-d122-4f74-8ea4-02ec2c519dd9
# ╟─6f1ed4a1-5d61-4734-bc40-9b8993567796
# ╟─269ff2a9-88b4-4103-a7e6-d7fd76cc09b6
# ╟─c1bee1a0-038e-4e85-84dc-4be36e774f02
# ╠═7666c1c9-19ac-4a63-a005-74dfa092d3de
# ╟─49d8f60e-9597-4a58-8998-9ddad27e4382
# ╟─820b26e7-db9b-4d8b-916b-addde952677f
# ╠═f84d467c-c4c6-4dca-a4f6-2e64db686f05
# ╠═90029129-1ec9-41fa-a4a8-20bc9f42cdbd
# ╠═fa6a8a8d-9bb5-43bc-a99f-d89943007203
# ╟─87e5bad4-bf52-4163-94a6-803024d1a713
# ╟─42db806e-0465-4e65-a8e8-e0443db1d2f0
# ╟─3581dfbc-2acf-4cb6-aaea-2d8a06c0a1f0
# ╟─b0a0157e-8184-4011-933a-4d7d78aeae0d
# ╟─c872eb6f-98fc-43c5-ba7a-d4cc4bc4ce85
# ╟─25ab6ef7-c31c-4a53-bfe1-9f7e552e9593
# ╟─8011a76f-b086-4499-ac25-9b947bd5bdb8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
