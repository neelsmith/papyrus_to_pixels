### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ cfe33452-3e67-444f-b1c9-26586efd71ec
begin
	using BioSequences
end

# ╔═╡ 66b221fe-c37c-4f1e-8f28-b6c6c82aba2d
md"""Resources:

- this [course from Wellesley](http://bisc195.wellesley.edu): "Essential Skills for Computational Biology"
- docs for [BioSequences](https://biojulia.dev/BioSequences.jl/stable/) pkg
"""

# ╔═╡ 65c3e03e-bad5-11ee-3d46-23a97d85021e
md"""# Strings and Biosequences"""

# ╔═╡ a984869e-e464-40ee-b60c-a0d64308fe79
md"""## Some kind of solution to lab 2"""

# ╔═╡ 37ce29a3-6bef-469e-977c-0c855c0b6762
md"""Here is a nucleotide sequence for a Cytochrome Oxidase I mitochondria in  *homo sapiens*."""

# ╔═╡ 0323429f-5d95-47ce-b52e-3627696f73b1
hs_seq = dna"ATGTTCGCCGACCGTTGACTATTCTCTACAAACCACAAAGACATTGGAACACTATACCTATTATTCGGCGCATGAGCTGGAGTCCTAGGCACAGCTCTAAGCCTCCTTATTCGAGCCGAGCTGGGCCAGCCAGGCAACCTTCTAGGTAACGACCACATCTACAACGTTATCGTCACAGCCCATGCATTTGTAATAATCTTCTTCATAGTAATACCCATCATAATCGGAGGCTTTGGCAACTGACTAGTTCCCCTAATAATCGGTGCCCCCGATATGGCGTTTCCCCGCATAAACAACATAAGCTTCTGACTCTTACCTCCCTCTCTCCTACTCCTGCTCGCATCTGCTATAGTGGAGGCCGGAGCAGGAACAGGTTGAACAGTCTACCCTCCCTTAGCAGGGAACTACTCCCACCCTGGAGCCTCCGTAGACCTAACCATCTTCTCCTTACACCTAGCAGGTGTCTCCTCTATCTTAGGGGCCATCAATTTCATCACAACAATTATCAATATAAAACCCCCTGCCATAACCCAATACCAAACGCCCCTCTTCGTCTGATCCGTCCTAATCACAGCAGTCCTACTTCTCCTATCTCTCCCAGTCCTAGCTGCTGGCATCACTATACTACTAACAGACCGCAACCTCAACACCACCTTCTTCGACCCCGCCGGAGGAGGAGACCCCATTCTATACCAACACCTATTCTGATTTTTCGGTCACCCTGAAGTTTATATTCTTATCCTACCAGGCTTCGGAATAATCTCCCATATTGTAACTTACTACTCCGGAAAAAAAGAACCATTTGGATACATAGGTATGGTCTGAGCTATGATATCAATTGGCTTCCTAGGGTTTATCGTGTGAGCACACCATATATTTACAGTAGGAATAGACGTAGACACACGAGCATATTTCACCTCCGCTACCATAATCATCGCTATCCCCACCGGCGTCAAAGTATTTAGCTGACTCGCCACACTCCACGGAAGCAATATGAAATGATCTGCTGCAGTGCTCTGAGCCCTAGGATTCATCTTTCTTTTCACCGTAGGTGGCCTGACTGGCATTGTATTAGCAAACTCATCACTAGACATCGTACTACACGACACGTACTACGTTGTAGCCCACTTCCACTATGTCCTATCAATAGGAGCTGTATTTGCCATCATAGGAGGCTTCATTCACTGATTTCCCCTATTCTCAGGCTACACCCTAGACCAAACCTACGCCAAAATCCATTTCACTATCATATTCATCGGCGTAAATCTAACTTTCTTCCCACAACACTTTCTCGGCCTATCCGGAATGCCCCGACGTTACTCGGACTACCCCGATGCATACACCACATGAAACATCCTATCATCTGTAGGCTCATTCATTTCTCTAACAGCAGTAATATTAATAATTTTCATGATTTGAGAAGCCTTCGCTTCGAAGCGAAAAGTCCTAATAGTAGAAGAACCCTCCATAAACCTGGAGTGACTATATGGATGCCCCCCACCCTACCACACATTCGAAGAACCCGTATACATAAAATCTAGA"

