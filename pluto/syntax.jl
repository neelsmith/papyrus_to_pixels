### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 284fc844-7892-42d4-a095-da4ac85f513f
begin
	using PlutoUI
end

# ╔═╡ 61fb6079-7a50-4dea-be6a-b80c6ad479e4
using StatsBase

# ╔═╡ c63cfc07-44e5-4acb-80ed-0a9c160e229b
TableOfContents()

# ╔═╡ 38a41cc0-3375-4e48-b6c2-e577754e4f83
md"""*Last modified: Feb. 27, 2024*"""

# ╔═╡ c409a8f4-d56f-11ee-3109-9b0ecd0a1750
md"""# Julia syntax cheat sheet"""

# ╔═╡ ca94a0c6-36ff-42d9-9fd4-0e790616bc4c
md"""> **BIO 199/CLAS 199**: summary of main syntactic points you need for working in Julia using Pluto notebooks
"""

# ╔═╡ 61e27257-d97b-4323-8737-78cd21616e56
md"""## Objects and variables"""

# ╔═╡ ff9cc89e-9f5a-4034-b6ab-6a7522921631
md"""Objects have a *type* and a *value*. Pluto displays the value of the expression in a cell immediately above it; use the `typeof` function to find the type of an object."""

# ╔═╡ ef348da3-7454-41be-b2c3-da1c6f5e8108
"hello"

# ╔═╡ 03e982e4-1487-4046-9cfa-91637f1dbd6d
typeof("hello")

# ╔═╡ 98c3164b-3427-4c6d-b954-8ac03c65ed1b
md"""Use `=` (that is, a single equals sign) to *assign* and object to a name."""

# ╔═╡ 793d68dd-b09d-4906-a537-a8c7c8a14f6d
greeting = "hello"

# ╔═╡ b62c97d6-1256-41de-a44b-dc46299a5c10
md"""You've effectively added a new noun to the Julia language: now you can use the name `greeting` anywhere you want to refer to the String value "hello"."""

# ╔═╡ 393ec9b9-71a2-4c83-9b94-d88660523bbd
greeting

# ╔═╡ a8f32be8-6483-4734-9226-bfcc033ac270
md"""## Vectors"""

# ╔═╡ 8db131ab-d500-4f74-b1fa-c8ffb7c58538
md"""Vectors are lists (an ordered sequence) of objects, usually all of the same type.

You can create a Vector by listing its values, separated by commas, between square brackets.
"""

# ╔═╡ becc1167-8dd1-43a6-9357-ba2928d9130b
multiplechoice = ['A', 'B', 'C']

# ╔═╡ 200428a0-e3ce-4bda-8e8a-3ebf4d8e2d62
md"""Use square brackets with a numeric index to refer to individual items in a Vector."""

# ╔═╡ 17138381-6997-41e7-b78b-75df08fbdc9a
multiplechoice[2]

# ╔═╡ 88f2a75f-4c12-4f2e-8828-2b715e52fda6
md"""Strings in Julia are actually Vectors of characters, so you can treat a String like a Vector."""

# ╔═╡ abed35cb-ebab-4c25-bc69-8d13959e4d8c
greeting[1]

# ╔═╡ 80db1044-da4a-44bd-aae8-64d01e5ecd3d
md"""### Some important generic functions for working with Vectors"""

# ╔═╡ d3f50034-1d32-4dfc-b720-aab87db28324
md"""Two things you often want to know about Vectors are its size (length), and what distinct values it contains (unique).
"""

# ╔═╡ 6432db76-ca4b-4dc2-a721-446b68ff245a
length(multiplechoice)

# ╔═╡ accdbba5-80a5-40d3-9855-5bc40df1731b
unique([1,1,2,1,2,2,3,1,2,3,4,1,2,5,6,7,3,5])

# ╔═╡ d4fba2ed-7b4b-4331-b1ac-7a17e69c97d0
md"""Two important operations on Vectors are *filtering* and *mapping*.

*Filtering* creates a new Vector by selecting a subset of elements from the original Vector.  

*Mapping* creates a new Vector by transforming every element in the original Vector.

"""


# ╔═╡ 4ab089a3-5319-448c-89d7-d561f6aa5554
md"""### Filtering: syntax"""

