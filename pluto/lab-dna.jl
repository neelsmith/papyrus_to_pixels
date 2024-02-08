### A Pluto.jl notebook ###
# v0.19.37

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

# ╔═╡ cfe33452-3e67-444f-b1c9-26586efd71ec
begin
	
	using PlutoUI
	using PlutoTeachingTools
end

# ╔═╡ a5cdfaee-238c-40d3-823c-c41754c8ee66
using BioSequences

# ╔═╡ cacfdf8a-413e-49b6-a837-773155fb1d6a
# This function is part of the `PlutoUI` pacakge:
TableOfContents()

# ╔═╡ c7925ead-597a-446e-9508-24401dbbb488
md"""*Template notebook: last modified* **Feb. 8, 2024.**"""

# ╔═╡ e30883ff-1930-4f75-bde8-0ab46e355693
md"""
!!! alert "Requirements for assignment: Comparing DNA sequences"

    1. Familiarize yourself with the Julia `BioSequences` package by figuring out basic information about some of its types and functions.
    2. Staring from a nucleotide sequence, find a sequence of amino acids. Find out how many ways each amino acid is encoded, and at what positions in the codon the encoding could vary for each amino acid. This template notebook guides you through this process.
    3. When you have completed all missing sections of code and discussion, save your notebook as a file named {LASTNAME}-lab2.jl substituting your last name for {LASTNAME}, and add the file to your personal folder on the course Google drive.
    4. Make sure everyone in your group has submitted a notebook with identical solutions to the problem.  Include your individual thoughts int he final reflection section of the notebook.

"""

# ╔═╡ cebc9afd-5f7d-4e7d-a639-5c4ddfbc6455
md"""## Publication"""

# ╔═╡ 9b0a3d35-057c-44fc-b153-b05e02f0f081
md"""
*Authors*: **-->ALL NAMES OF COLLABORATORS HERE<--**


*Date last modified*: **Feb. 8, 2024** **-->UPDATE THIS DATE WHEN YOU SUBMIT YOUR ASSIGNMENT<--**

"""

# ╔═╡ ae7b8af9-6293-4345-b1a5-39289bb87f96
md"""*License* : 
**[CC BY-SA 4.0 DEED](https://creativecommons.org/licenses/by-sa/4.0/deed.en)** [![](https://upload.wikimedia.org/wikipedia/commons/a/a9/CC-BY-SA.png)](https://creativecommons.org/licenses/by-sa/4.0/deed.en)
"""

# ╔═╡ f992a862-4aed-4bc5-9bb4-db3f79cbe51d
md"""# Comparing DNA sequences"""

# ╔═╡ bcad22fe-07f4-48b4-92d6-46ee4e75ce05
md"""## 1. Defining the goal


"""

# ╔═╡ f8073ab3-8ec7-4b6e-8971-5efed82b0713
md"""
!!! note "Goal"

    In this notebook we want to visualize how the encoding of amino acids varies in a sequence of the same gene in two different species.

    Given a DNA sequence, we want to find out both what different sequences of nucleotides encode any given amino acid in the sequence, and at what position in a codon, if any, an encoding of an amino acid varies.
"""

# ╔═╡ ab1722aa-e118-458d-89d3-625a0bfd9531
md"""## 2. Breaking down the problem

"""

# ╔═╡ eaad5b35-bf55-4606-aab0-6a7e93272e1c
md"""
!!! note "Breaking down the problem"

    

    1. First, as background, we'll learn a little about Julia's `BioSequences` package, since it can save us some work!
    2. Next, we'll summarize sequences of nucleotides amino acids, and codon units by counting how many elements occur in a sequence, and how many distinct *values* are found in each sequence.
    3. Then we'll create a dictionary so we can look up what codons occur for each amino acid in our sequence.
    4. Finally, we'll map each codon to a list of three true / false values recording whether the nucleotide at that position is always the same (true), or varies (false == not uniform).
"""

# ╔═╡ c4c14430-eb66-46a4-99a5-fb655a7758cf
md"""### A. the Julia `BioSequences` package"""

# ╔═╡ 3de371de-5054-4c88-9d7f-7010eefce7ca
md"""
The Julia `BioSequences` package was developed by biologists to simplify working with data about DNA sequences.  It's not a built-in part of the Julia langauge, so we'll need to tell Julia to include it in our current session, with the keyword  `using`.
"""

# ╔═╡ 3787be32-9588-4602-82ad-09df3628a258
md"""The package includes special types for sequences of nucleotides and for sequences of amino acids.

Nucleotides are usually represented by one of four letters: A, T, G or C. We could of course choose to model that with raw strings.
"""

