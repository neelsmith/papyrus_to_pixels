### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 852da716-5eef-4e55-a5ff-5efb2f0fd409
begin
	using PlutoUI
	TableOfContents()
end 

# ╔═╡ 33ae3546-98b9-4fb2-a912-09f1bf362e54
md"""# Class notes: Thurs., Feb. 1"""

# ╔═╡ 6f25ad27-20e8-4382-9409-e52535948223
md"""## Review of some Julia syntax"""

# ╔═╡ aba3e211-35df-4fc6-be2c-8aab307977e5
md"""Lines starting with `#` are *comments* -- Julia ignores them (and Pluto highlights them specially to remind you of that)"""

# ╔═╡ d3e37452-c134-11ee-2aba-67714688ae0e
# This is not code: just a note to myself

# ╔═╡ c3588f82-fdf3-4f91-b168-d6182bcd2a95
md"""Text between ouble quotes is a String value; a single character between single quotes is a character value."""

# ╔═╡ c383137d-654b-4e7e-96f3-e4fa098bbd19
typeof("A")

# ╔═╡ 134eafe8-b6cf-4446-bdd4-af09164ea6f9
'A'

# ╔═╡ 3963c8e2-cecc-4630-b811-f73d7656fa2c
md"""You can also use *triple quotes* to create a string object. This can sometimes be helpful with very long strings. Here's the first paragraph of Everett's address at Gettysburg."""

# ╔═╡ 62d908d9-83d9-48e4-aa45-48d3b9443746
txt = """STANDING beneath this serene sky, overlooking these broad fields now reposing from the labors of the waning year, the mighty Alleghenies dimly towering before us, the graves of our brethren beneath our feet, it is with hesitation that I raise my poor voice to break the eloquent silence of God and Nature. But the duty to which you have called me must be performed;–grant me, I pray you, your indulgence and your sympathy."""

# ╔═╡ a83e8867-07ee-4915-a515-6ac0ca2132e1
md"""`==` is an example of a function that takes exactly parameters.  It compares the two objects and returns `true` if they are equal, and `false` if they are not. (Those are Boolean values.)"""

# ╔═╡ 79b07b8f-d892-4813-a514-d18d3204a0a3
md"""You can use it like any other function: just list the two parameters between parentheses."""

# ╔═╡ d335ac5d-c001-44cb-86bd-3c20860d98c3
==('A', 'A')

# ╔═╡ 42a427b4-dcfc-4b89-ad0f-c9cd75d14cfb
md"""But if you prefer, Julia also allows you to use this syntax (`parameter 1`, then `function name`, then `parameter 2`), which might be easier for humans to read."""

# ╔═╡ 6ae29cb8-b8b6-46c0-abbc-5aee7d8a8f0b
'A' == 'A'

# ╔═╡ ddd1248b-be6f-40c9-bd5c-6c600083f2f8
md"""!!! warn "Pay attention to `==` vs. `=` !"

    Remember that *one* equals sign `=` is used to assign an object to a name; the function to compare two objects for equality is *two* equals signs `==`.
"""

# ╔═╡ 415d41d7-d0d8-48bf-81ef-ff52aa19cca4
md"""The function `!=` is the opposite of `==`: it means *not equals*."""

# ╔═╡ 93b68378-0f53-4847-8c93-4f1b2d777016
'A' != 'a' 

# ╔═╡ ba036c9e-d3ae-421f-8954-d63d78578e6b
md"""### Strings and characters"""

# ╔═╡ 300275ec-2061-451d-ba1f-684c32d5f6fa
count = length(txt)

# ╔═╡ 7d7ef710-18da-48d6-be67-1f4357384dab
md"""Convert case of strings and characters:"""

# ╔═╡ ef347321-53b1-4460-98a8-84c5e856e035
uppercase(txt)

# ╔═╡ d91e2b56-7be7-4e23-8c59-06fb313888b6
uppercase('a')

# ╔═╡ e72ea051-67c1-4f44-be39-185d14c68f89
lowercase(txt)

# ╔═╡ a831b1c4-38aa-4286-8ced-7bf6dac568c5
lowercase('A')

# ╔═╡ 6a23f3de-1033-4c6e-ad0c-77f17bad7f7b
lowercase("STANDING") == lowercase("Standing")

