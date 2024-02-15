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
	using OrderedCollections
	#using StatsBase
	using Plots
	# plotly()
	md"""*You can unhide this cell to see the Julia environment.*"""
end

# ╔═╡ a5cdfaee-238c-40d3-823c-c41754c8ee66
using BioSequences

# ╔═╡ cacfdf8a-413e-49b6-a837-773155fb1d6a
# This function is part of the `PlutoUI` pacakge:
TableOfContents()

# ╔═╡ c7925ead-597a-446e-9508-24401dbbb488
md"""*Template notebook: last modified* **Feb. 15, 2024.**"""

# ╔═╡ e30883ff-1930-4f75-bde8-0ab46e355693
md"""
!!! alert "Requirements for assignment: Comparing DNA sequences"

    1. Familiarize yourself with the Julia `BioSequences` package by figuring out basic information about some of its types and functions.
    2. Staring from a nucleotide sequence, find a sequence of amino acids. Find out how many ways each amino acid is encoded, and at what positions in the codon the encoding could vary for each amino acid. This template notebook guides you through this process.
    3. When you have completed all missing sections of code and discussion, save your notebook as a file named {LASTNAME}-lab2.jl substituting your last name for {LASTNAME}, and add the file to your personal folder on the course Google drive.
    4. Make sure everyone in your group has submitted a notebook with identical solutions to the problem.  Include your individual thoughts in the final reflection section of the notebook.

"""

# ╔═╡ cebc9afd-5f7d-4e7d-a639-5c4ddfbc6455
md"""## Publication"""

# ╔═╡ 9b0a3d35-057c-44fc-b153-b05e02f0f081
md"""
*Authors*: **-->ALL NAMES OF COLLABORATORS HERE<--**


*Date last modified*: **Feb. 12, 2024** **-->UPDATE THIS DATE WHEN YOU SUBMIT YOUR ASSIGNMENT<--**

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
    3. Then we'll build two dictionaries: one to show what codons appear for each amino acid, and one to show what unique encodings appear for each amino acid, so that we can look up what codons occur for each amino acid in our sequence.
    4. We'll map each codon to a list of three true / false values recording whether the nucleotide at that position is always the same (true), or varies (false == not uniform). This is one more vector parallel to the vectors for amino acids and for codons: we'll take advantage of Pluto's easy graphics to visualize that variety.
"""

# ╔═╡ c4c14430-eb66-46a4-99a5-fb655a7758cf
md"""### A. the Julia `BioSequences` package"""

# ╔═╡ 3de371de-5054-4c88-9d7f-7010eefce7ca
md"""
The Julia `BioSequences` package was developed by biologists to simplify working with data about DNA sequences.  It's not a built-in part of the Julia langauge, so we'll need to tell Julia to include it in our current session, with the keyword  `using`.
"""

# ╔═╡ 3787be32-9588-4602-82ad-09df3628a258
md"""The package includes special types for sequences of nucleotides and for sequences of amino acids.
"""

# ╔═╡ 1789b8fa-00eb-42ed-b71d-2035c6c02ecd
md"""#### Nucleotides"""

# ╔═╡ 8e0b1157-62d5-40bd-8a3e-e24b30f64f7d
md"""

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

# ╔═╡ 7ab79419-624a-4231-ad4f-6336b047cf17
md"""Notice that the *type* of the object we created is `DNA`, and its value is `DNA_A`. This is not a string of characters, but a special value for the base adenine.  (Compare this to the way the boolean type has special values named `true` and `false` that are not strings of characters.)
"""

# ╔═╡ 1c97feb4-2f50-4caf-92e5-da7f5b5c9667
 md"""The DNA type won't let you work with bad data: if you try to convert an invalid character, you'll get an error message. Uncomment the following line, and see what happens.
 
 
 """

# ╔═╡ 2a58c6a3-89ab-474a-a24e-5d7de5a2d0a5
# convert(DNA, '🧨')

# ╔═╡ 1b4fd427-a08d-43c6-a5e8-a8005320179d
md"""Of course we're really interested in looking at *sequences* of DNA. The package lets you create a sequence of these DNA objects from a single string, as illustrated here.

"""

# ╔═╡ 159a2399-81d3-4148-957d-c90f5c5e4e66
ntide_example = LongDNA{4}("ATGATT")

# ╔═╡ eabbb5bf-f110-46ed-8675-cf66b5585c10
md"""
The displayed value tells us that this is a 6-nucleotide sequence (`6nt DNA Sequence`), with the six bases `A`, `T`,  `G`, `A`, `T`, `T`, in that order.
"""

# ╔═╡ 464bdada-aada-4da2-a58d-478c25a3f89b
md"""Let's look at its type:"""

# ╔═╡ a449057e-9714-4f8b-a537-aa63eee180a2
typeof(ntide_example)

# ╔═╡ e90e9b55-4bdd-4c70-9d76-92e25fb1cdf3
md"""`LongSequence` is just a specialization of the generic Vectors you've already been using, but now instead of allowing any kind of element to be contained in the vector, a `LongSequence` is a Vector that only contains legitimate biological sequence data.

That means that everything you already know how to do with a Vector, you can do with a `LongSequence`!
"""

# ╔═╡ 09dc336a-b0af-4036-a5b4-6ada19f4b940
md"""We can use a numeric index to look a specific element, for example:"""

# ╔═╡ 13262ed5-7e38-4431-b75d-c453def8ffd5
ntide_example[1]