# ╔═╡ 33c9848d-4e97-4d7c-933b-b0757853ee7a
dna_string = "ATG"

# ╔═╡ 0e1c6264-452d-4436-95f6-6883c8608d93
md"""One problem with that approach, however, is that there's nothing to prevent us from using bad data. What should we do if our string includes characters that are not ATGC?
"""

# ╔═╡ 2e2379a6-3ad4-4391-bde0-7e0210bd0bbc
bad_dna_string = "ATG🧨"

# ╔═╡ 71e384e7-7a23-456c-83c4-0768eabcb894
md"""`BioSequences` has a special type, named, approrpiately, `DNA`.  You can use a function named `convert` to convert a single character to a `DNA` object.

"""

# ╔═╡ 2b368302-141f-4afe-aeae-3d6e649dcc44
one_adenine = convert(DNA, 'A')

# ╔═╡ fb3246ac-5a2c-41e8-9141-43a46279f99e
typeof(one_adenine)

# ╔═╡ 1c97feb4-2f50-4caf-92e5-da7f5b5c9667
 md"""But if you try to convert an invalid character, you'll get an error message. Uncomment the following line, and see what happens.
 
 
 """

# ╔═╡ 2a58c6a3-89ab-474a-a24e-5d7de5a2d0a5
# convert(DNA, '🧨')

# ╔═╡ 1b4fd427-a08d-43c6-a5e8-a8005320179d
md"""Of course we're really interested in looking at sequences of DNA. The package lets you create a sequence of these DNA objects from a single string, as illustrated here.

"""

# ╔═╡ 159a2399-81d3-4148-957d-c90f5c5e4e66
ntide_example = LongDNA{4}("ATGATT")

# ╔═╡ eabbb5bf-f110-46ed-8675-cf66b5585c10
md"""
The displayed value tells us that this is a 6-nucleotide sequence (`6nt DNA Sequence`), with the three bases `A`, `T`,  `G`, `A`, `T`, `T`, in that order.
"""

# ╔═╡ a449057e-9714-4f8b-a537-aa63eee180a2
typeof(ntide_example)

# ╔═╡ e90e9b55-4bdd-4c70-9d76-92e25fb1cdf3
md"""Notice that its type is a `LongSequence`. This is just a specialization of the generic Vectors you've already been using, but now instead of allowing any kind of element to be contained in the vector, a `LongSequence` is a Vector that only contains legitimate biological sequence data.

That means that everything you already know how to do with a Vector, you do with a `LongSequence`.
"""

# ╔═╡ 16ba1c79-0068-46a9-a948-8974e9c9ccd9
md"""  Lets find out how many nucleotides are in this example."""

# ╔═╡ d1cc8f2d-97ff-48ee-adac-f4b96e54846e
length(ntide_example)

# ╔═╡ def367ea-df15-4274-a86b-15ddf7958b2b
md"""How many different bases are represented? That's also a generic question you can answer for any vector:"""

# ╔═╡ e093e012-dab9-41ef-8daa-3bae19bc88cf
unique(ntide_example)

# ╔═╡ 5c1652ee-414b-498c-bfa9-6d8e30cd7be6
md"""Let's use Julia's "pipe" syntax to string together finding and counting a list of unique values."""

# ╔═╡ fee93b2f-f889-4623-825d-dd170120880a
unique(ntide_example) |> length

# ╔═╡ bf29f041-e685-40cd-bdb0-30acde2b5e5b
md"""The package has a handy macro for creating a sequence from a string, predictably named `dna`.  Its syntax is just like the macro you  use in Pluto notebooks to create a Markdown formatted object from a string."""

# ╔═╡ f0684962-48bd-44d2-9e36-bb75cddf6968
n_tide = dna"ATG"

# ╔═╡ bcb268e8-6e7b-47ce-8733-f25243f0b31a
n_tide[1]

# ╔═╡ cbe521e1-6472-4139-b1a7-8539cd85587d
md"""It's a Vector!"""

# ╔═╡ 5b25407b-441d-4ae1-935f-c1cbaa4699d7
n_tide[1] |> typeof

# ╔═╡ b5e3b250-2116-4b82-b36c-a3dc06d70276
md"""

- How long is the Vector `n_tide` ?
- What is the type of each element in `n_tide`?
"""

# ╔═╡ a8f4b9c7-4138-4c9f-9d31-aa8232183f58
md"""




"""