# ╔═╡ e367557d-b6ba-49a2-bdde-db855e5d271d
md"""Strings only:"""

# ╔═╡ 28f3cedd-0ced-4975-b3b7-c4134f4d33ea
titlecase(txt)

# ╔═╡ 917bb4bc-88df-4510-ba92-fae2edaa2a4e
md"""Julia knows how the Unicode standard classifies each character:"""

# ╔═╡ 1fab66d9-ae9f-419c-87f5-480be90651de
isuppercase('Ω')

# ╔═╡ 33eef813-ae45-459a-aa8e-25f9643f2799
isletter('a')

# ╔═╡ 72f76525-61d5-48f3-9958-2ef020f180ea
isdigit('8')

# ╔═╡ bca77b7f-7de5-454a-b022-26aa04e0d8ac
ispunct('?')

# ╔═╡ 207f236a-3983-4b25-a386-f240375f7973
md"""Use the `md` prefix before a string value to define a Markdown string.

> (If you want learn about Markdown, have a look at this [60-second introduction](https://commonmark.org/help/).)
"""

# ╔═╡ f88206dd-61eb-45d8-95f6-9575267f2512
md"Hey, *emphasize* this"

# ╔═╡ dcdf02c6-2416-4404-8236-d6e101cdd3ce
md"You can use the `string` function to create a single composite string from an arbitrary number of parameters."

# ╔═╡ b3f08973-8387-4a8a-8057-0c167230e3e9
string("The opening paragraph of Everett's Oration is ", count, " characters")

# ╔═╡ ccca6c93-b815-4ab4-ba41-3db32a708846
md"""As an alternative, you can include a Julia expression within a string using the syntax illustrated here (`$` followed by expression in parentheses)."""

# ╔═╡ 16c9e3e3-2e7f-4b38-a20b-6947c1dbbf9c
summary = "The opening paragraph of Everett's Oration is $(count) characters"

# ╔═╡ c70c9a04-a33a-4f87-b3aa-f8607c5eb6ba
md"""One important function that you'll use in your next lab for working with strings is `split`. When you split a string, you create a *Vector* of strings."""

# ╔═╡ 1eb3a5f9-03cf-4923-9175-45877c8e7fb0
split(txt)

# ╔═╡ 2aa063ab-68c7-48e8-9f4b-a8038cf6c75d
md"""Include an optional second parameter if you want to specify what substring the text should be split on."""

# ╔═╡ 2b72d054-bfcd-4f04-8d1c-3f39bf7c627a
seq = "ATG;ATT;GCT"

# ╔═╡ 547b27a2-4613-4222-95b9-2269f9fde08c
split(seq, ";" )

# ╔═╡ 2f3ed08a-1ae8-4827-90f2-ed5b1235ca90
md"""## Vectors are collections"""

# ╔═╡ 8abd95cd-ecaa-4f81-885c-3b6afbd500c0
md"""

Vectors:

- are *ordered*
- usually contain objects of the same type

"""

# ╔═╡ 9a63cbfd-b231-4ee0-9dcd-3bf619d0896a
md"""Let's use `split` to make a list (Vector) of words in our text after we've converted the text to lower case."""

# ╔═╡ bd66353d-a3d8-4009-876e-4c045633f2a6
everett_lc = lowercase(txt)

# ╔═╡ 9b19420e-c109-40e5-922d-41feeeb7e19e
wordlist = split(everett_lc)

# ╔═╡ f5c326bf-4625-4324-a196-e564eae69f05
md"""Things you can ask about any Vector:"""

# ╔═╡ 86d1f2df-af76-4670-9617-a9d30548b41d
length(wordlist)

# ╔═╡ 38530073-e8ae-499d-8de6-2a3df98f0aa4
isempty(wordlist)

# ╔═╡ 8457fb77-c2cd-491a-b5ef-69014f3adc2c
sort(wordlist)

# ╔═╡ 85e162c0-0823-4e09-8973-2913723523a3
md"""Indexing into a Vector:"""

# ╔═╡ 3c37d441-258d-45b6-9c1f-3fa3182c6b4d
wordlist[1]

# ╔═╡ 95ae1129-be30-436c-83c0-f629f2a8e01e
wordlist[2]