# ╔═╡ 16ba1c79-0068-46a9-a948-8974e9c9ccd9
md"""One important fact to know about a sequence is how many nucleotides are in it."""

# ╔═╡ d1cc8f2d-97ff-48ee-adac-f4b96e54846e
length(ntide_example)

# ╔═╡ def367ea-df15-4274-a86b-15ddf7958b2b
md"""As with any vector, we might generically want to know what distinct values it includes -- here, what different bases are represented?"""

# ╔═╡ e093e012-dab9-41ef-8daa-3bae19bc88cf
unique(ntide_example)

# ╔═╡ 5c1652ee-414b-498c-bfa9-6d8e30cd7be6
md"""If we want to find *how many* unique values there are, we can of course just count how many unique values there are. One way to string together functions for finding and counting a list of unique values is to use Julia's "pipe" syntax.
"""

# ╔═╡ fee93b2f-f889-4623-825d-dd170120880a
unique(ntide_example) |> length

# ╔═╡ bf29f041-e685-40cd-bdb0-30acde2b5e5b
md"""The package has a handy macro for creating a sequence from a string, predictably named `dna`.  Its syntax is just like the macro you  use in Pluto notebooks to create a Markdown formatted object from a string."""

# ╔═╡ f0684962-48bd-44d2-9e36-bb75cddf6968
n_tide = dna"ATG"

# ╔═╡ 4e8140c3-492c-4fa0-a13b-1f1651a596ae
md"""#### Amino acids"""

# ╔═╡ 7317c315-8169-498b-b711-46e03293f151
md"""The `BioSequences` package also has a special type for amino acids. As with nucleotides, you can create an `AminoAcid` object using the `convert` function together with the standard character abbreviation for that amino acid. 
"""

# ╔═╡ 64b0aebd-6e60-45bb-82c5-f9281d64260c
one_methionine = convert(AminoAcid, 'M')

# ╔═╡ 2722450e-1f58-422b-b4f6-3661336022a9
md"""The package includes a `translate` function to handle the fundamental task of converting a sequence of nucleotides into a sequence of amino acids. You provide one required parameter, a DNA sequence, and it returns a sequence of amino acids. You may optionally provide a parameter specifying a particular code to use. The package provides a vector named `ncbi_trans_table` with the following coding tables that can be used for this optional parameter:
"""

# ╔═╡ 5045cd5d-bb29-4812-a112-492a84783fe4
ncbi_trans_table

# ╔═╡ 09749743-2f88-4ac3-9003-f88b9778aa38
md"""Since we're looking at mitochondrial DNA, we'll use the fifth entry:"""

# ╔═╡ 1dd0d47d-7e57-4645-8104-09ebea0cf8b3
mitochondrial = ncbi_trans_table[5]

# ╔═╡ dd9f8b27-b9d7-44e6-850c-e5581de69c84
md"""Let's walk through a brief example. First we create a nucleotide sequence."""

# ╔═╡ c7ff8cef-6300-4afa-a55a-8cd7a5267f23
short_dna_example = dna"ATGATT"

# ╔═╡ fd2dd571-a11b-4640-b8b0-eb4dd0877882
md"""Now we'll create the sequence of amino acids that those nucleotides encode with the `translate` function.

We're using both the `BioSequences` package and the `Plots` package in this notebook, and *both* packages have a function named `translate`! To make clear which functoin we mean, we include the package name before the function. 
"""

# ╔═╡ 7ad8ffae-6604-414b-83c3-53676be1f497
short_aa_example = BioSequences.translate(short_dna_example, code = mitochondrial)

# ╔═╡ aa4aebcc-a710-4519-9daf-945bcb2b02dc
md"""Its displayed value means that we have a 2-amino acid sequence (`2aa Amino Acid Sequence`) with the two values `M` and `I` in that order.
"""

# ╔═╡ 5990561b-e760-415e-ac2b-461381d796c9
typeof(short_aa_example)

# ╔═╡ 92b053d6-4548-4a3c-827f-e05b913fd240
md"""Notice that this is another example of a `LongSequence`. The annotation in curly brackets tells us that we have a valid biological sequence, but in this case elements in the vector are amino acids rather than nucleotides.
"""

# ╔═╡ 440ecca6-c2b1-499a-b801-48fcc8bc3316
md"""
In each of the two following cells, replace `missing` with a julia expression to count the number of elements in the example nucleotide sequence and the example amino acids sequence.
"""

# ╔═╡ be0ca947-a2ee-4f43-ab44-fe8dec44f3bc
short_dna_count = missing

# ╔═╡ f8910883-f348-4e57-8321-8c055c0c79aa
short_aa_count = missing

# ╔═╡ 22c6d066-3bfa-4f67-b7eb-089989454749
if ismissing(short_dna_count) || ismissing(short_aa_count)
	still_missing()
elseif short_dna_count != length(short_dna_example) || 
		short_aa_count != length(short_aa_example)
	keep_working(md"Think about what you need to do here: we want to find how many items in in each Vector. How do you find the number of items in a Vector in Julia?")
else
	correct()
end

# ╔═╡ c3b1df4d-1270-4f66-b4eb-053beecaa216
md"""!!! tip "A question to think about"

    Compare the values you computed for `short_dna_count` and `short_dna_count`. How are they related?
"""

# ╔═╡ e6eef629-6608-43be-b6df-fb816ff56ffc
md"""
### B. Summarizing a DNA sequence
"""