# ╔═╡ 7ad8ffae-6604-414b-83c3-53676be1f497
one_aa = translate(n_tide)

# ╔═╡ 5990561b-e760-415e-ac2b-461381d796c9
typeof(one_aa)

# ╔═╡ 5e930fc5-fb06-47a0-914f-ad7f1eec1caf
one_aa[1] 

# ╔═╡ e6eef629-6608-43be-b6df-fb816ff56ffc
md"""
### B. Summarizing a DNA sequence
"""

# ╔═╡ 7515233b-34ef-4db5-b085-2e0d4cbf52d0
md"""In this lab, we're going to compare sequences for the same gene in two different species.  The gene is called *Cytochrome Oxidase I mitochondria*; the two species we'll compare are people (*homo sapiens*) and a beetle called *dyscolus fusipalpus*.

You can use the following menu to choose between them; this will assign a value to a variable named `species`.
"""

# ╔═╡ d09913ca-00ed-48d2-af67-b7f66579adcb
md"""*Choose a species to analyze*: $(@bind species Select(["human" => "homo sapiens", "beetle" => "dyscolus fusipalpis"]))"""

# ╔═╡ 36523fee-f1d8-4747-8720-726eb6ae1800
species

# ╔═╡ c5e87c41-1a46-4a76-b344-cf9acf32f048
md"""The next cell uses *interpolation* to include a label for your choice in a string that we'll format as Markdown with the `md` macro."""

# ╔═╡ 5a4032c8-93a6-49b1-b503-ebac439acd2b
md"""Species to summarize: $(species)"""

# ╔═╡ 1ae6f546-13db-42d1-b764-755eb9b9a233
md"""This is a Vector of dna sequences: each sequence has 3 nucleotides"""

# ╔═╡ 1ddbcc54-7218-445a-acbe-28fcca1b6723
md"""### C. How does encoding of proteins vary?"""

# ╔═╡ 2b230cef-5dbf-441e-b2bf-add59787e77b
md"""
!!! note "Challenge here"

    Find set of codons per amino acid
"""

# ╔═╡ 37ce29a3-6bef-469e-977c-0c855c0b6762
md"""

1. `dna_seq` is a nucleotide sequence for a Cytochrome Oxidase I mitochondria in  either *homo sapiens* of *dyscolus fusipalpus*.
2. `aa_seq` is the same sequence interpreted as a sequence of amino acids. 
3. `codons` is the same nucleotide sequence divided into groups of 3, each corresponding to an amino acid.


"""

# ╔═╡ 6f19c952-020e-4a14-9652-1fc2498c2250
md"""### D. Where in each codon does variation occur?"""

# ╔═╡ 93a15dd9-76da-4929-a9a6-715c42599085
md"""### E. Visualizing results in Pluto"""

# ╔═╡ f82ac9f7-b557-4078-aa38-d08fefec5945
md"""

- auto formatted table
- needs a list of amino acids
- needs a list of nucleotides
- needs your scores

"""

# ╔═╡ 13a842ca-f0fb-4942-8462-857952fe7f24
md"""Example:"""

# ╔═╡ d26b1729-6387-4737-9e66-9de225201f64
seq_eg = dna"""TTC"""

# ╔═╡ f3995027-52bc-4781-82d1-50aba6effc2a
truthy_eg = [true, true, false]

# ╔═╡ 21e6c7ed-3116-479c-990b-9ed7a0cd4222
html"""
<br/><br/><br/><br/>
"""

# ╔═╡ ef4fac43-d795-4f35-a2bf-11b665046694
md"""
---

Some calculations about unambiguous sequences: clean this up.
"""

# ╔═╡ c741a1e5-05ea-44e6-8cf7-664686240a74


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


# ╔═╡ 4647af0e-5edc-4635-9200-8b31da396760


# ╔═╡ e9390860-8d6c-4f71-b1cf-1b8e7b1dc71d
"""`aadict` is a dictionary mapping amino acids to all the nucleotide sequences they are built from.
"""
function checkvariety(aa, aadict)
	options = aadict[aa]
	uniform = Bool[]
		
	for i in 1:3 # Nah, require that aadict's value vectors already are uniqued.
		ntvals = map(opt -> opt[i], options)	|> unique
		length(ntvals) == 1 ? push!(uniform,true) : push!(uniform, false)
	end
	uniform
end

# ╔═╡ 8f9484fa-1960-41e1-8652-8a5c2285651b
md"""## 3. Reflection

"""