# ╔═╡ b95a1cb0-1a9d-4d30-8f3c-dc30bde2a3ac
md"""Here's the same sequence translated to a sequence of amino acids. The `BioSequences` package makes these two actions trivial. (Thanks, `BioSequences` authors!)"""

# ╔═╡ d6a65b27-3704-4f74-b38b-4fdd76a669f4
html"""
<br/><br/><br/><br/><br/>
"""

# ╔═╡ 181ef67a-43b6-41d4-b634-392eebce4bc5
md"""

- vizualize diffs of amino acids comparing human sequence to beetle sequence
- within human sequence, vizualize diffs of nucleotide sequences for a single amino acid
"""

# ╔═╡ 39edc96d-a72b-4445-a821-25b4f4c081b1
md"""Let's build a "codon diffs" data set. We'll map our vector of codons to T/F values with T = uniform, F = varies
"""


# ╔═╡ 0788d300-cc0d-4d43-9ee0-a7c91d542605
"""Compose HTML for a codon wrapping each nucleotide with a span
indicating whether it's uniform or varies.
"""
function diff_values(ntlist, variety_bools)
	html_list = []
	@assert length(ntlist) == length(variety_bools)
	for (i, nt) in enumerate(ntlist)
		if variety_bools[i]
			push!(html_list, string(nt))
		else
			push!(html_list, s"""<span class="varies">""" * string(nt) * "</span>")
		end
	end
	string("<td>", join(html_list), "</td>")
end

# ╔═╡ e9390860-8d6c-4f71-b1cf-1b8e7b1dc71d
"""`aadict` is a dictionary mapping amino acids to all the nucleotide sequences they are built from.
"""
function checkvariety(aa, aadict)
	options = aadict[aa]
	uniform = Bool[]
		
	for i in 1:3
		ntvals = map(opt -> opt[i], options)	|> unique
		length(ntvals) == 1 ? push!(uniform,true) : push!(uniform, false)
	end
	uniform
end

# ╔═╡ 5f1f7065-5e60-4266-b422-94f7d7750d1f
# Styling!
css = html"""
<style>
.varies {
	background-color: yellow;
	font-weight: bold;
}
</style>
"""

# ╔═╡ 52da3927-6bbb-4820-961b-92d6b17ec8cd
md"""## Some data"""

# ╔═╡ 1fe8aa3d-a52b-489b-b996-11ccd53df42e
md"""**Homo sapiens**"""

