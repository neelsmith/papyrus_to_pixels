### A Pluto.jl notebook ###
# v0.19.37

using Markdown
using InteractiveUtils

# ╔═╡ 1d887eb0-c4fd-11ee-077d-1f307b778458
md"""# Julia dictionaries"""

# ╔═╡ 282e2bf3-23d9-4585-abee-c2f1c4482723
md"""In our second lab, we'll make use of a new Julia structure, called a *dictionary*. Dictionaries are designed to be very efficient, even for massive data sets. 

A dictionary has two parts: a set of keys, and a corresponding value for each key. Unlike Vectors, dictionaries have no order: instead, you use a key to look up a value.

The keys must be unique; multiple keys could have the same value. If we made a dictionary with names of students in our class as the unique keys, and their group number for the first lab as the value, students in the same group would show the same group number (value) when you looked up the value for their names.



"""

# ╔═╡ 5a3b4194-2352-4d66-ad0b-c32a77a35a73
md"""## Creating a dictionary"""

# ╔═╡ 2ac5b84f-969a-486c-bf1d-bfeca4d76825
md"""
We'll illustrate dictionaries with a simple example.  If we're working with digital dates that refer to months numerically, we could use a dictionary to store a label for each month. The numbers (integers, in this case) will be the keys; the month names (strings) will be the values.

"""

# ╔═╡ 84edd64e-182d-44a2-8be4-f04731d2d733
md"""
The following cell illustrates one way to create a dictionary:
"""

# ╔═╡ 73a38217-752b-4eb3-9915-98f062680a11
monthnames = Dict(
	[
		1 => "January",
		2 => "February",
		3 => "March",
		4 => "April",
		5 => "May",
		6 => "June",
		7 => "July",
		8 => "August",
		9 => "September",
		10 => "October",
		11 => "November",
		12 => "December"
	
	]
	
)

# ╔═╡ e4ffd518-f657-4ca9-b460-200d5304cfe6
md"""I've spread out the code with plenty of white space to make it legible, but you can see that we have:

1. assigned a value to `monthname`
2. created the value by calling a function `Dict`. (Notice that it's followed immediately by parentheses. `Dict` is actually the name of the dictionary type: when we use the name of a type to create an object of that type, it's called a *constructor*.)
3. We've passed one parameter to `Dict`: it's a vector with 12 items in it. (Notice that the array is listed between square brackets, with item separated by a comma.)
4. The elements of the vector are `Pair`s.  In Julia's syntax, you can create a pair using the `=>` operator (which you can enter on your keyboard by typing an equals sign followed by a greater than sign).

"""

# ╔═╡ a62ea98a-5170-4903-a1cb-7fc3bbe6fb1d
md"""You can use the familiar `length` function to find out how many pairs are in a dictionary."""

# ╔═╡ 3ae8c6ad-e634-494d-a6c3-ac79120f8eec
length(monthnames)

# ╔═╡ e404a912-7946-49bb-833a-f933a9b2e85e
md"""You can also add values to a Dictionary using the familiar assignment operator `=`. The next cells create an empty dictionary, then add entries to it.
"""

# ╔═╡ 0b2f7db8-c809-486f-bc4a-7d7b75091bbd
groups = Dict()

# ╔═╡ 48ca204f-82e2-4531-b2ab-eb0aad9fd396
groups["Luke"] = 5

# ╔═╡ 4fc1f022-d674-4e4a-9787-7ddd09853f5f
groups["Connor"] = 5

# ╔═╡ 357f0daf-e85c-43f2-af13-fcf834dc0f00
md"""We now have 2 entries in our dictionary:"""

# ╔═╡ 6e2482fa-9231-464a-b2ad-c7d484e0f4a7
length(groups)

# ╔═╡ 7d8b4378-aab9-431c-9643-84dae8dccfa3
md"""## Looking up values"""

# ╔═╡ e6bad2e2-abd8-47a3-8a89-8b4625425926
md"""The syntax to look up a value for a key uses square brackets, like indexing a Vector with a number, but you use the key value instead:"""

# ╔═╡ 609f051c-71e0-47bd-96c5-181e5caa3dc4
monthnames[10]

# ╔═╡ 41f93212-8789-40cd-9343-3747d0465a32
md"""If you use an invalid key, Julia will be very unhappy."""

# ╔═╡ e4909ef6-09c3-41ea-aace-b9aec2066d85
monthnames[13]

# ╔═╡ 796b4308-d563-4fae-85d9-162f2fff8e08
md"""You can use a boolean function `haskey` to test if a key exists."""

# ╔═╡ 92c58ce2-fb88-47c7-80ae-b2e0ab3292bc
haskey(monthnames, 13)