# ╔═╡ ed94a586-26ab-4091-92b0-de4a81f77111
html"""
<br/><br/><br/><br/>
<br/><br/><br/><br/>
<br/><br/><br/><br/>
"""

# ╔═╡ 52da3927-6bbb-4820-961b-92d6b17ec8cd
md"""> Sequence data"""

# ╔═╡ 1fe8aa3d-a52b-489b-b996-11ccd53df42e
md"""**Homo sapiens**"""

# ╔═╡ e66709b6-8ae2-45cc-932d-be8f3898aabb
hs_str = "ATGTTCGCCGACCGTTGACTATTCTCTACAAACCACAAAGACATTGGAACACTATACCTATTATTCGGCGCATGAGCTGGAGTCCTAGGCACAGCTCTAAGCCTCCTTATTCGAGCCGAGCTGGGCCAGCCAGGCAACCTTCTAGGTAACGACCACATCTACAACGTTATCGTCACAGCCCATGCATTTGTAATAATCTTCTTCATAGTAATACCCATCATAATCGGAGGCTTTGGCAACTGACTAGTTCCCCTAATAATCGGTGCCCCCGATATGGCGTTTCCCCGCATAAACAACATAAGCTTCTGACTCTTACCTCCCTCTCTCCTACTCCTGCTCGCATCTGCTATAGTGGAGGCCGGAGCAGGAACAGGTTGAACAGTCTACCCTCCCTTAGCAGGGAACTACTCCCACCCTGGAGCCTCCGTAGACCTAACCATCTTCTCCTTACACCTAGCAGGTGTCTCCTCTATCTTAGGGGCCATCAATTTCATCACAACAATTATCAATATAAAACCCCCTGCCATAACCCAATACCAAACGCCCCTCTTCGTCTGATCCGTCCTAATCACAGCAGTCCTACTTCTCCTATCTCTCCCAGTCCTAGCTGCTGGCATCACTATACTACTAACAGACCGCAACCTCAACACCACCTTCTTCGACCCCGCCGGAGGAGGAGACCCCATTCTATACCAACACCTATTCTGATTTTTCGGTCACCCTGAAGTTTATATTCTTATCCTACCAGGCTTCGGAATAATCTCCCATATTGTAACTTACTACTCCGGAAAAAAAGAACCATTTGGATACATAGGTATGGTCTGAGCTATGATATCAATTGGCTTCCTAGGGTTTATCGTGTGAGCACACCATATATTTACAGTAGGAATAGACGTAGACACACGAGCATATTTCACCTCCGCTACCATAATCATCGCTATCCCCACCGGCGTCAAAGTATTTAGCTGACTCGCCACACTCCACGGAAGCAATATGAAATGATCTGCTGCAGTGCTCTGAGCCCTAGGATTCATCTTTCTTTTCACCGTAGGTGGCCTGACTGGCATTGTATTAGCAAACTCATCACTAGACATCGTACTACACGACACGTACTACGTTGTAGCCCACTTCCACTATGTCCTATCAATAGGAGCTGTATTTGCCATCATAGGAGGCTTCATTCACTGATTTCCCCTATTCTCAGGCTACACCCTAGACCAAACCTACGCCAAAATCCATTTCACTATCATATTCATCGGCGTAAATCTAACTTTCTTCCCACAACACTTTCTCGGCCTATCCGGAATGCCCCGACGTTACTCGGACTACCCCGATGCATACACCACATGAAACATCCTATCATCTGTAGGCTCATTCATTTCTCTAACAGCAGTAATATTAATAATTTTCATGATTTGAGAAGCCTTCGCTTCGAAGCGAAAAGTCCTAATAGTAGAAGAACCCTCCATAAACCTGGAGTGACTATATGGATGCCCCCCACCCTACCACACATTCGAAGAACCCGTATACATAAAATCTAGA"

# ╔═╡ 2b70f85c-57e8-44a1-8dc9-6bf4fa2798ca
md"""**Dyscolus fusipalpis**"""