# ╔═╡ e66709b6-8ae2-45cc-932d-be8f3898aabb
hs_str = "ATGTTCGCCGACCGTTGACTATTCTCTACAAACCACAAAGACATTGGAACACTATACCTATTATTCGGCGCATGAGCTGGAGTCCTAGGCACAGCTCTAAGCCTCCTTATTCGAGCCGAGCTGGGCCAGCCAGGCAACCTTCTAGGTAACGACCACATCTACAACGTTATCGTCACAGCCCATGCATTTGTAATAATCTTCTTCATAGTAATACCCATCATAATCGGAGGCTTTGGCAACTGACTAGTTCCCCTAATAATCGGTGCCCCCGATATGGCGTTTCCCCGCATAAACAACATAAGCTTCTGACTCTTACCTCCCTCTCTCCTACTCCTGCTCGCATCTGCTATAGTGGAGGCCGGAGCAGGAACAGGTTGAACAGTCTACCCTCCCTTAGCAGGGAACTACTCCCACCCTGGAGCCTCCGTAGACCTAACCATCTTCTCCTTACACCTAGCAGGTGTCTCCTCTATCTTAGGGGCCATCAATTTCATCACAACAATTATCAATATAAAACCCCCTGCCATAACCCAATACCAAACGCCCCTCTTCGTCTGATCCGTCCTAATCACAGCAGTCCTACTTCTCCTATCTCTCCCAGTCCTAGCTGCTGGCATCACTATACTACTAACAGACCGCAACCTCAACACCACCTTCTTCGACCCCGCCGGAGGAGGAGACCCCATTCTATACCAACACCTATTCTGATTTTTCGGTCACCCTGAAGTTTATATTCTTATCCTACCAGGCTTCGGAATAATCTCCCATATTGTAACTTACTACTCCGGAAAAAAAGAACCATTTGGATACATAGGTATGGTCTGAGCTATGATATCAATTGGCTTCCTAGGGTTTATCGTGTGAGCACACCATATATTTACAGTAGGAATAGACGTAGACACACGAGCATATTTCACCTCCGCTACCATAATCATCGCTATCCCCACCGGCGTCAAAGTATTTAGCTGACTCGCCACACTCCACGGAAGCAATATGAAATGATCTGCTGCAGTGCTCTGAGCCCTAGGATTCATCTTTCTTTTCACCGTAGGTGGCCTGACTGGCATTGTATTAGCAAACTCATCACTAGACATCGTACTACACGACACGTACTACGTTGTAGCCCACTTCCACTATGTCCTATCAATAGGAGCTGTATTTGCCATCATAGGAGGCTTCATTCACTGATTTCCCCTATTCTCAGGCTACACCCTAGACCAAACCTACGCCAAAATCCATTTCACTATCATATTCATCGGCGTAAATCTAACTTTCTTCCCACAACACTTTCTCGGCCTATCCGGAATGCCCCGACGTTACTCGGACTACCCCGATGCATACACCACATGAAACATCCTATCATCTGTAGGCTCATTCATTTCTCTAACAGCAGTAATATTAATAATTTTCATGATTTGAGAAGCCTTCGCTTCGAAGCGAAAAGTCCTAATAGTAGAAGAACCCTCCATAAACCTGGAGTGACTATATGGATGCCCCCCACCCTACCACACATTCGAAGAACCCGTATACATAAAATCTAGA"

# ╔═╡ 2b70f85c-57e8-44a1-8dc9-6bf4fa2798ca
md"""**Dyscolus fusipalpis**"""

# ╔═╡ 0660386e-1c14-46a3-b2a6-709bdb360f25
dyscfus_seq = dna"atgATTTTACCGCGACAATGATTATTTTCAACAAACCATAAGGATATTGGTACATTATATTTTATTTTTGGAGCATGATCAGGAATAGTAGGGACTTCACTAAGTATACTAATTCGAGCTGAATTGGGAAATCCTGGAGCATTAATTGGTGATGATCAAATTTATAATGTTATTGTAACTGCTCATGCATTTATTATGATTTTTTTTATAGTAATGCCTATTATAATTGGAGGATTTGGAAATTGATTAGTTCCTCTAATATTAGGGGCTCCTGATATAGCCTTTCCTCGAATAAATAATATAAGTTTTTGATTACTTCCTCCTTCACTAACACTTCTCTTAATGAGAAGAATAGTAGAAAGAGGAGCTGGTACCGGATGAACAGTTTACCCACCCCTCTCATCTGGTATTGCCCATGCCGGAGCCTCAGTTGATTTAGCTATTTTTAGTCTACATTTAGCAGGAGTATCTTCAATTTTAGGGGCTGTAAATTTTATTACAACAATTATCAATATACGATCAATTGGTATAACTTTTGATCGAATACCTTTATTTGTATGATCAGTAGGAATTACTGCTTTACTATTACTTTTATCATTACCAGTATTGGCTGGAGCTATCACAATATTATTAACAGATCGAAATTTAAATACTTCATTTTTTGACCCTGCAGGAGGAGGAGATCCTATTTTATACCAACATTTATTTTGATTTTTCGGTCACCCTGAAGTTTATATTTTAATTTTACCAGGATTTGGAATAATTTCTCATATTATTAGCCAAGAAAGAGGGAAAAAGGAAACCTTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGATTATTAGGATTTGTAGTCTGAGCTCACCATATATTTACAGTTGGAATAGATGTTGATACTCGAGCTTATTTTACTTCAGCTACAATAATTATTGCTGTCCCGACTGGAATTAAAATTTTTTCTTGATTAGCAACACTTCATGGAGCTCAAATATCTTATAGTCCTGCATTACTATGAGCTTTAGGATTTGTATTTTTATTCACCGTAGGTGGTCTAACTGGAGTAGTATTAGCTAATTCATCTATTGATATTATTCTTCACGATACATATTATGTTGTTGCCCATTTTCATTATGTGTTATCTATAGGAGCTGTATTTGCAATTATAGCTGGATTTATTCAATGATTCCCTTTATTTACAGGATTAAGAATAAATGATAACTTATTAAAAATTCAATTCATTATTATATTTATTGGGGTAAATTTAACATTTTTCCCTCAACATTTTTTAGGACTAAATGGTATACCACGACGATATTCAGATTATCCTGATGCATATACATCATGAAATATTGTTTCATCAATTGGTTCTACAATTTCTTTTATTGGAGTACTTTTATTAATTTATATTATTTGAGAAAGCTTTGTCTCTCAACGTTTAGTAATTTTCTCAAACCAAATATCAACTTCTATTGAATGATTTCAAAATTATCCTCCAGCTGAACATAGATATTCTGAACTACCGATACTATCTAATT"

