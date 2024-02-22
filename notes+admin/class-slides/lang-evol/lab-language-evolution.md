# Agenda

1. Data structures
2. Plain-text data formats
3. Evolution of language
4. Interpreting evolutionary data as a tree

---

# (1) Data structures

---

## Structures you have seen

List (Julia `Vector`):

- ordered series of items, usually all same type
- can look up by index number
- functions let us ask questions like "how many?", "what values are included?", "how frequently do values appear?"

---

## Generic operations with Vectors

Create a new Vector by *filtering*:

- select zero or more items from a Vector
- length of new Vector will therefore be in the range 0 to the length of the original
- all items in new Vector appear in original

Create a new Vector by *mapping*:

- transform each item in a Vector
- length of new Vector will therefore be equal to length of original Vector
- items in new Vector may be anything your mapping creates


---

## Structures you have seen

Dictionary (Julia `Dict` or `OrderedDict`)

- pairs of keys -> values
- can look up by key value
- could extract keys and values as separate, parallel Vectors

---

## A new structure: Graph

- items in a Graph are *nodes*
- relation of two nodes is an *edge*
- edges may be *directed* or *undirected*
- ultimately generic model!


---

## Examples

- you could think of a dictionary as a graph!
- social network: `person -friend of-> person`
- genealogy: `child -> parent` (or `parent -> child` ?)


---

## A special graph: trees

- have one *root*
- except for root, all nodes have one parent node



---




# (2) Plain-text data formats

- human-readable
- don't require special software
- good match to model of open scholarship

---


## Tables in plain-text format

- *rows* represent observations
- *columns* represent features
- need *two* special characters:
    1. row separator (usually new line)
    2. column separator (could be anything else)



---

## Example: parallel terms in multiple languages

Using `|` as column separator:

```

English|father|mother
French|père|mère
```


---


# (3) Evolution of language

---

## About this exercise

- a lab exercise: true solution is known, but we are testing it with real data

> How often can you get meaningful initial results with *limited data*, *simplistic models* and *no advanced training*?


---

## Similarities with linguistic and biological evolution

Historically observed:

- languages are always changing
- they *do* evolve into new languages

Hypothesized:

- do all languages descend from a common ancestor?


---

## Differences from biological evolution

- mechanism for introducing change?
- what guides selection?
- languages can borrow from or be directly influenced by other languages
- our "fossil record" (written text) is only 5,000 years old! 

(1-5 % of the time span of human language?)


---

## When are two languages different?

> *England and America are two countries separated by a common language.*
>
> attributed to George Bernard Shaw


- mutual intelligibility -> dialects of a single language
- all our examples are clearly distinct languages

---


## How should we compare languages?

- *syntax*
- *vocabulary*
- *external historical information*

---

## Syntax: how words are arranged

- English: *word order* determines function
- Latin: *word form* determines function

Two English sentences with different subject and object:

> Dog bites man.
>
> Man bites dog.

Two Latin sentences with same subject and object:

> Homo canem mordet.
>
> Canem homo mordet.

---

> ## We're ignoring syntax!

---

## Vocabulary

*Cognates*: words in two languages that have the same origin (~ *homology*)

But pronounciation evolves! How do we identify cognates?



--- 

## How *not* to reconstruct word history

Cassiodorus (6th c. CE): guesses *barbarus* comes from *barba* ("beard") and *rus* ("countryside")

"Cling-clang etymology"

---


## Testing possible cognates

- similar meaning
- *systematic* correspondences in cognates of two languages
- change in pronounciation can be explained phonetically

---

## Phonetics

Simplistic model for our purposes:

- consonants only
- *where* the sound is made
- *manner* of producing the sound
- *vocalized* or not


---

### Where the sound is made

- *labial* (lips) (e.g., English `p`)
- *dental* (teeth) (e.g., English `t`)
- *palatal* (top of mouth) (e.g., English `k`)

![bg left  h:600](./imgs/ipa-articulation.png)

---

### Manner of producing sound

- *plosive*: a little explosion of air (e.g., English `t`)
- *fricative*: a steady stream of air (e.g., English `th`)


---

### Vocalized

- *voiced*: vocal cords make a sound (e.g., English `d`)
- *unvoiced*: they don't (e.g., English `t`)

---

### Summary example

English `t`: *unvoiced dental plosive*

---





## Understanding phonetic evolution

- not random
- not all aspects of speech changed simultaneously

E.g., plural of English "roof":

- roo*f*s: *unvoiced labial fricative* (attested 1600, OED)
- roo*v*es: *voiced labial fricative*

---

## External historical information

- We'll consider *after* we develop a first tree based on phonetics

---


## Using our Pluto notebook

1. Examine our at least 6 features in our data set
2. Include "brother" and "kangaroo" in your features: look at as many others (minimum 4 others) as you like
3. Group languages together based on observations
4. Can you interpret the results as an evolutionary tree?


---

## Compare results

Conclusions?

Further accounting for observations?

---

## Phonetic context

| English | Dutch | German | Reconstructed ancestor |
| --- | --- | --- | --- | 
| **c**ook | **k**ooken | **k**uchen | k[aou] |
| **ch**urch | **k**erk | **K**irche | k[ei] |


---


## False cognates: Turkish `baba`

![h:400](./imgs/baba.png)

---

## Explaining false cognates

- coincidence?
- ~ analogical evolution?? 
    
*Lallwörter*: Turkish *baba*, English *papa*, Aramaic *abba*


--- 

## "Missing" cognate: Spanish `hermano`

![h:400](./imgs/bubba.png)

--- 

## Explaining missing cognates

Meaning of words evolves, too!

*Generalization*

> Latin *germanus*: more specialized "full brother, brother by the same father"
>
> -> generalized in Spanish to "brother"

*Specialization*

> English *queen* 
> 
> - cognate with Greek *gunê* (γυνή), "woman"
> - reconstructed ancestor means "woman"

---

## Closing: a philosophical debate

- *diachronic reconstruction* 
- *synchronic system of correspondences*

---

