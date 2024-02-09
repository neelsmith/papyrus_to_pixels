using BioSequences


using OrderedCollections
using StatsBase

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



dna_seq = dna"atgATTTTACCGCGACAATGATTATTTTCAACAAACCATAAGGATATTGGTACATTATATTTTATTTTTGGAGCATGATCAGGAATAGTAGGGACTTCACTAAGTATACTAATTCGAGCTGAATTGGGAAATCCTGGAGCATTAATTGGTGATGATCAAATTTATAATGTTATTGTAACTGCTCATGCATTTATTATGATTTTTTTTATAGTAATGCCTATTATAATTGGAGGATTTGGAAATTGATTAGTTCCTCTAATATTAGGGGCTCCTGATATAGCCTTTCCTCGAATAAATAATATAAGTTTTTGATTACTTCCTCCTTCACTAACACTTCTCTTAATGAGAAGAATAGTAGAAAGAGGAGCTGGTACCGGATGAACAGTTTACCCACCCCTCTCATCTGGTATTGCCCATGCCGGAGCCTCAGTTGATTTAGCTATTTTTAGTCTACATTTAGCAGGAGTATCTTCAATTTTAGGGGCTGTAAATTTTATTACAACAATTATCAATATACGATCAATTGGTATAACTTTTGATCGAATACCTTTATTTGTATGATCAGTAGGAATTACTGCTTTACTATTACTTTTATCATTACCAGTATTGGCTGGAGCTATCACAATATTATTAACAGATCGAAATTTAAATACTTCATTTTTTGACCCTGCAGGAGGAGGAGATCCTATTTTATACCAACATTTATTTTGATTTTTCGGTCACCCTGAAGTTTATATTTTAATTTTACCAGGATTTGGAATAATTTCTCATATTATTAGCCAAGAAAGAGGGAAAAAGGAAACCTTTGGTTCATTAGGAATAATTTATGCTATATTAGCTATTGGATTATTAGGATTTGTAGTCTGAGCTCACCATATATTTACAGTTGGAATAGATGTTGATACTCGAGCTTATTTTACTTCAGCTACAATAATTATTGCTGTCCCGACTGGAATTAAAATTTTTTCTTGATTAGCAACACTTCATGGAGCTCAAATATCTTATAGTCCTGCATTACTATGAGCTTTAGGATTTGTATTTTTATTCACCGTAGGTGGTCTAACTGGAGTAGTATTAGCTAATTCATCTATTGATATTATTCTTCACGATACATATTATGTTGTTGCCCATTTTCATTATGTGTTATCTATAGGAGCTGTATTTGCAATTATAGCTGGATTTATTCAATGATTCCCTTTATTTACAGGATTAAGAATAAATGATAACTTATTAAAAATTCAATTCATTATTATATTTATTGGGGTAAATTTAACATTTTTCCCTCAACATTTTTTAGGACTAAATGGTATACCACGACGATATTCAGATTATCCTGATGCATATACATCATGAAATATTGTTTCATCAATTGGTTCTACAATTTCTTTTATTGGAGTACTTTTATTAATTTATATTATTTGAGAAAGCTTTGTCTCTCAACGTTTAGTAATTTTCTCAAACCAAATATCAACTTCTATTGAATGATTTCAAAATTATCCTCCAGCTGAACATAGATATTCTGAACTACCGATACTATCTAAT"


dna_seq
aa_seq = translate(dna_seq)
codons = splitcodons(dna_seq)
codons |> length


function countcodons(aareading, codoncompare)
	aadict = Dict()
	for (i, aa) in enumerate(aareading)
        #@info("$(aa) at $(i)")
        
		if haskey(aadict, aa)
			push!(aadict[aa], codoncompare[i])
		else
			aadict[aa] = [codoncompare[i]]
		end
	end
	aa_unique = OrderedDict()
    for key in keys(aadict)
        aa_unique[key] = length(aadict[key])
    end
    sort(aa_unique, byvalue = true, rev = true)
	
end

encodings = countcodons(aa_seq, codons)
xs = keys(encodings) |> collect .|> string
ys = values(encodings) |> collect


using Plots
plotly()
bar(xs,ys, xticks = xs)