# ╔═╡ 4a7c8983-4d90-42da-8b4b-5f8b4f26b95d
md"""## Basic manipulations"""

# ╔═╡ 1082a627-c8de-4713-b43b-c8df95242fd5
md"""Get a sequence of the complements for each nucleotide:"""

# ╔═╡ b8b56836-6523-4909-b6e8-97cf5099a57f
hs_complement = complement(hs_seq)

# ╔═╡ 5b9663ca-0642-4c44-a339-37e90c4b15bd
typeof(hs_seq)

# ╔═╡ f1062a07-c0a9-4836-9730-85a2cd46e699
df_complement = complement(dyscfus_seq)

# ╔═╡ ee335bed-fdca-495d-b0d2-ddff56a74939
md"""Translate a DNA sequence to a sequence of amino acids:"""

# ╔═╡ b37b2015-51b7-4018-a040-a7b21dc406be
"""The following two-line table shows the sequence of <b>$(length(hs_aseq)) amino acids</b> in the top row; in the second row, we see the corresponding <b>three nucleotides for each amino acid</b>.  Individual nucleotides are highlighted <span class="varies">like this</span> if other values in that position encode the same amino acid.


""" |> HTML

# ╔═╡ af917767-c3a0-4470-b356-83e9a93b69fc
md"""Summary of the variety in each position of the three-nucleotide sequence. Out of $(length(hs_aseq)) amino acids:"""

# ╔═╡ 0ed8bfe0-18b5-451c-8433-178afebbad1e
md"""> It would be fun to fix this with our own subdivision function!
"""

# ╔═╡ 7a0b2cbe-d255-4732-98c6-72136edaed9a
df_aseq = translate(dyscfus_seq)

# ╔═╡ 8489df6f-0bcc-4ab2-8435-a5b5e562df2d
md"""### Viz this"""

# ╔═╡ f6cec82d-24dd-4214-ba4e-6a4293aaac24
"""Cluster a nucleotide sequence into successive groups of three nucleotides."""
function codons(seq::LongSequence{BioSequences.DNAAlphabet{4}}) 
	n = 3
    codonlist = []
    for i in 1:n:length(seq)
        stophere = min(i+n-1, length(seq))
        subseq = [seq[j] for j in i:stophere] |> LongDNA{4}
        push!(codonlist, subseq)
    end
    return codonlist
end

# ╔═╡ 7915b4c4-0442-4336-9747-b097b6ec704e
hs_codons = codons(hs_seq)

# ╔═╡ 05812847-be60-4011-b24e-a03cec24585f
md"""

- The human amino acid sequence is `hs_aseq`. Its length is $(length(hs_aseq)) amino acids.
- The corresponding nucleotides clustered in codons is `hs_codons`. Its length is $(length(hs_codons)) triplets of nucleotides.
- the map of amino acids to all codons appearing in this sequence is `codon_possiblities`. It's a Julia `Dict` keyed by amino acid.
"""

# ╔═╡ dfa77f84-ceb6-4303-bbd7-93fc6dca2e29
aa_labels = translate.(hs_codons) .|> string