# ╔═╡ 7515233b-34ef-4db5-b085-2e0d4cbf52d0
md"""In the rest of this notebook, we're going to compare sequences for the same gene in two different species.  The gene is called *Cytochrome Oxidase I mitochondria*; the two species we'll compare are people (*homo sapiens*) and a beetle (*dyscolus fusipalpus*).  We'll start by using the `BioSequences` package to help us summarize the contents of a sequence.

You can use the following menu to choose between the two species. Behind the scenes, functions in this notebook will respond to your choice by assigning a value to a variable named `species`, and by looking up a long string value represenithg a DNA sequence for the species you have chosen, as you can see in the following cells.
"""

# ╔═╡ d09913ca-00ed-48d2-af67-b7f66579adcb
md"""*Choose a species to analyze*: $(@bind species Select(["human" => "homo sapiens", "beetle" => "dyscolus fusipalpis"]))"""

# ╔═╡ 36523fee-f1d8-4747-8720-726eb6ae1800
species

# ╔═╡ e8e1d4ab-cfd9-4cef-b22a-e10cbf86f68c
md"""We'll turn this string of characters into a sequence of biological data, as we did in the previous section.
"""

# ╔═╡ 83ad4f26-527d-41d9-8132-11d36b21583e
md"""As you did above, replace `missing` with a Julia expression that counts the number of items in the DNA sequence."""

# ╔═╡ db992a77-e93d-40a7-981d-c7dbb79e07e4
nt_count = missing

# ╔═╡ f32a6518-ca63-4aeb-9989-29209f4a90af
md"""Replace the empty brackets `[]` in the follow cell with an invocation of the `translate` function from the `BioSequences` package to create a sequence of amino acids from the sequence of nucleotides.

As we did in the example above, use the encoding for mitochondrial DNA for the optional `code` parameter.
"""

# ╔═╡ 8845c1b1-b088-4a41-8c3b-e9ce218efad8
aa_seq = [] 

# ╔═╡ 386ff938-6803-4e0a-b623-a50fc0ce5d2d
aa_count = missing 

# ╔═╡ 1d77e0cb-3cf6-4bf8-996a-4e9abcd9e8e1
aa_values_count = missing 

# ╔═╡ 8f63d991-5c01-48e4-b8ad-5611b3607bbc
if ismissing(aa_count)  || ismissting(aa_values_count)
	still_missing(md"Supply expressions to find `aa_count` and `aa_values_count`")
elseif aa_count != length(aa_seq)
	keep_working(md"This is the same problem you addressed in the previous section: how many items are in the Vector `aa_seq`?")
elseif aa_values_count != length(unique(aa_seq))
	keep_working(md"You've seen this kind of problem: how many *unique* values are in the Vector `aa_seq`?")
else
	correct()
end

# ╔═╡ 1a9ca373-621a-45f7-8eef-08ebe6746841
md"""#### Codons"""

# ╔═╡ 55eb9bea-573a-4563-991b-87b267373d76
md"""This notebook includes a function named `splitcodons` that is *not* part of the `BioSequences` package. It takes one parameter, a sequence of nucleotides, and groups them into sequences of three nucleotides. The result is a Vector of Vectors -- a long list containing vectors that are each three items long.
"""

# ╔═╡ dfbd143b-8201-4cf0-a6a6-76c709b346cc
md"""
 Each list of three nucleotides corresponds to one amino acid.  Let's verify that we've got the right number of codon groups.
"""


# ╔═╡ 8382cdc7-13bd-47d1-b507-b6d9ee94fcd7
codon_count = missing 

# ╔═╡ 0ab106ba-d840-4bd1-8bfa-e75a214ce399
codon_count == aa_count # when this is true, you've done it right!

# ╔═╡ d80a8982-7035-41fd-a7b9-78662ebcf4bd
codon_values_count = missing 

# ╔═╡ c5e87c41-1a46-4a76-b344-cf9acf32f048
md"""The next cell uses *interpolation* to include the values you have computed in a single long string formatted as Markdown with the `md` macro.

"""

# ╔═╡ f56a5b59-e986-4293-a433-dd7118ba2323
md"""#### Summary of Cytochrome Oxidase I mitochondria gene for a $(species)

- number of nucleotides in sequence: $(nt_count)
- number of amino acids in sequence: $(aa_count)
- number of distinct amino acids: $(aa_values_count)
- number of distinct encodings (codons): $(codon_values_count)
"""

# ╔═╡ 54f5e863-aa85-4755-992c-d60b7ac5ecc4
md"""!!! tip "💡 You can unhide the preceding cell to see how it interpolates your data into a summary report."
"""

# ╔═╡ 7ea655b6-0d60-450a-9b82-d3f68373f4b3
#aa_srcs = unique(codon_translations)

# ╔═╡ 1ddbcc54-7218-445a-acbe-28fcca1b6723
md"""### C. How many ways can an amino acid be encoded?"""

# ╔═╡ d8fe7623-f72a-4545-9bfe-8fd87dd05528
md"""
You have already created parallel lists of amino acids and codons (sequences of three nucleotides).

We'll approach the question of how each amino acid can be encoded in two steps:

1. From our parallel lists of amino acids and codons, we'll make a *dictionary*. The keys to the dictionary will an amino acid: the value for each amino acid will be the full list of codons matched with it in the parallel list. This tells *how frequently* each amino acid appears in our sequence.
2. We'll then build a second dictionary, again with amino acids as the keys, but this time giving for the value the list of *unique values* in the original list. This gives all us the possible encodings for each amino acid. We can use the counts of unique values to tell us *how many different ways* an amino acid is encoded.



"""