# ╔═╡ 126d47bb-4b25-4f6f-8e0d-9b9e842b860f
wordlist[end]

# ╔═╡ f9f86a7f-ee78-4ff8-b19d-0c20808f15a7
md"""### Filtering"""

# ╔═╡ 04c5eed0-139f-48f6-9aa7-87d3662efed6
md"""
Create a new Vector by *selecting* items from a Vector:

- use a Boolean test to decide which items to keep
- every item in the Vector is also in the original Vector
- the new Vector will have anywhere from 0 to all of the original items depending on your text
"""

# ╔═╡ 3873b1fb-04e8-4785-a6e6-ed98e2abd854
longwordlist = filter(wordlist) do wrd
	length(wrd) > 8
end

# ╔═╡ d76c572d-fd82-42c1-8b44-535a00f99631
md"""### Mapping"""

# ╔═╡ b302439f-0610-44b9-bc59-166614f2d6bc
md"""
Create a new Vector by *transforming* every item in a Vector:

- create a new value for each element in the original Vector
- the new Vector will have exactly the same number of elements as the original Vector
- the items in the new Vector may be a completely different type than the objects in the original Vector
"""

# ╔═╡ 9cbc0719-f26c-49d1-a1a4-cb6c74b02fa1
md"""Map every word (a String) to its length (an integeter):"""

# ╔═╡ a495f82c-d16b-496d-ae0c-f7dd8b800956
wordlens = map(wordlist) do wrd
	length(wrd)
end

# ╔═╡ 6dfc90c5-bdac-4bd6-84cf-b07ee25a6552
sort(wordlens)

# ╔═╡ c3bf27a8-3e71-4660-8b04-0698fbe3e9e3
sort(wordlens, rev = true)

# ╔═╡ 72acd932-2b93-443f-bdf7-cbad7a3ff918
md"""## Applying what you've learned: finding the proportion of "long" words in a text"""

# ╔═╡ 8b405dfa-c490-4904-b871-3770962e8379
md"""
Here's a breakdown of how we could approach this:
1. split text into words
1. count total words
1. define "long" word
1. count long words
1. divide long count / total (= proportion)
"""

# ╔═╡ e6a90754-f42a-404c-beda-81bd1cd4f0ba
md"""### Step 1: split text into words"""

# ╔═╡ 806041bc-4036-4dc8-8448-62e7dd4dbd5f
md"""We'already made a pretty handy word list when we converted our text to lowercase and split that up on white space. Let's just reuse it!"""

# ╔═╡ 3311c50e-6ec6-4d5b-b1d5-5824162b6b92
wordlist

# ╔═╡ a85e1133-aaaf-4a28-9d5e-43c3cfbb61b8
md"""### Step 2: split count total words"""

# ╔═╡ 0e8c4854-abec-4840-b82c-6520131cc879
totalwords = length(everett_lc)

# ╔═╡ eb67b4d0-7abe-48ed-ae89-73efb68f3ab5
md"""### Step 3: define "long" words"""

# ╔═╡ 63cd0b36-b5f8-4697-b3e1-f46cfcd8febf
md"""This step requires a little more thought. We can define a new function to test whether a word is a "long" word or not.  We'll supply two parameters:  the word (a String value), and a cutoff length: if the word is longer than the cutoff length, we'll call if long.
"""

# ╔═╡ d124eaa6-dd96-40ba-9bd7-bed1d46001d7
function islongword_version1(wrd, cutoff)
	length(wrd) > cutoff
end

# ╔═╡ edaf1146-a5b7-4bd5-8e52-40b2d13871d3
md"""Let's test it:"""

# ╔═╡ e93ad641-a57c-4d08-a2cf-a894d5e52359
islongword_version1("Short", 8)

# ╔═╡ b87e6e67-349b-47cf-be0f-acf672052a92
islongword_version1("Not_so_short", 8)

# ╔═╡ eebeb010-36b5-48b3-b1b4-33c8c141f93b
md"""We could make this a little nicer by defining a default value for our cutoff.  Notice that now we can either supply our own second parameter, or just go with the default.
"""

# ╔═╡ 3d29f079-56d7-41c7-b06d-ad50fb1a2d7d
function islongword_nicer(wrd, cutoff = 8)
	length(wrd) > cutoff
end