# ╔═╡ db13b392-a97a-4a9f-978e-7765fda7f89d
md"""
One syntax for expressing a filter in Julia looks like the following cell. Use one *parameter*, a Vector, with the function `filter`, then define the beginning and end of the filter expression with the key words `do` and `end`. (Pluto will highlight these to show that they are key words.) After the keyword `do`, give a name for a local variable that will be used to stand for every individual element of the Vector. You can make up any name you like: here I chose `wrd` to help me remember that I have a Vector of Strings that represent words.

The body of the filter statement produces a Boolean value (`true` or `false`).
"""

# ╔═╡ 68562f72-6310-498b-8821-58adb1858557
wordlist = ["Now", "is", "the", "time", "for", "all", "good", "people", "to", "come", "to", "the", "aid", "of", "their", "country"]

# ╔═╡ 4c0dc01f-4788-4221-80bc-1b452b2df66f
filteredwords = filter(wordlist) do wrd
	length(wrd) > 4
end

# ╔═╡ 386c1402-ee65-4798-a366-4e622c9e1c68
md"""Notice that the variable `wrd` *only* exists within the filter expression."""

# ╔═╡ 50634a47-99ae-4cfd-94df-1a9076419f85
@isdefined(wrd)

# ╔═╡ 86e238ea-6f87-42f3-b0f5-51132eb2b9e9
md"""### Mapping: syntax"""

# ╔═╡ fb5438f5-9af7-4da5-b60f-0575943623c2
md"""The syntax for the `map` function is similar. Supply a Vector as the parameter, then define a body with the `do` and `end` keywords, and follow the `do` keyword with a name for a variable that will stand for every item in the original list. The body of the map function defines a new value for the corresponding item in the new Vector.
"""

# ╔═╡ 5870d613-25ff-4008-977a-74ebca549447
mappedwords = map(wordlist) do wrd
	length(wrd)
end


# ╔═╡ 46be05f3-cf16-4801-94f7-3e7a53bbe313
md"""### Comparison of mapping and filtering"""

# ╔═╡ 440e399b-977c-4234-91ba-a2e45bd5e7d1
md"""
Filtering creates a new Vector that has as few as 0 elements and as many as the original list. *All* elements in the new Vector are also present in the original Vector.
"""

# ╔═╡ a2af82bd-2230-4f44-bca4-f229bffdfc24
very_very_long = filter(wordlist) do w
	length(w) > 100
end

# ╔═╡ 4e3cfc89-3aa8-45af-b5bd-f3670485fa9a
length(very_very_long)

# ╔═╡ ab895618-86f1-4a13-9bc5-32d8f9e0782a
could_be_very_short = filter(wordlist) do w
	length(w) > 0
end

# ╔═╡ 4ffea1d4-b5a3-4278-b56a-7a9f7996c012
length(could_be_very_short) == length(wordlist)

# ╔═╡ 4ab6d9d6-6e8f-4655-b50f-62465777a958
md"""Mapping creates a new list with exactly the same numbers of elements as the first list. The values of the new list could be anything you choose to create.
"""

# ╔═╡ 919a1ac5-13a8-4a84-9ede-1e83185b72c7
length(mappedwords) == length(wordlist)

# ╔═╡ f2f034d1-08b7-4ccc-9b6c-f456e6d8ad05
wordlist[1]

# ╔═╡ c959cb31-86d2-4b14-a63b-61fc3f2eb6e7
mappedwords[1]

# ╔═╡ 1bbf5d83-6aa7-419a-aa07-958d84b03585
md"""## Dictionaries"""

# ╔═╡ 3a31a3b3-5759-4c3f-94b2-e3e1f9feabdb
md"""Dictionaries relate two pieces of information, a *key* and a *value*. You can easily and efficiently look up a value using a key.

The notation for referring to individual values in a dictionary uses square brackets, but instead of using integer values (as with Vectors), you supply a key.
"""

# ╔═╡ a85f35ac-7969-42fc-8f2a-4d1a4b41ba66
md"""One syntax for defining a dictionary is to provide a Vector of pairs to the `Dict` constructor, using `=>` to identify keys (on the left) and values (on the right). You could create a dictionary of recent World Series winnners like this:"""

# ╔═╡ beacc67d-d058-4e00-934d-674fedff735a
series_winners = Dict(
	[
		2023 => "Rangers",
		2022 => "Astros",
		2021 => "Braves",
		2020 => "Dodgers",
		2019 => "Nationals",
		2018 => "Red Sox",
		2017 => "Astros",
		2017 => "Cubs",
		2015 => "Royals",
		2014 => "Giants",
		2013 => "Red Sox"
	]
	
)