# ╔═╡ 1d171200-ce6a-4881-8777-9493d0c29d88
df_str = "atgATTTTACCGCGACAATGATTATTTTCAACAAACCATAAGGATATTGGTACATTATATTTTATTTTTGGAGCATGATCAGGAATAGTAGGGACTTCACTAAGTATACTAATTCGAGCTGAATTGGGAAATCCTGGAGCATTAATTGGTGATGATCAAATTTATAATGTTATTGTAACTGCTCATGCATTTATTATGATTTTTTTTATAGTAATGCCTATTATAATTGGAGGATTTGGAAATTGATTAGTTCCTCTAATATTAGGGGCTCCTGATATAGCCTTTCCTCGAATAAATAATATAAGTTTTTGATTACTTCCTCCTTCACTAACACTTCTCTTAATGAGAAGAATAGTAGAAAGAGGAGCTGGTACCGGATGAACAGTTTACCCACCCCTCTCATCTGGTATTGCCCATGCCGGAGCCTCAGTTGATTTAGCTATTTTTAGTCTACATTTAGCAGGAGTATCTTCAATTTTAGGGGCTGTAAATTTTATTACAACAATTATCAATATACGATCAATTGGTATAACTTTTGATCGAATACCTTTATTTGTATGATCAGTAGGAATTACTGCTTTACTATTACTTTTATCATTACCAGTATTGGCTGGAGCTATCACAATATTATTAACAGATCGAAATTTAAATACTTCATTTTTTGACCCTGCAGGAGGAGGAGATCCTATTTTATACCAACATTTATTTTGATTTTTCGGTCACCCTGAAGTTTATATTTTAATTTTACCAGGATTTGGAATAATTTCTCATATTATTAGCCAAGAAAGAGGGAAAAAGGAAACCTTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGATTATTAGGATTTGTAGTCTGAGCTCACCATATATTTACAGTTGGAATAGATGTTGATACTCGAGCTTATTTTACTTCAGCTACAATAATTATTGCTGTCCCGACTGGAATTAAAATTTTTTCTTGATTAGCAACACTTCATGGAGCTCAAATATCTTATAGTCCTGCATTACTATGAGCTTTAGGATTTGTATTTTTATTCACCGTAGGTGGTCTAACTGGAGTAGTATTAGCTAATTCATCTATTGATATTATTCTTCACGATACATATTATGTTGTTGCCCATTTTCATTATGTGTTATCTATAGGAGCTGTATTTGCAATTATAGCTGGATTTATTCAATGATTCCCTTTATTTACAGGATTAAGAATAAATGATAACTTATTAAAAATTCAATTCATTATTATATTTATTGGGGTAAATTTAACATTTTTCCCTCAACATTTTTTAGGACTAAATGGTATACCACGACGATATTCAGATTATCCTGATGCATATACATCATGAAATATTGTTTCATCAATTGGTTCTACAATTTCTTTTATTGGAGTACTTTTATTAATTTATATTATTTGAGAAAGCTTTGTCTCTCAACGTTTAGTAATTTTCTCAAACCAAATATCAACTTCTATTGAATGATTTCAAAATTATCCTCCAGCTGAACATAGATATTCTGAACTACCGATACTATCTAAT"

# ╔═╡ 48eecf30-3355-4087-902f-3481d4b272cd
"""Select one of two available string encoding of Cytochrome Oxidase I mitochondria.
"""
function choose_co1(species)
	species == "human" ? hs_str : df_str
end

# ╔═╡ 1983630a-ff08-4afe-9fca-0fccfb456d1b
dnastring = choose_co1(species)

# ╔═╡ 897b5787-4069-4669-b581-20a5931c9527
typeof(dnastring)

# ╔═╡ 577afd6e-dbbb-414a-bdff-939da44b815a
dna_seq = LongDNA{4}(dnastring)

# ╔═╡ 8845c1b1-b088-4a41-8c3b-e9ce218efad8
aa_seq = translate(dna_seq)

# ╔═╡ af917767-c3a0-4470-b356-83e9a93b69fc
md"""Summary of the variety in each position of the three-nucleotide sequence. Out of $(length(aa_seq)) amino acids:"""

# ╔═╡ 90105131-2a13-4f0e-b30d-6c9a877ff2ad
aa_values = unique(aa_seq)

# ╔═╡ f6cec82d-24dd-4214-ba4e-6a4293aaac24
"""Cluster a nucleotide sequence into successive groups of three nucleotides."""
function splitcodons(seq::LongSequence{BioSequences.DNAAlphabet{4}}) 
	n = 3
    codonlist = LongSequence{DNAAlphabet{4}}[]
    for i in 1:n:length(seq)
        stophere = min(i+n-1, length(seq))
        subseq = [seq[j] for j in i:stophere] |> LongDNA{4}
        push!(codonlist, subseq)
    end
    return codonlist
end

# ╔═╡ c71395e3-ce5b-4c0e-b92c-6316581ddc86
codons = splitcodons(dna_seq)