# ╔═╡ 6c2d306e-9e29-43f2-9b7a-4da102df9ed5
md"""#### Step 1: get the frequency of each amino acid"""

# ╔═╡ 5ad5a404-d8e1-4a5b-9a15-d2c8fea2d051
md"""Here's a function that can solve our first step:
"""

# ╔═╡ a9e40cd9-c87c-42a9-92d1-5fafb03a9635
"""Build an ordered dictionary from two parallel lists. Use the values in the first list as the keys to the dictionary, and for the value of the dictionary, compile all the values from the second list that are paired with this key.

For example, if the first list was a list of team numbers, and the second list gave the names of members, the resulting dictionary would let you look up all the team members by the number of the team.
"""
function onetomanydict(keyslist, valueslist)
	if ismissing(keyslist)
		missing
	else
		dict = OrderedDict()
		for (i, aa) in enumerate(keyslist)
			if haskey(dict, aa)
				push!(dict[aa], valueslist[i])
			else
				dict[aa] = [valueslist[i]]
			end
		end
		sort(dict)
	end
end

# ╔═╡ 2215a522-b5cf-405e-9467-6c88410ff53b
md"""In the following cell, we create a dictionary that will use our amino acids sequence for keys, and compile a list of codons matched with each amino acid.

"""

# ╔═╡ 496f4da7-5817-4754-80cf-099d8a61b288
md"""Make sure understand how your dictionary works.  Uncomment the following line to see what the dictionary gives for the key `AA_I` (isoleucine), or try another amino acid as the key and see what the resulting value looks like.
"""

# ╔═╡ c24afebe-b88a-44c8-aa14-8f4f86b9392e
#aadict[AA_I]

# ╔═╡ 776bbd7c-de58-49be-a7c1-42e679fc1dd3
md"""In the following cell, replace `missing` with a Julia expression that finds the number of times the amino acid isoleucine occurs in your sequence.
"""

# ╔═╡ ca528421-0855-41c6-a840-9bc7435e9b7d
aa_i_count = missing

# ╔═╡ 4d388989-dfea-47b8-8f74-f3def21606de
md"""#### Step 2: find unique values.

The following cell has the outline of a function that will take our existing dictionary and build a new one. Instead of listing *all* occurrences of codons for each amino acid, the new dictionary will instead list only the unique values for each one. The first dictionary shows us how frequently an amino acid occurs; the second dictionary will show us how many different ways it can be encoded.

The function cycles through every key value in the starting dictionary. You'll need to retrieve the value for that key (i.e., `dict[key]`), and count the unique items in the resulting list.  Then assign that new list of unique values to the new dictionary, using the same amino acid as the key.  Your assignment will look something like

`uniquevalues[key] =` *whatever list you computed for unique values*

"""

# ╔═╡ 090335fe-0d57-40a4-8e79-a76b5a95f46f
md"""In the following cell, follow the hints given in comments to complete the body of the `for` loop.
"""

# ╔═╡ 5f1b846e-18c2-4b78-87bb-57871ccd7d07
"""Given a dictionary that has a vector for each value, create a new dictionary with the same keys, but using the *length* of the vector for its value.

For example, if we had a dictionary that had team numbers as keys and a list of team members for its values, the new dictionary should have the same team numbers as keys, but have as its value the number of members of the team.
"""
function uniquedict(dict)
	uniquevalues = OrderedDict()
	for key in keys(dict)
		# Assign a value to the new dictionary (the one named `uniquevalues`).
		# Remember you can assign values directly to a dictionary. 
		# The left side of the assignment (=) will refer to a specific
		# value in the dictionary using a key in square brackets;
		# the right side of the assignment will be the value you
		# want to look up with that key.
		# In this case, the value should be a list including only the unique values for that key
	end
	return uniquevalues
end

# ╔═╡ 6f19c952-020e-4a14-9652-1fc2498c2250
md"""### D. Where in each codon does variation occur?"""

# ╔═╡ c02480c9-288d-4f3e-bd2d-7d592b93f2cb
md"""
Using dictionaries to index codons to amino acids, you have found (1) how often each amino acid occurs, and (2) how many different ways it can be encoded. In the final section of this notebook, we'll use the same data to see whether variations in the encoding of each amino acid occur in the first, second or third nucleotide of the codon.
"""

# ╔═╡ 740140fb-9eb6-436f-82a0-d96903011b30
md"""
This notebook includes a function named `uniform_slots`. When you give it one amino acid and our dictionary of encodings, it looks at the different encodings and deteremines if there are uniform or if there is any variety at each of the three nucleotides. It represents this as a Vector with three true/false values: true means that the encoding is consistent (always the same value at that nucleotide), false means that more than one nucleotide is used at that position.
"""

# ╔═╡ 3efec0dc-e441-47ec-8b3a-249ff18db111
#unique_encodings[AA_I]

# ╔═╡ 3a2df03c-273b-4f5d-a2bc-229b23e77ab0
#uniform_slots(AA_I, aadict)

# ╔═╡ e3007454-efe2-4936-98f3-396e8a9fe343
md"""
We will now apply the `score_isuniform` function to *every* amino acid in our list.

To do that, we'll need to learn how to add items to an existing vector with Julia's `push!` function.  The `!` in the name is a convention warning you that the function doesn't just compute a new value: it actually changes one or more of the parameters you supplied. 
"""


# ╔═╡ 0977d5a9-c2e9-4961-82d6-dc33880f9744
"""Add item to a vector."""
function additem(vect, item)
	push!( vect, item)
end

# ╔═╡ 8430413d-8ced-4717-99ae-3718f5df4c7d
letters = ["a", "b", "c"]

