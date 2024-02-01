using NewickTree
using Plots
direction = "LR"


"""Find children of a node in a list of source->target pairs."""
function kids(nd, pairings)
	map(filter(pr -> pr[1] == nd, pairings)) do pr
		pr[2]
	end
end


"""Extract list of unique nodes from a list of source->target pairs."""
function nodes(pairings)
	left = map(pr -> pr[1], pairings)
	right = map(pr -> pr[2], pairings)
	vcat(left, right) |> unique
end

"""Find root of a rooted tree expressed as source->target pairs."""
function root(pairings)
	right = map(pr -> pr[2], pairings)
	filter(nodes(pairings)) do nd
		! (nd in right)
	end[1]
end


"""Extract source->target pairs from a Mermaid diagram"""
function mermaidpairs(txt)
	pairlines = filter(split(txt, "\n")) do ln
		contains(ln, "-->")
	end
	[split(ln, " --> ") for ln in pairlines]
end

"""Find all root nodes in a graph expressed as src -> target pairs.
"""
function rootnodes(pairings)
	right = map(pr -> pr[2], pairings)
	filter(nodes(pairings)) do nd
		! (nd in right)
	end
end

languages = """
flowchart $(direction)


pie --> oldenglish
oldenglish --> middleenglish
middleenglish --> modernenglish
modernenglish --> americanenglish
modernenglish --> britishenglish


pie --> protogermanic
protogermanic --> german
protogermanic --> dutch
protogermanic --> danish

pie --> latin

latin --> oldfrench
oldfrench --> french
latin --> spanish
latin --> portuguese

turkish

arabic --> msa

sumerian

"""


"""Recursively compose elements of a Newick format tree from a rooted tree represented as src-> target pairs."""
function newicktree(pairings, currentnode = nothing, cattable = [], sibling = false)
    @info("cattable: $(cattable)")
    nd = isnothing(currentnode) ? root(pairings) : currentnode
    if isnothing(currentnode)
        @info("Starting from root $(nd)")
    end
    @info("Pushing $(nd): sibling? $(sibling)")
    push!(cattable, nd)

    kidnodes = kids(nd, pairings)	
	if isempty(kidnodes)
	else
        @info("-- Has children so pushing right paren")
		push!(cattable, ")")
		for (i, kid) in enumerate(kidnodes)
            @info("child $(i): $(kid)")
			
			newicktree(pairings, kid, cattable, i < length(kidnodes))
		end
        @info("-- Closing node $(nd) with left paren")
		push!(cattable, "(")
	end

    @info("Node $(nd): sibling? $(sibling)")
    if sibling 
        push!(cattable, ",")
    end

	cattable
end



"""Represent a Mermaid flow chart as a Newick tree."""
function newick(txt)
	(mermaidpairs(txt) |> newicktree |> reverse |> join) * ";"
end

"""Represent a Mermaid flow chart as a Newick tree."""
function newick(txt)
	(mermaidpairs(txt) |> newicktree |> reverse |> join) * ";"
end

tree = newick(languages)
println(tree )

mermaidpairs(languages) |> rootnodes

nw = readnw(tree)
plot(nw)