# ╔═╡ 422d9c27-9060-491c-97c1-d02d457251e9
series_winners[2013]

# ╔═╡ 01370978-9973-4c2c-aac3-297523a7de7f
md"""### Using dictionaries to keep track of frequencies"""

# ╔═╡ 33442ed0-ce58-4b24-8189-c9526dd8fd3b
md"""
One frequent pattern where you might use a dictionary is to count the frequency of items in a vector.  The Julia `StatsBase` package has a function `countmap` that will create a dictionary of frequencies for you.
"""

# ╔═╡ c3c37373-0d36-436e-a62e-aa48a974334f
wordfreqs = countmap(wordlist)

# ╔═╡ 7c942733-bff4-4d9f-92e6-f63ca9d480c9
wordfreqs["the"]

# ╔═╡ 530685b4-b0d0-422d-80f7-91703383b55b
md"""## Defining your own functions"""

# ╔═╡ 46eacda3-f1a9-4490-9283-2dea8a6c7307
md"""Define your own functions with this syntax:

- start with the keyword `function`, then a name you choose for the function, and a list in parentheses of any parameters the function requires. 
- with the function's body, the last line is the value that the function *returns*
"""

# ╔═╡ 15b81b2a-1a17-4daf-a1de-cc2d2c22e5ea
md"""A function with no parameters that always returns the same value:"""

# ╔═╡ 2a6e1cd3-25f8-4a1e-9997-fe312410f2c7
function greet()
	"Hi!"
end

# ╔═╡ efc97d5f-d4c2-47bf-8427-8cdc24080e50
md"""A function with one parameter that returns a String value:"""

# ╔═╡ 1477173b-1e9f-4010-897d-764b6deb33c4
function shout(str)
	uppercase(str)
end

# ╔═╡ be5447a9-e2d7-4d5d-8bde-f463ce4d4a74
shout(greeting)

# ╔═╡ 93fdc369-56f9-427b-8ef0-9be2c6d7a1b6
md"""A function with two parameters that returns a String value:"""

# ╔═╡ 868a7560-8bfd-40c3-bcd8-1670917365be
"""Given a string `str` and an integer `n`,
create a new string that appends `n` exclamation points to the original string.
"""
function exclaim(str, n)
	string(str, repeat("!", n))
end

# ╔═╡ 85878328-ffe4-47ea-8d83-58a1f58f5172
exclaim(greeting, 3)

# ╔═╡ 301cc403-e05b-4108-8937-81416ae52831
"""True if string `str` is shorter than `n` characters long."""
function isshort(str, n)
	length(str) < n
end

# ╔═╡ bd2caf4d-a970-40ed-82e4-56e503d697bb
isshort(greeting, 3)