# ╔═╡ 56ec6953-fbc8-4447-bf9b-ad8d61fc8b93
codon_translations = [(codon = cdn, aa = translate(cdn)[1]) for cdn in codons]

# ╔═╡ 7ea655b6-0d60-450a-9b82-d3f68373f4b3
aa_srcs = unique(codon_translations)

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
variety = [checkvariety(aa, codon_possiblities) for aa in aa_seq ]

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

# ╔═╡ 3722d543-d715-4e02-aac2-2e941f10ab2a
unambiguous_aaseq = filter(v -> length(unique(v)) == 1, collect(values(codon_possiblities))) |> unique

# ╔═╡ ccc475cd-5a8f-4463-855d-134b8641f3a3
unambiguous_aas = map(v -> v[1], unambiguous_aaseq)

# ╔═╡ 58eb3544-c3bc-4f02-a50a-b8ea6c1d1084
md"""The $(length(unambiguous_aas)) unambiguous sequences are:

"""


# ╔═╡ 9d1ef359-c196-4514-9648-efe99331db5e


join(map(nt -> string("- ", nt), unambiguous_aas), "\n") |> Markdown.parse

# ╔═╡ 347ffb95-9a06-4356-af1f-8283809bf35a
q = ExactSearchQuery(unambiguous_aas[1])

# ╔═╡ 6035fc99-de0b-4789-90c9-324a014b1adf
filter(unambiguous_aas) do aa
	! isempty(findall(q, aa))
end

# ╔═╡ b62254b9-d59c-4412-b026-c2ea484e12e1
ambiguous_aas = filter(v -> length(unique(v)) > 1, collect(values(codon_possiblities))) |> unique

# ╔═╡ 25176ec7-22f4-4270-9df6-10995d7f064e
md"""Out of $(length(keys(codon_possiblities))) amino acids, $(length(ambiguous_aas)) are encoded by multiple nucleotide sequences."""

# ╔═╡ dfa77f84-ceb6-4303-bbd7-93fc6dca2e29
aa_labels = translate.(codons) .|> string


# ╔═╡ 5c4c96d2-1804-49d8-918e-14d2bd34b9d4
translate.(codons) == aa_seq

# ╔═╡ 05812847-be60-4011-b24e-a03cec24585f
md"""

- The human amino acid sequence is `aa_seq`. Its length is $(length(aa_seq)) amino acids.
- The corresponding nucleotides clustered in codons is `codons`. Its length is $(length(codons)) triplets of nucleotides.
- the map of amino acids to all codons appearing in this sequence is `codon_possiblities`. It's a Julia `Dict` keyed by amino acid.
"""

# ╔═╡ bbc0eb4f-1228-4fe0-ba75-104b88e3e250
md"""> HTML display"""

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

# ╔═╡ 0788d300-cc0d-4d43-9ee0-a7c91d542605
"""Compose HTML for a codon wrapping each nucleotide with a span
indicating whether it's uniform or varies.
"""
function hilite_diffs(ntlist, variety_bools)
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

# ╔═╡ c4f4a8e5-5f64-4c28-ba34-5af96f79767f
hilite_diffs(seq_eg, truthy_eg) |> HTML

# ╔═╡ bc9a21c0-83f3-491c-ab38-3d98a76653e8
hilite_diffs(codons[1], variety[1])

# ╔═╡ d564fc1c-4cc8-442f-af3c-906cf6f59f07
"""Format an HTML table with higlighting of base locations that show variation for a given amino acid.
"""
function tablify(codonseq, tfvals, aalabels)
	aacells = map(lbl -> "<td>$(lbl)</td>", aalabels)
	aarow = "<tr><td><i>Amino acids</i></td>" * join(aacells) * "</tr>"
	
	codoncells  = [hilite_diffs(codonseq[i], tfvals[i]) for i in 1:length(codonseq)]
	codonrow = "<tr><td><i>Nucleotides</i></td>" *  join(codoncells) * "</tr>"

	join(["<table>", aarow, codonrow, "</table>"], "\n") 
end