# ╔═╡ f8b99e5c-1f01-4a4a-800b-698c81866dad
hdr = "<tr><td><i>Amino acids</i></td><th>" * join(aa_labels, "</th><th>") * "</th><tr>"

# ╔═╡ b3638d21-22bf-4829-8548-076980f1cb8e
length(hs_codons)

# ╔═╡ cd52e391-dd3b-4bbf-9967-20526464926b
# Note that we want a single amino acid, not a sequence of length 1
hs_aa_mappings = [(codon = cdn, aa = translate(cdn)[1]) for cdn in hs_codons]

# ╔═╡ bddd4abe-511b-4b1c-8dc8-53b4f9286766
aa_srcs = unique(hs_aa_mappings)

# ╔═╡ d84d8c5b-bcbc-4f7f-81bc-7040d16dfaa0
codon_possiblities = begin
    codon_dict = Dict()
	for pr in aa_srcs
        if haskey(codon_dict, pr.aa)
            codon_dict[pr.aa] = push!(codon_dict[pr.aa], pr.codon)
		else

			codon_dict[pr.aa] = [pr.codon]
		end
	end
	codon_dict
end

# ╔═╡ 77b71866-63a5-4b8c-bde4-aed7ca718d9b
variety = [checkvariety(aa, codon_possiblities) for aa in hs_aseq ]

# ╔═╡ 248ef413-bc3d-4b9e-a6d7-871b1abdbd00
poscounts = begin
	count1 = filter(b -> b == false, map(v -> v[1], variety)) |> length
	count2 = filter(b -> b == false, map(v -> v[2], variety)) |> length
	count3 = filter(b -> b == false, map(v -> v[3], variety)) |> length
	(nt1 = count1, nt2 = count2, nt3 = count3)
end

# ╔═╡ 000ada82-e646-445c-98aa-33bf7fee6839
md"""


1. position 1 varies for  $(poscounts.nt1) amino acids
1. position 2 varies for $(poscounts.nt2) amino acids
1. position 3 varies for $(poscounts.nt3) amino acids
"""

# ╔═╡ bc9a21c0-83f3-491c-ab38-3d98a76653e8
diff_values(hs_codons[1], variety[1])

# ╔═╡ 821a2d02-400d-4ee0-90b5-63d7a4804a75
htmlspans = [diff_values(hs_codons[i], variety[i]) for i in 1:length(hs_codons)]

# ╔═╡ 169f43e1-2510-4fa9-81c7-64cda724db05
massiverow = "<tr><td><i>Nucleotides</i></td>" *  join(htmlspans) * "</tr>"

# ╔═╡ 792c8e66-ac28-4bbd-b43d-27b26ddee13a
join(["<table>", hdr, massiverow, "</table>"], "\n") |> HTML

# ╔═╡ 90105131-2a13-4f0e-b30d-6c9a877ff2ad
hs_aa_values = unique(hs_aseq)

# ╔═╡ f0f7baa7-675a-4e2d-971b-7f15b5467be5
function split_string(str::AbstractString, n::Integer)
    substrings = []
    for i in 1:n:length(str)
        push!(substrings, SubString(str, i, min(i+n-1, length(str))))
    end
    return substrings
end

# ╔═╡ f93588ce-b728-499e-a7ec-30e512396ef6
html"""
<br/><br/><br/><br/>
"""

# ╔═╡ 7a0f76f1-4da3-4064-abf3-8d17cf3261d1
md"""## Kmers are ngrams!"""

# ╔═╡ 9b8e92a5-7b18-489a-af44-822ab8800293
hs_aseq = translate(hs_seq)

# ╔═╡ 0a615793-60d2-4632-8e2e-0d65efb4f9cc
# ╠═╡ disabled = true
#=╠═╡
hs_aseq = translate(hs_seq)
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BioSequences = "7e6ae17a-c86d-528c-b3b9-7f778a29fe59"