# ╔═╡ 809ac5ca-692e-4c6d-87a9-d5bb153c9b95
isshort(greeting, 6)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
PlutoUI = "~0.7.57"
StatsBase = "~0.34.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.1"
manifest_format = "2.0"
project_hash = "9db86de9e98944f535c1ef005facf3e101d964c3"

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
version = "0.3.23+4"

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
git-tree-sha1 = "a6783c887ca59ce7e97ed630b74ca1f10aefb74d"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.57"

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
# ╟─284fc844-7892-42d4-a095-da4ac85f513f
# ╟─c63cfc07-44e5-4acb-80ed-0a9c160e229b
# ╟─38a41cc0-3375-4e48-b6c2-e577754e4f83
# ╟─c409a8f4-d56f-11ee-3109-9b0ecd0a1750
# ╟─ca94a0c6-36ff-42d9-9fd4-0e790616bc4c
# ╟─61e27257-d97b-4323-8737-78cd21616e56
# ╟─ff9cc89e-9f5a-4034-b6ab-6a7522921631
# ╠═ef348da3-7454-41be-b2c3-da1c6f5e8108
# ╠═03e982e4-1487-4046-9cfa-91637f1dbd6d
# ╟─98c3164b-3427-4c6d-b954-8ac03c65ed1b
# ╠═793d68dd-b09d-4906-a537-a8c7c8a14f6d
# ╟─b62c97d6-1256-41de-a44b-dc46299a5c10
# ╠═393ec9b9-71a2-4c83-9b94-d88660523bbd
# ╟─a8f32be8-6483-4734-9226-bfcc033ac270
# ╟─8db131ab-d500-4f74-b1fa-c8ffb7c58538
# ╠═becc1167-8dd1-43a6-9357-ba2928d9130b
# ╟─200428a0-e3ce-4bda-8e8a-3ebf4d8e2d62
# ╠═17138381-6997-41e7-b78b-75df08fbdc9a
# ╟─88f2a75f-4c12-4f2e-8828-2b715e52fda6
# ╠═abed35cb-ebab-4c25-bc69-8d13959e4d8c
# ╟─80db1044-da4a-44bd-aae8-64d01e5ecd3d
# ╟─d3f50034-1d32-4dfc-b720-aab87db28324
# ╠═6432db76-ca4b-4dc2-a721-446b68ff245a
# ╠═accdbba5-80a5-40d3-9855-5bc40df1731b
# ╟─d4fba2ed-7b4b-4331-b1ac-7a17e69c97d0
# ╟─4ab089a3-5319-448c-89d7-d561f6aa5554
# ╟─db13b392-a97a-4a9f-978e-7765fda7f89d
# ╠═68562f72-6310-498b-8821-58adb1858557
# ╠═4c0dc01f-4788-4221-80bc-1b452b2df66f
# ╟─386c1402-ee65-4798-a366-4e622c9e1c68
# ╠═50634a47-99ae-4cfd-94df-1a9076419f85
# ╟─86e238ea-6f87-42f3-b0f5-51132eb2b9e9
# ╟─fb5438f5-9af7-4da5-b60f-0575943623c2
# ╠═5870d613-25ff-4008-977a-74ebca549447
# ╟─46be05f3-cf16-4801-94f7-3e7a53bbe313
# ╟─440e399b-977c-4234-91ba-a2e45bd5e7d1
# ╠═a2af82bd-2230-4f44-bca4-f229bffdfc24
# ╠═4e3cfc89-3aa8-45af-b5bd-f3670485fa9a
# ╠═ab895618-86f1-4a13-9bc5-32d8f9e0782a
# ╠═4ffea1d4-b5a3-4278-b56a-7a9f7996c012
# ╟─4ab6d9d6-6e8f-4655-b50f-62465777a958
# ╠═919a1ac5-13a8-4a84-9ede-1e83185b72c7
# ╠═f2f034d1-08b7-4ccc-9b6c-f456e6d8ad05
# ╠═c959cb31-86d2-4b14-a63b-61fc3f2eb6e7
# ╟─1bbf5d83-6aa7-419a-aa07-958d84b03585
# ╟─3a31a3b3-5759-4c3f-94b2-e3e1f9feabdb
# ╟─a85f35ac-7969-42fc-8f2a-4d1a4b41ba66
# ╠═beacc67d-d058-4e00-934d-674fedff735a
# ╠═422d9c27-9060-491c-97c1-d02d457251e9
# ╟─01370978-9973-4c2c-aac3-297523a7de7f
# ╟─33442ed0-ce58-4b24-8189-c9526dd8fd3b
# ╠═61fb6079-7a50-4dea-be6a-b80c6ad479e4
# ╠═c3c37373-0d36-436e-a62e-aa48a974334f
# ╠═7c942733-bff4-4d9f-92e6-f63ca9d480c9
# ╟─530685b4-b0d0-422d-80f7-91703383b55b
# ╟─46eacda3-f1a9-4490-9283-2dea8a6c7307
# ╟─15b81b2a-1a17-4daf-a1de-cc2d2c22e5ea
# ╠═2a6e1cd3-25f8-4a1e-9997-fe312410f2c7
# ╟─efc97d5f-d4c2-47bf-8427-8cdc24080e50
# ╠═1477173b-1e9f-4010-897d-764b6deb33c4
# ╠═be5447a9-e2d7-4d5d-8bde-f463ce4d4a74
# ╟─93fdc369-56f9-427b-8ef0-9be2c6d7a1b6
# ╠═868a7560-8bfd-40c3-bcd8-1670917365be
# ╠═85878328-ffe4-47ea-8d83-58a1f58f5172
# ╠═301cc403-e05b-4108-8937-81416ae52831
# ╠═bd2caf4d-a970-40ed-82e4-56e503d697bb
# ╠═809ac5ca-692e-4c6d-87a9-d5bb153c9b95
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