# ╔═╡ c058af20-6644-49a3-bf1a-d060458c9b59
tablify([seq_eg], [truthy_eg], [aa_labels[2]]) |> HTML

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BioSequences = "7e6ae17a-c86d-528c-b3b9-7f778a29fe59"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BioSequences = "~3.1.6"
PlutoTeachingTools = "~0.2.14"
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "e5bb6a5c549223daed7b03d1ac80ccbab81a0baf"

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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

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

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "04663b9e1eb0d0eabf76a6d0752e0dac83d53b36"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.28"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "20ce1091ba18bcdae71ad9b71ee2367796ba6c48"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.4.4"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

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

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "89f57f710cc121a7f32473791af3d6beefc59051"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.14"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

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

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "3fe4e5b9cdbb9bbc851c57b149e516acc07f8f72"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.13"

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
# ╟─cfe33452-3e67-444f-b1c9-26586efd71ec
# ╟─cacfdf8a-413e-49b6-a837-773155fb1d6a
# ╟─c7925ead-597a-446e-9508-24401dbbb488
# ╟─e30883ff-1930-4f75-bde8-0ab46e355693
# ╟─cebc9afd-5f7d-4e7d-a639-5c4ddfbc6455
# ╟─9b0a3d35-057c-44fc-b153-b05e02f0f081
# ╟─ae7b8af9-6293-4345-b1a5-39289bb87f96
# ╟─f992a862-4aed-4bc5-9bb4-db3f79cbe51d
# ╟─bcad22fe-07f4-48b4-92d6-46ee4e75ce05
# ╟─f8073ab3-8ec7-4b6e-8971-5efed82b0713
# ╟─ab1722aa-e118-458d-89d3-625a0bfd9531
# ╟─eaad5b35-bf55-4606-aab0-6a7e93272e1c
# ╟─c4c14430-eb66-46a4-99a5-fb655a7758cf
# ╟─3de371de-5054-4c88-9d7f-7010eefce7ca
# ╠═a5cdfaee-238c-40d3-823c-c41754c8ee66
# ╟─3787be32-9588-4602-82ad-09df3628a258
# ╠═33c9848d-4e97-4d7c-933b-b0757853ee7a
# ╟─0e1c6264-452d-4436-95f6-6883c8608d93
# ╠═2e2379a6-3ad4-4391-bde0-7e0210bd0bbc
# ╟─71e384e7-7a23-456c-83c4-0768eabcb894
# ╠═2b368302-141f-4afe-aeae-3d6e649dcc44
# ╠═fb3246ac-5a2c-41e8-9141-43a46279f99e
# ╟─1c97feb4-2f50-4caf-92e5-da7f5b5c9667
# ╠═2a58c6a3-89ab-474a-a24e-5d7de5a2d0a5
# ╟─1b4fd427-a08d-43c6-a5e8-a8005320179d
# ╠═159a2399-81d3-4148-957d-c90f5c5e4e66
# ╟─eabbb5bf-f110-46ed-8675-cf66b5585c10
# ╠═a449057e-9714-4f8b-a537-aa63eee180a2
# ╟─e90e9b55-4bdd-4c70-9d76-92e25fb1cdf3
# ╟─16ba1c79-0068-46a9-a948-8974e9c9ccd9
# ╠═d1cc8f2d-97ff-48ee-adac-f4b96e54846e
# ╟─def367ea-df15-4274-a86b-15ddf7958b2b
# ╠═e093e012-dab9-41ef-8daa-3bae19bc88cf
# ╟─5c1652ee-414b-498c-bfa9-6d8e30cd7be6
# ╠═fee93b2f-f889-4623-825d-dd170120880a
# ╟─bf29f041-e685-40cd-bdb0-30acde2b5e5b
# ╠═f0684962-48bd-44d2-9e36-bb75cddf6968
# ╠═bcb268e8-6e7b-47ce-8733-f25243f0b31a
# ╠═cbe521e1-6472-4139-b1a7-8539cd85587d
# ╠═5b25407b-441d-4ae1-935f-c1cbaa4699d7
# ╟─b5e3b250-2116-4b82-b36c-a3dc06d70276
# ╠═a8f4b9c7-4138-4c9f-9d31-aa8232183f58
# ╠═7ad8ffae-6604-414b-83c3-53676be1f497
# ╠═5990561b-e760-415e-ac2b-461381d796c9
# ╠═5e930fc5-fb06-47a0-914f-ad7f1eec1caf
# ╟─e6eef629-6608-43be-b6df-fb816ff56ffc
# ╟─7515233b-34ef-4db5-b085-2e0d4cbf52d0
# ╟─d09913ca-00ed-48d2-af67-b7f66579adcb
# ╠═36523fee-f1d8-4747-8720-726eb6ae1800
# ╟─c5e87c41-1a46-4a76-b344-cf9acf32f048
# ╠═5a4032c8-93a6-49b1-b503-ebac439acd2b
# ╠═897b5787-4069-4669-b581-20a5931c9527
# ╠═577afd6e-dbbb-414a-bdff-939da44b815a
# ╠═8845c1b1-b088-4a41-8c3b-e9ce218efad8
# ╟─1ae6f546-13db-42d1-b764-755eb9b9a233
# ╠═c71395e3-ce5b-4c0e-b92c-6316581ddc86
# ╠═56ec6953-fbc8-4447-bf9b-ad8d61fc8b93
# ╟─7ea655b6-0d60-450a-9b82-d3f68373f4b3
# ╟─1ddbcc54-7218-445a-acbe-28fcca1b6723
# ╠═2b230cef-5dbf-441e-b2bf-add59787e77b
# ╟─37ce29a3-6bef-469e-977c-0c855c0b6762
# ╠═dfa77f84-ceb6-4303-bbd7-93fc6dca2e29
# ╠═5c4c96d2-1804-49d8-918e-14d2bd34b9d4
# ╠═6f19c952-020e-4a14-9652-1fc2498c2250
# ╟─af917767-c3a0-4470-b356-83e9a93b69fc
# ╠═000ada82-e646-445c-98aa-33bf7fee6839
# ╠═77b71866-63a5-4b8c-bde4-aed7ca718d9b
# ╠═d84d8c5b-bcbc-4f7f-81bc-7040d16dfaa0
# ╟─25176ec7-22f4-4270-9df6-10995d7f064e
# ╟─58eb3544-c3bc-4f02-a50a-b8ea6c1d1084
# ╟─9d1ef359-c196-4514-9648-efe99331db5e
# ╟─93a15dd9-76da-4929-a9a6-715c42599085
# ╟─f82ac9f7-b557-4078-aa38-d08fefec5945
# ╟─13a842ca-f0fb-4942-8462-857952fe7f24
# ╠═d26b1729-6387-4737-9e66-9de225201f64
# ╠═f3995027-52bc-4781-82d1-50aba6effc2a
# ╠═c4f4a8e5-5f64-4c28-ba34-5af96f79767f
# ╠═c058af20-6644-49a3-bf1a-d060458c9b59
# ╠═21e6c7ed-3116-479c-990b-9ed7a0cd4222
# ╟─ef4fac43-d795-4f35-a2bf-11b665046694
# ╠═347ffb95-9a06-4356-af1f-8283809bf35a
# ╠═6035fc99-de0b-4789-90c9-324a014b1adf
# ╠═ccc475cd-5a8f-4463-855d-134b8641f3a3
# ╠═3722d543-d715-4e02-aac2-2e941f10ab2a
# ╠═b62254b9-d59c-4412-b026-c2ea484e12e1
# ╠═c741a1e5-05ea-44e6-8cf7-664686240a74
# ╟─d6a65b27-3704-4f74-b38b-4fdd76a669f4
# ╟─248ef413-bc3d-4b9e-a6d7-871b1abdbd00
# ╟─181ef67a-43b6-41d4-b634-392eebce4bc5
# ╟─05812847-be60-4011-b24e-a03cec24585f
# ╟─39edc96d-a72b-4445-a821-25b4f4c081b1
# ╠═bc9a21c0-83f3-491c-ab38-3d98a76653e8
# ╠═90105131-2a13-4f0e-b30d-6c9a877ff2ad
# ╠═4647af0e-5edc-4635-9200-8b31da396760
# ╟─e9390860-8d6c-4f71-b1cf-1b8e7b1dc71d
# ╟─8f9484fa-1960-41e1-8652-8a5c2285651b
# ╟─ed94a586-26ab-4091-92b0-de4a81f77111
# ╟─52da3927-6bbb-4820-961b-92d6b17ec8cd
# ╟─1983630a-ff08-4afe-9fca-0fccfb456d1b
# ╟─1fe8aa3d-a52b-489b-b996-11ccd53df42e
# ╟─e66709b6-8ae2-45cc-932d-be8f3898aabb
# ╟─2b70f85c-57e8-44a1-8dc9-6bf4fa2798ca
# ╟─1d171200-ce6a-4881-8777-9493d0c29d88
# ╟─48eecf30-3355-4087-902f-3481d4b272cd
# ╟─f6cec82d-24dd-4214-ba4e-6a4293aaac24
# ╟─bbc0eb4f-1228-4fe0-ba75-104b88e3e250
# ╟─5f1f7065-5e60-4266-b422-94f7d7750d1f
# ╟─0788d300-cc0d-4d43-9ee0-a7c91d542605
# ╟─d564fc1c-4cc8-442f-af3c-906cf6f59f07
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
