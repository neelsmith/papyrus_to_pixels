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

# ╔═╡ fb041168-bd60-11ee-129e-af955355f4ac
begin
	using PlutoUI, PlutoTeachingTools
	using Kroki

end

# ╔═╡ c9d97d70-e584-4724-bedb-673d2ca226a7
md"""# Draw tree structures using Mermaid plain-text syntax"""

# ╔═╡ 1023641e-fffb-4c1e-90e4-59a8abe96b22
md"""
!!! tip

    See documentation on the Mermaid syntax for [flow charts](htt ps://mermaid.js.org/syntax/flowchart.html) -- they work well for tree structures!
"""

# ╔═╡ 4179630e-c21d-48da-87de-e08532bbd244
md"""Choose a direction for your graph: this value will be interpolated into the cell below with mermaid description of a graph"""

# ╔═╡ a993cffb-57fb-4e43-8ec6-5baaccc147ca
html"""
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ 587b3fa7-dff9-4f84-9527-08e2c892e807
md"""> Utilities you don't need to look at"""

# ╔═╡ 2da281ee-ae30-4384-9b7a-3787dfa3a0bc
menu = [
	"BT" => "Bottom to top (BT)",
	"TB" => "Top to bottom (TB)"
	]

# ╔═╡ 425cc328-ec56-4015-980f-c9de9f994cd9
md"""*Direction*: $(@bind direction Select(menu))"""

# ╔═╡ 647edd56-faea-47ea-ba99-0efa58b4d237
direction

# ╔═╡ Cell order:
# ╠═fb041168-bd60-11ee-129e-af955355f4ac
# ╟─c9d97d70-e584-4724-bedb-673d2ca226a7
# ╟─1023641e-fffb-4c1e-90e4-59a8abe96b22
# ╟─4179630e-c21d-48da-87de-e08532bbd244
# ╟─425cc328-ec56-4015-980f-c9de9f994cd9
# ╠═647edd56-faea-47ea-ba99-0efa58b4d237
# ╟─a993cffb-57fb-4e43-8ec6-5baaccc147ca
# ╟─587b3fa7-dff9-4f84-9527-08e2c892e807
# ╠═2da281ee-ae30-4384-9b7a-3787dfa3a0bc