# ╔═╡ 74118b39-14a1-4ac1-8a1d-dcb899db7dfc
md"""This makes it easy to avoid generating an error.  Try to interpret what the following function does.
"""

# ╔═╡ c2a17446-024a-4053-a003-bdf2edf7c372
function safelookup(dict, key)
	if haskey(dict, key)
		dict[key]
	else
		nothing
	end
end

# ╔═╡ 127f7a57-1e43-421e-8c07-05ad8035e1d7
safelookup(monthnames, 13)

# ╔═╡ a712c162-9594-4e0e-897b-9038759b18b8
safelookup(monthnames, 12)

# ╔═╡ c02afc9f-6b7f-41ba-b551-955ff6e2069d
md"""## Iterating through dictionaries"""

# ╔═╡ 18276c97-c4b2-490c-8ba6-aa28145dc908
md"""You can use the function  `keys` in a `for` loop to cycle through all the keys in a dictionary. Let's imagine we want to create a new dictionary that has numeric keys 1-12, and has abbreviated month names for its values.

The following cell creates an empty Dictionary, then loops through all the keys in our `monthnames` dictionary, and looks up the corresponding value.  It uses vector indexing to select the first three characters of the name, and assigns that short three-character name to the same key value in our new dictionary.
"""

# ╔═╡ 58a073c8-dea9-4ad0-8de4-e6048bcc322c
begin
	abbreviations = Dict()
	for key in keys(monthnames)
		name =  monthnames[key]
		abbreviations[key] = name[1:3]
	end
	abbreviations
 
end

# ╔═╡ f46da516-bd41-4cd5-b1b9-091bb4f18d05
abbreviations[10]

# ╔═╡ 070eb584-84b1-4723-93d2-a4f1e470b3f8
md"""## Challenge your brain"""

# ╔═╡ f73a5dc9-af93-4e9f-a0b1-924fecd6e332
md"""!!! note "Brain teaser"

    - Can you think of a way to add periods to those abbreviations, so that instead of `Oct` you would get `Oct.` for `abbreviations[10]`?
    - Can you think of a way to avoid adding periods to names that are shorter than four characters, so that you get `May` for `abbreviations[5]` and not `May.` ?


"""

# ╔═╡ Cell order:
# ╟─1d887eb0-c4fd-11ee-077d-1f307b778458
# ╟─282e2bf3-23d9-4585-abee-c2f1c4482723
# ╟─5a3b4194-2352-4d66-ad0b-c32a77a35a73
# ╟─2ac5b84f-969a-486c-bf1d-bfeca4d76825
# ╟─84edd64e-182d-44a2-8be4-f04731d2d733
# ╠═73a38217-752b-4eb3-9915-98f062680a11
# ╟─e4ffd518-f657-4ca9-b460-200d5304cfe6
# ╟─a62ea98a-5170-4903-a1cb-7fc3bbe6fb1d
# ╠═3ae8c6ad-e634-494d-a6c3-ac79120f8eec
# ╟─e404a912-7946-49bb-833a-f933a9b2e85e
# ╠═0b2f7db8-c809-486f-bc4a-7d7b75091bbd
# ╠═48ca204f-82e2-4531-b2ab-eb0aad9fd396
# ╠═4fc1f022-d674-4e4a-9787-7ddd09853f5f
# ╟─357f0daf-e85c-43f2-af13-fcf834dc0f00
# ╠═6e2482fa-9231-464a-b2ad-c7d484e0f4a7
# ╟─7d8b4378-aab9-431c-9643-84dae8dccfa3
# ╟─e6bad2e2-abd8-47a3-8a89-8b4625425926
# ╠═609f051c-71e0-47bd-96c5-181e5caa3dc4
# ╟─41f93212-8789-40cd-9343-3747d0465a32
# ╠═e4909ef6-09c3-41ea-aace-b9aec2066d85
# ╟─796b4308-d563-4fae-85d9-162f2fff8e08
# ╠═92c58ce2-fb88-47c7-80ae-b2e0ab3292bc
# ╟─74118b39-14a1-4ac1-8a1d-dcb899db7dfc
# ╠═c2a17446-024a-4053-a003-bdf2edf7c372
# ╠═127f7a57-1e43-421e-8c07-05ad8035e1d7
# ╠═a712c162-9594-4e0e-897b-9038759b18b8
# ╟─c02afc9f-6b7f-41ba-b551-955ff6e2069d
# ╟─18276c97-c4b2-490c-8ba6-aa28145dc908
# ╠═58a073c8-dea9-4ad0-8de4-e6048bcc322c
# ╠═f46da516-bd41-4cd5-b1b9-091bb4f18d05
# ╟─070eb584-84b1-4723-93d2-a4f1e470b3f8
# ╟─f73a5dc9-af93-4e9f-a0b1-924fecd6e332