# ╔═╡ 0d93b29f-f8f3-4662-8060-14b3ac92381e
additem(letters, "a")

# ╔═╡ 814fbaea-e408-482b-b54c-25caed2cab70
md"""
Now back to our problem. We want to write a function that collects a score of true/false values for every amino acid in our dictionary's list of keys.

The following cell outlines a function to do just that. It starts by creating an empty vector named `tfvalues`. It then loops through all the keys in our dictionary.  

Follow the hints in comments to complete the body of the for loop.

"""

# ╔═╡ 5c221bf7-b718-427e-bded-78cdad406531
"""Using the `uniform_slots` function, create a score for every amino acid in the list of keys for a dictionary listing codons for each amino acid.
"""
function score_positions(aalist, dict)
	tfvalues = []
	for aacid in aalist
		push!(tfvalues, score_isuniform(aacid, dict))
		# use the `uniform_slots` function to get a score for `aacid`,
		# and add that score to the vector `tfvalues`
	end
	return tfvalues
end

# ╔═╡ 93a15dd9-76da-4929-a9a6-715c42599085
md"""### E. Visualizing results in Pluto"""

# ╔═╡ c9f8dc1a-1610-4de6-9f5c-d6e6136a4dbf
md"""### F. Next steps"""

# ╔═╡ 30cbe23b-9410-4ed1-a1cf-7ff2aefe97b2
md"""
!!! note "Next steps"

    What further questions does your work on this notebook raise?

    Are there other things you want to find out about this data set, or other things you want to learn more about to understand this material better?  

    What would be your next steps if you were continuing to work on this without specific instructions or requirements?
"""

# ╔═╡ c1f02c7a-8a54-44e3-bc15-f0e4f2b0fa9e
md"""**==>ADD YOUR IDEAS ABOUT NEXT STEPS HERE<==**


"""

# ╔═╡ 8f9484fa-1960-41e1-8652-8a5c2285651b
md"""## 3. Reflection

"""

# ╔═╡ b62e573a-bd3b-41d7-8039-629ad0335df7
md"""
!!! note "Reflection: relating multiple features"


    In this lab, you aligned different models of the same DNA data. By comparing a DNA sequence modelled as amino acids with the same sequence modelled as codons, you were able to make original discoveries about the DAN sequence of a particuilar gene in two different species.

    How can you transfer your experience in this lab to other problems? Think of at least one other question you think you could address by defining multiple features for the same series of entities, and relating the values in parallel vectors of features. (You don't need to do this, or even know exactly how you would solve the problem in detail.)

"""

# ╔═╡ ed94a586-26ab-4091-92b0-de4a81f77111
html"""
<br/><br/><br/><br/>
<br/><br/><br/><br/>
<br/><br/><br/><br/>
"""

# ╔═╡ 52da3927-6bbb-4820-961b-92d6b17ec8cd
md"""> Sequence data"""

# ╔═╡ 1983630a-ff08-4afe-9fca-0fccfb456d1b
dnastring = choose_co1(species)

# ╔═╡ 569d7a4a-ad58-4edf-b92b-0da64163a7ef
dnastring

# ╔═╡ 577afd6e-dbbb-414a-bdff-939da44b815a
dna_seq = LongDNA{4}(dnastring)

# ╔═╡ d64157e1-32c8-4567-b520-2415e4ea3cc8
if ismissing(nt_count) 
	still_missing()
elseif nt_count != length(dna_seq)
	keep_working(md"This is the same problem you addressed in the previous section: how many items are in the Vector `dna_seq`?")
else
	correct()
end

# ╔═╡ aee479a7-a367-4785-852f-331a22766558
if ismissing(nt_count) 
	still_missing()
elseif nt_count != length(dna_seq)
	keep_working(md"This is the same problem you addressed in the previous section: how many items are in the Vector `dna_seq`?")
else
	correct()
end

# ╔═╡ c71395e3-ce5b-4c0e-b92c-6316581ddc86
codons = splitcodons(dna_seq)

# ╔═╡ 2e1aec4a-513b-4b4c-b062-4ffd7eea9438
if ismissing(codon_count)  || ismissting(codon_values_count)
	still_missing(md"Supply expressions to find `codon_count` and `codon_values_count`")
elseif codon_count != length(codons)
	keep_working(md"This is the same problem you addressed in the previous section: how many items are in the Vector `aa_seq`?")
elseif codon_values_count != length(unique(codons))
	keep_working(md"You solved a problem just like this when you found the number of distinct values for amino acids.")
else
	correct()
end

# ╔═╡ b179d607-ef53-4122-96c5-3e1efaf31392
aadict = onetomanydict(aa_seq, codons)

# ╔═╡ 5e691819-5ea1-448b-bd2b-a46c4afdbdc4
if ismissing(aa_i_count) 
	still_missing()
elseif aa_i_count != length(aadict[AA_I])
	keep_working(md"This is the same problem you addressed in the previous section: how many items are in the Vector `dna_seq`?")
else
	correct()
end

# ╔═╡ 6fd7a85a-e22a-437e-bcdf-8834a9f87f72
if ismissing(aadict) || isempty(aadict)
	md"*When you have constructed your dictionary of amino acid encodings, the following cell will plot their values as a bar graph.*"
else
	md"""This graph shows us how many times each amino acid occurs in our sample."""
end	

# ╔═╡ af3162f5-ee89-425a-9340-9741b22be55c
if ismissing(aadict)
	md""