[compat]
BioSequences = "~3.1.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "30d49595fcfcc70435470285015cf9883d1102c0"

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

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Twiddle]]
git-tree-sha1 = "29509c4862bfb5da9e76eb6937125ab93986270a"
uuid = "7200193e-83a8-5a55-b20d-5d36d44a0795"
version = "1.1.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═cfe33452-3e67-444f-b1c9-26586efd71ec
# ╟─66b221fe-c37c-4f1e-8f28-b6c6c82aba2d
# ╟─65c3e03e-bad5-11ee-3d46-23a97d85021e
# ╟─a984869e-e464-40ee-b60c-a0d64308fe79
# ╟─37ce29a3-6bef-469e-977c-0c855c0b6762
# ╟─0323429f-5d95-47ce-b52e-3627696f73b1
# ╟─b95a1cb0-1a9d-4d30-8f3c-dc30bde2a3ac
# ╠═9b8e92a5-7b18-489a-af44-822ab8800293
# ╟─b37b2015-51b7-4018-a040-a7b21dc406be
# ╟─792c8e66-ac28-4bbd-b43d-27b26ddee13a
# ╟─af917767-c3a0-4470-b356-83e9a93b69fc
# ╟─000ada82-e646-445c-98aa-33bf7fee6839
# ╟─d6a65b27-3704-4f74-b38b-4fdd76a669f4
# ╟─248ef413-bc3d-4b9e-a6d7-871b1abdbd00
# ╟─181ef67a-43b6-41d4-b634-392eebce4bc5
# ╠═05812847-be60-4011-b24e-a03cec24585f
# ╟─39edc96d-a72b-4445-a821-25b4f4c081b1
# ╠═77b71866-63a5-4b8c-bde4-aed7ca718d9b
# ╠═bc9a21c0-83f3-491c-ab38-3d98a76653e8
# ╠═821a2d02-400d-4ee0-90b5-63d7a4804a75
# ╠═169f43e1-2510-4fa9-81c7-64cda724db05
# ╠═dfa77f84-ceb6-4303-bbd7-93fc6dca2e29
# ╠═f8b99e5c-1f01-4a4a-800b-698c81866dad
# ╟─0788d300-cc0d-4d43-9ee0-a7c91d542605
# ╟─e9390860-8d6c-4f71-b1cf-1b8e7b1dc71d
# ╟─5f1f7065-5e60-4266-b422-94f7d7750d1f
# ╟─52da3927-6bbb-4820-961b-92d6b17ec8cd
# ╟─1fe8aa3d-a52b-489b-b996-11ccd53df42e
# ╟─e66709b6-8ae2-45cc-932d-be8f3898aabb
# ╟─2b70f85c-57e8-44a1-8dc9-6bf4fa2798ca
# ╟─0660386e-1c14-46a3-b2a6-709bdb360f25
# ╟─4a7c8983-4d90-42da-8b4b-5f8b4f26b95d
# ╟─1082a627-c8de-4713-b43b-c8df95242fd5
# ╠═b8b56836-6523-4909-b6e8-97cf5099a57f
# ╠═5b9663ca-0642-4c44-a339-37e90c4b15bd
# ╟─f1062a07-c0a9-4836-9730-85a2cd46e699
# ╟─ee335bed-fdca-495d-b0d2-ddff56a74939
# ╠═0a615793-60d2-4632-8e2e-0d65efb4f9cc
# ╟─0ed8bfe0-18b5-451c-8433-178afebbad1e
# ╠═7a0b2cbe-d255-4732-98c6-72136edaed9a
# ╟─8489df6f-0bcc-4ab2-8435-a5b5e562df2d
# ╟─f6cec82d-24dd-4214-ba4e-6a4293aaac24
# ╠═7915b4c4-0442-4336-9747-b097b6ec704e
# ╠═b3638d21-22bf-4829-8548-076980f1cb8e
# ╠═cd52e391-dd3b-4bbf-9967-20526464926b
# ╠═bddd4abe-511b-4b1c-8dc8-53b4f9286766
# ╠═d84d8c5b-bcbc-4f7f-81bc-7040d16dfaa0
# ╟─90105131-2a13-4f0e-b30d-6c9a877ff2ad
# ╟─f0f7baa7-675a-4e2d-971b-7f15b5467be5
# ╟─f93588ce-b728-499e-a7ec-30e512396ef6
# ╟─7a0f76f1-4da3-4064-abf3-8d17cf3261d1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