# ╔═╡ d185ed30-bca1-4d09-bf35-40de149a2753
islongword_nicer("obsequies")

# ╔═╡ 7e70b5d5-d49b-45d1-9f36-5f4d1cec8460
islongword_nicer("obsequies",  10)

# ╔═╡ bb1cf59c-0e4d-45e6-a4a4-5cdb975d426f
md"""### Step 4: count long words"""

# ╔═╡ 16d31ed5-d5c0-40ff-b8d0-c18f255830b8
md"""If we can get a *list* of all the long words, then all we have to do is use the `length` function to find how many there are.

Getting a list of long words is perfect for filtering: we want to select from our complete word list only the long ones.  Our new function `longword_nicer` returns a Boolean true/false value, so we can use it directly in a filter expression.

"""

# ╔═╡ 555df51b-8e79-43b3-8881-979e85e2f796
longwords = filter(wordlist) do wrd
	islongword_nicer(wrd)
end

# ╔═╡ e42c8268-3a27-41cb-935e-d2172c0cb1ed
md"""### Step 5: Compute the proportion

That's just dividing the number of long words by the total number of words.
"""

# ╔═╡ edb6957f-db0d-4b0d-825c-a19715358bfa
length(longwords) / totalwords

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "f64cdffc70331b0a2f407efefd54fd84eb680773"

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
# ╟─852da716-5eef-4e55-a5ff-5efb2f0fd409
# ╟─33ae3546-98b9-4fb2-a912-09f1bf362e54
# ╟─6f25ad27-20e8-4382-9409-e52535948223
# ╟─aba3e211-35df-4fc6-be2c-8aab307977e5
# ╠═d3e37452-c134-11ee-2aba-67714688ae0e
# ╟─c3588f82-fdf3-4f91-b168-d6182bcd2a95
# ╠═c383137d-654b-4e7e-96f3-e4fa098bbd19
# ╠═134eafe8-b6cf-4446-bdd4-af09164ea6f9
# ╟─3963c8e2-cecc-4630-b811-f73d7656fa2c
# ╠═62d908d9-83d9-48e4-aa45-48d3b9443746
# ╟─a83e8867-07ee-4915-a515-6ac0ca2132e1
# ╟─79b07b8f-d892-4813-a514-d18d3204a0a3
# ╠═d335ac5d-c001-44cb-86bd-3c20860d98c3
# ╟─42a427b4-dcfc-4b89-ad0f-c9cd75d14cfb
# ╠═6ae29cb8-b8b6-46c0-abbc-5aee7d8a8f0b
# ╟─ddd1248b-be6f-40c9-bd5c-6c600083f2f8
# ╟─415d41d7-d0d8-48bf-81ef-ff52aa19cca4
# ╠═93b68378-0f53-4847-8c93-4f1b2d777016
# ╟─ba036c9e-d3ae-421f-8954-d63d78578e6b
# ╠═300275ec-2061-451d-ba1f-684c32d5f6fa
# ╟─7d7ef710-18da-48d6-be67-1f4357384dab
# ╠═ef347321-53b1-4460-98a8-84c5e856e035
# ╠═d91e2b56-7be7-4e23-8c59-06fb313888b6
# ╠═e72ea051-67c1-4f44-be39-185d14c68f89
# ╠═a831b1c4-38aa-4286-8ced-7bf6dac568c5
# ╠═6a23f3de-1033-4c6e-ad0c-77f17bad7f7b
# ╟─e367557d-b6ba-49a2-bdde-db855e5d271d
# ╠═28f3cedd-0ced-4975-b3b7-c4134f4d33ea
# ╟─917bb4bc-88df-4510-ba92-fae2edaa2a4e
# ╠═1fab66d9-ae9f-419c-87f5-480be90651de
# ╠═33eef813-ae45-459a-aa8e-25f9643f2799
# ╠═72f76525-61d5-48f3-9958-2ef020f180ea
# ╠═bca77b7f-7de5-454a-b022-26aa04e0d8ac
# ╟─207f236a-3983-4b25-a386-f240375f7973
# ╠═f88206dd-61eb-45d8-95f6-9575267f2512
# ╟─dcdf02c6-2416-4404-8236-d6e101cdd3ce
# ╠═b3f08973-8387-4a8a-8057-0c167230e3e9
# ╟─ccca6c93-b815-4ab4-ba41-3db32a708846
# ╠═16c9e3e3-2e7f-4b38-a20b-6947c1dbbf9c
# ╟─c70c9a04-a33a-4f87-b3aa-f8607c5eb6ba
# ╠═1eb3a5f9-03cf-4923-9175-45877c8e7fb0
# ╟─2aa063ab-68c7-48e8-9f4b-a8038cf6c75d
# ╠═2b72d054-bfcd-4f04-8d1c-3f39bf7c627a
# ╠═547b27a2-4613-4222-95b9-2269f9fde08c
# ╟─2f3ed08a-1ae8-4827-90f2-ed5b1235ca90
# ╟─8abd95cd-ecaa-4f81-885c-3b6afbd500c0
# ╟─9a63cbfd-b231-4ee0-9dcd-3bf619d0896a
# ╠═bd66353d-a3d8-4009-876e-4c045633f2a6
# ╠═9b19420e-c109-40e5-922d-41feeeb7e19e
# ╟─f5c326bf-4625-4324-a196-e564eae69f05
# ╠═86d1f2df-af76-4670-9617-a9d30548b41d
# ╠═38530073-e8ae-499d-8de6-2a3df98f0aa4
# ╠═8457fb77-c2cd-491a-b5ef-69014f3adc2c
# ╟─85e162c0-0823-4e09-8973-2913723523a3
# ╠═3c37d441-258d-45b6-9c1f-3fa3182c6b4d
# ╠═95ae1129-be30-436c-83c0-f629f2a8e01e
# ╠═126d47bb-4b25-4f6f-8e0d-9b9e842b860f
# ╟─f9f86a7f-ee78-4ff8-b19d-0c20808f15a7
# ╟─04c5eed0-139f-48f6-9aa7-87d3662efed6
# ╠═3873b1fb-04e8-4785-a6e6-ed98e2abd854
# ╟─d76c572d-fd82-42c1-8b44-535a00f99631
# ╟─b302439f-0610-44b9-bc59-166614f2d6bc
# ╟─9cbc0719-f26c-49d1-a1a4-cb6c74b02fa1
# ╠═a495f82c-d16b-496d-ae0c-f7dd8b800956
# ╠═6dfc90c5-bdac-4bd6-84cf-b07ee25a6552
# ╠═c3bf27a8-3e71-4660-8b04-0698fbe3e9e3
# ╟─72acd932-2b93-443f-bdf7-cbad7a3ff918
# ╟─8b405dfa-c490-4904-b871-3770962e8379
# ╟─e6a90754-f42a-404c-beda-81bd1cd4f0ba
# ╟─806041bc-4036-4dc8-8448-62e7dd4dbd5f
# ╠═3311c50e-6ec6-4d5b-b1d5-5824162b6b92
# ╟─a85e1133-aaaf-4a28-9d5e-43c3cfbb61b8
# ╠═0e8c4854-abec-4840-b82c-6520131cc879
# ╟─eb67b4d0-7abe-48ed-ae89-73efb68f3ab5
# ╟─63cd0b36-b5f8-4697-b3e1-f46cfcd8febf
# ╠═d124eaa6-dd96-40ba-9bd7-bed1d46001d7
# ╟─edaf1146-a5b7-4bd5-8e52-40b2d13871d3
# ╠═e93ad641-a57c-4d08-a2cf-a894d5e52359
# ╠═b87e6e67-349b-47cf-be0f-acf672052a92
# ╟─eebeb010-36b5-48b3-b1b4-33c8c141f93b
# ╠═3d29f079-56d7-41c7-b06d-ad50fb1a2d7d
# ╠═d185ed30-bca1-4d09-bf35-40de149a2753
# ╠═7e70b5d5-d49b-45d1-9f36-5f4d1cec8460
# ╟─bb1cf59c-0e4d-45e6-a4a4-5cdb975d426f
# ╟─16d31ed5-d5c0-40ff-b8d0-c18f255830b8
# ╠═555df51b-8e79-43b3-8881-979e85e2f796
# ╟─e42c8268-3a27-41cb-935e-d2172c0cb1ed
# ╠═edb6957f-db0d-4b0d-825c-a19715358bfa
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