else
	aalabels = aadict |> keys |> collect .|> string
	vallists = aadict |> values |> collect
	aafreqs = map(vallists) do list
		length(list)
	end
	bar(aalabels, aafreqs, xticks = :all)
end


# ╔═╡ 5e3f6650-2d77-403c-83a7-1cc157f6fc23
unique_encodings  = uniquedict(aadict)

# ╔═╡ 6576ff9f-5dad-46b0-907b-6192b7bb268c
if ismissing(unique_encodings) || isempty(unique_encodings)
	keep_working(md"Your definition of the `uniquedict` function is still returning an empty dictionary.")
else
	correct()
end


# ╔═╡ 36ba4be3-f5d9-4df0-b24a-946f2b447b91
if ismissing(unique_encodings) || isempty(unique_encodings)
	md"""*When you have constructed the dictionary of unique encodings for each
	amino acid, the following cell will plot their values as a bar graph.*
	"""
else
	md"""Now we can visualize how many different ways each amino acid is encoded."""
end

# ╔═╡ d1307742-5fe6-482d-b92b-cf1790d30b8d
if ismissing(unique_encodings)
	md""
else
	#aalabels = aadict |> keys |> collect .|> string
	unqlists = unique_encodings |> values |> collect
	unqfreqs = map(unqlists) do list
		length(list)
	end
	bar(aalabels, unqfreqs, xticks = :all)
end

# ╔═╡ 7a2dd394-b6ef-4239-a417-0c6edfe77b79
unique_encodings

# ╔═╡ af917767-c3a0-4470-b356-83e9a93b69fc
if isempty(unique_encodings)
	keep_working(md"Your definition of the `uniquedict` function is returning an empty vector.")
else
	correct()
end

# ╔═╡ cfd6ef93-1708-4704-a7df-75e3094d5108
if ismissing(aadict)
	md""
else
	md"""Uncomment the following two cells and compare the results.

All the codons begin with `AT` but the third position varies. `score_isuniform` reports this as `[true, true, false]`.


"""
end

# ╔═╡ b1472850-ab6b-4b29-9ee8-5fe6c7a60d9e
aa_scores = score_positions(aa_seq, aadict)

# ╔═╡ 7fb75fdf-6dce-4a50-ba95-67eeedd659b4
if isempty(aa_scores)
	md"""*When you have computed values for `aa_scores`, the following cell will display a highlighted visualization of the results.*"""
else
md"""
The table in the following cell lists your sequence of amino acids in the top row.

The bottom row lists the codon for each amino acids, and highlights the display according to your true-false scores, with highlighted nucleotides showing values that can vary for the same amino acid.

"""
end

# ╔═╡ e2d08eda-64e3-450f-8aa9-7ab137b37526
if isempty(aa_scores)
else

tablify(
	codons,
	aa_scores,
	(aa_seq .|> string)
) |> HTML
end 

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

# ╔═╡ b2272623-59f4-4063-9bce-b2035986f6e1
aa_labels = aa_seq  .|> string

# ╔═╡ 89de8849-8bdf-4a89-bc92-d330013c52ef
md"""> Indexing and comparing data"""

# ╔═╡ e9390860-8d6c-4f71-b1cf-1b8e7b1dc71d
"""For one amino acid in a dictionary listing codons for each amino acid, 
see if the encodings vary in the first, second or third nucleotide.  Return a Vector of three boolean values, where `true` means the encoding is uniform (no variation), and `false` means the encoding is not uniform (two or more different values occur there).
"""
function uniform_slots(one_aa, aadict)
	codons_for_aa = aadict[one_aa]
	uniform = Bool[]
		
	for i in 1:3 
		ntvals = map(codonlist -> codonlist[i], codons_for_aa)	|> unique
		if length(ntvals) == 1
			# If there's only one solution, then it's uniform
			push!(uniform,true)
		else
			push!(uniform, false)
		end
	end
	uniform
end

# ╔═╡ 9fef495d-49d0-4276-bae6-55be114bd613
"""Create a dictionary from a parallel pair of lists. The first list
will be the keys for the dictionary, and will index the unique set of corresponding values.
"""
function indexlists(keylist, valuelist)
	dict = Dict()

	for (i,key) in enumerate(keylist)
		if haskey(dict, key)
			push!(dict[key], valuelist[i])
		else
			dict[key] = [valuelist[i]]
		end
	end
	
	for key in keys(dict)
		dict[key] = unique(dict[key])
	end
	dict
end


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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BioSequences = "7e6ae17a-c86d-528c-b3b9-7f778a29fe59"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BioSequences = "~3.1.6"
OrderedCollections = "~1.6.3"
Plots = "~1.40.1"
PlutoTeachingTools = "~0.2.14"
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "c1b6fa9f629a9c7df495935a706a0d3ef9f98d5d"

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

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

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

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "75bd5b6fc5089df449b5d35fa501c846c9b6549b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.12.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "ac67408d9ddf207de5cfa9a97e114352430f01ed"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.16"

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

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "3458564589be207fa6a77dbbf8b97674c9836aab"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "77f81da2964cc9fa7c0127f941e8bce37f7f1d70"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.2+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60b1194df0a3298f460063de985eae7b01bc011a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.1+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "04663b9e1eb0d0eabf76a6d0752e0dac83d53b36"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.28"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

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

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60e3045590bd104a16fefb12836c00c0ef8c7f8c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

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

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "862942baf5663da528f66d24996eb6da85218e76"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "c4fa93d7d66acad8f6f4ff439576da9d2e890ee0"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.1"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

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

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

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

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

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

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522b8414d40c4cbbab8dee346ac3a09f9768f25d"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.5+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "93284c28274d9e75218a416c65ec49d0e0fcdf3d"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.40+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
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
# ╟─1789b8fa-00eb-42ed-b71d-2035c6c02ecd
# ╟─8e0b1157-62d5-40bd-8a3e-e24b30f64f7d
# ╠═33c9848d-4e97-4d7c-933b-b0757853ee7a
# ╟─0e1c6264-452d-4436-95f6-6883c8608d93
# ╠═2e2379a6-3ad4-4391-bde0-7e0210bd0bbc
# ╟─71e384e7-7a23-456c-83c4-0768eabcb894
# ╠═2b368302-141f-4afe-aeae-3d6e649dcc44
# ╠═fb3246ac-5a2c-41e8-9141-43a46279f99e
# ╟─7ab79419-624a-4231-ad4f-6336b047cf17
# ╟─1c97feb4-2f50-4caf-92e5-da7f5b5c9667
# ╠═2a58c6a3-89ab-474a-a24e-5d7de5a2d0a5
# ╟─1b4fd427-a08d-43c6-a5e8-a8005320179d
# ╠═159a2399-81d3-4148-957d-c90f5c5e4e66
# ╟─eabbb5bf-f110-46ed-8675-cf66b5585c10
# ╟─464bdada-aada-4da2-a58d-478c25a3f89b
# ╠═a449057e-9714-4f8b-a537-aa63eee180a2
# ╟─e90e9b55-4bdd-4c70-9d76-92e25fb1cdf3
# ╟─09dc336a-b0af-4036-a5b4-6ada19f4b940
# ╠═13262ed5-7e38-4431-b75d-c453def8ffd5
# ╟─16ba1c79-0068-46a9-a948-8974e9c9ccd9
# ╠═d1cc8f2d-97ff-48ee-adac-f4b96e54846e
# ╟─def367ea-df15-4274-a86b-15ddf7958b2b
# ╠═e093e012-dab9-41ef-8daa-3bae19bc88cf
# ╟─5c1652ee-414b-498c-bfa9-6d8e30cd7be6
# ╠═fee93b2f-f889-4623-825d-dd170120880a
# ╟─bf29f041-e685-40cd-bdb0-30acde2b5e5b
# ╠═f0684962-48bd-44d2-9e36-bb75cddf6968
# ╟─4e8140c3-492c-4fa0-a13b-1f1651a596ae
# ╟─7317c315-8169-498b-b711-46e03293f151
# ╠═64b0aebd-6e60-45bb-82c5-f9281d64260c
# ╟─2722450e-1f58-422b-b4f6-3661336022a9
# ╠═5045cd5d-bb29-4812-a112-492a84783fe4
# ╟─09749743-2f88-4ac3-9003-f88b9778aa38
# ╠═1dd0d47d-7e57-4645-8104-09ebea0cf8b3
# ╠═dd9f8b27-b9d7-44e6-850c-e5581de69c84
# ╠═c7ff8cef-6300-4afa-a55a-8cd7a5267f23
# ╠═fd2dd571-a11b-4640-b8b0-eb4dd0877882
# ╠═7ad8ffae-6604-414b-83c3-53676be1f497
# ╟─aa4aebcc-a710-4519-9daf-945bcb2b02dc
# ╠═5990561b-e760-415e-ac2b-461381d796c9
# ╟─92b053d6-4548-4a3c-827f-e05b913fd240
# ╟─440ecca6-c2b1-499a-b801-48fcc8bc3316
# ╠═be0ca947-a2ee-4f43-ab44-fe8dec44f3bc
# ╠═f8910883-f348-4e57-8321-8c055c0c79aa
# ╟─22c6d066-3bfa-4f67-b7eb-089989454749
# ╟─c3b1df4d-1270-4f66-b4eb-053beecaa216
# ╟─e6eef629-6608-43be-b6df-fb816ff56ffc
# ╟─7515233b-34ef-4db5-b085-2e0d4cbf52d0
# ╟─d09913ca-00ed-48d2-af67-b7f66579adcb
# ╠═36523fee-f1d8-4747-8720-726eb6ae1800
# ╠═569d7a4a-ad58-4edf-b92b-0da64163a7ef
# ╟─e8e1d4ab-cfd9-4cef-b22a-e10cbf86f68c
# ╠═577afd6e-dbbb-414a-bdff-939da44b815a
# ╟─83ad4f26-527d-41d9-8132-11d36b21583e
# ╠═db992a77-e93d-40a7-981d-c7dbb79e07e4
# ╟─d64157e1-32c8-4567-b520-2415e4ea3cc8
# ╟─f32a6518-ca63-4aeb-9989-29209f4a90af
# ╠═8845c1b1-b088-4a41-8c3b-e9ce218efad8
# ╟─aee479a7-a367-4785-852f-331a22766558
# ╠═386ff938-6803-4e0a-b623-a50fc0ce5d2d
# ╠═1d77e0cb-3cf6-4bf8-996a-4e9abcd9e8e1
# ╟─8f63d991-5c01-48e4-b8ad-5611b3607bbc
# ╟─1a9ca373-621a-45f7-8eef-08ebe6746841
# ╟─55eb9bea-573a-4563-991b-87b267373d76
# ╟─c71395e3-ce5b-4c0e-b92c-6316581ddc86
# ╟─dfbd143b-8201-4cf0-a6a6-76c709b346cc
# ╠═8382cdc7-13bd-47d1-b507-b6d9ee94fcd7
# ╠═0ab106ba-d840-4bd1-8bfa-e75a214ce399
# ╠═d80a8982-7035-41fd-a7b9-78662ebcf4bd
# ╟─2e1aec4a-513b-4b4c-b062-4ffd7eea9438
# ╟─c5e87c41-1a46-4a76-b344-cf9acf32f048
# ╟─f56a5b59-e986-4293-a433-dd7118ba2323
# ╟─54f5e863-aa85-4755-992c-d60b7ac5ecc4
# ╟─7ea655b6-0d60-450a-9b82-d3f68373f4b3
# ╟─1ddbcc54-7218-445a-acbe-28fcca1b6723
# ╟─d8fe7623-f72a-4545-9bfe-8fd87dd05528
# ╟─6c2d306e-9e29-43f2-9b7a-4da102df9ed5
# ╟─5ad5a404-d8e1-4a5b-9a15-d2c8fea2d051
# ╟─a9e40cd9-c87c-42a9-92d1-5fafb03a9635
# ╟─2215a522-b5cf-405e-9467-6c88410ff53b
# ╠═b179d607-ef53-4122-96c5-3e1efaf31392
# ╟─496f4da7-5817-4754-80cf-099d8a61b288
# ╠═c24afebe-b88a-44c8-aa14-8f4f86b9392e
# ╟─776bbd7c-de58-49be-a7c1-42e679fc1dd3
# ╠═ca528421-0855-41c6-a840-9bc7435e9b7d
# ╟─5e691819-5ea1-448b-bd2b-a46c4afdbdc4
# ╟─6fd7a85a-e22a-437e-bcdf-8834a9f87f72
# ╟─af3162f5-ee89-425a-9340-9741b22be55c
# ╟─4d388989-dfea-47b8-8f74-f3def21606de
# ╟─090335fe-0d57-40a4-8e79-a76b5a95f46f
# ╠═5f1b846e-18c2-4b78-87bb-57871ccd7d07
# ╟─6576ff9f-5dad-46b0-907b-6192b7bb268c
# ╠═5e3f6650-2d77-403c-83a7-1cc157f6fc23
# ╟─36ba4be3-f5d9-4df0-b24a-946f2b447b91
# ╟─d1307742-5fe6-482d-b92b-cf1790d30b8d
# ╟─6f19c952-020e-4a14-9652-1fc2498c2250
# ╟─c02480c9-288d-4f3e-bd2d-7d592b93f2cb
# ╟─740140fb-9eb6-436f-82a0-d96903011b30
# ╟─cfd6ef93-1708-4704-a7df-75e3094d5108
# ╠═3efec0dc-e441-47ec-8b3a-249ff18db111
# ╠═3a2df03c-273b-4f5d-a2bc-229b23e77ab0
# ╟─e3007454-efe2-4936-98f3-396e8a9fe343
# ╠═0977d5a9-c2e9-4961-82d6-dc33880f9744
# ╠═8430413d-8ced-4717-99ae-3718f5df4c7d
# ╠═0d93b29f-f8f3-4662-8060-14b3ac92381e
# ╟─814fbaea-e408-482b-b54c-25caed2cab70
# ╠═5c221bf7-b718-427e-bded-78cdad406531
# ╠═b1472850-ab6b-4b29-9ee8-5fe6c7a60d9e
# ╠═7a2dd394-b6ef-4239-a417-0c6edfe77b79
# ╟─af917767-c3a0-4470-b356-83e9a93b69fc
# ╟─93a15dd9-76da-4929-a9a6-715c42599085
# ╟─7fb75fdf-6dce-4a50-ba95-67eeedd659b4
# ╟─e2d08eda-64e3-450f-8aa9-7ab137b37526
# ╟─c9f8dc1a-1610-4de6-9f5c-d6e6136a4dbf
# ╟─30cbe23b-9410-4ed1-a1cf-7ff2aefe97b2
# ╟─c1f02c7a-8a54-44e3-bc15-f0e4f2b0fa9e
# ╟─8f9484fa-1960-41e1-8652-8a5c2285651b
# ╟─b62e573a-bd3b-41d7-8039-629ad0335df7
# ╟─ed94a586-26ab-4091-92b0-de4a81f77111
# ╟─52da3927-6bbb-4820-961b-92d6b17ec8cd
# ╟─1983630a-ff08-4afe-9fca-0fccfb456d1b
# ╟─1fe8aa3d-a52b-489b-b996-11ccd53df42e
# ╟─e66709b6-8ae2-45cc-932d-be8f3898aabb
# ╟─2b70f85c-57e8-44a1-8dc9-6bf4fa2798ca
# ╟─1d171200-ce6a-4881-8777-9493d0c29d88
# ╟─48eecf30-3355-4087-902f-3481d4b272cd
# ╟─f6cec82d-24dd-4214-ba4e-6a4293aaac24
# ╠═b2272623-59f4-4063-9bce-b2035986f6e1
# ╟─89de8849-8bdf-4a89-bc92-d330013c52ef
# ╟─e9390860-8d6c-4f71-b1cf-1b8e7b1dc71d
# ╟─9fef495d-49d0-4276-bae6-55be114bd613
# ╟─bbc0eb4f-1228-4fe0-ba75-104b88e3e250
# ╟─5f1f7065-5e60-4266-b422-94f7d7750d1f
# ╟─0788d300-cc0d-4d43-9ee0-a7c91d542605
# ╟─d564fc1c-4cc8-442f-af3c-906cf6f59f07
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
