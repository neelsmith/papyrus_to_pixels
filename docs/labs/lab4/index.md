---
title: "Lab 4: comparing English translations of the Bible"
layout: page
nav_order: 4
parent: "Labs"
---

# Comparing English translations of the Bible

In [lab 3](../lab3/), we looked at *aligned sequences* of data. As we discussed in class, this corresponds very closely to the traditional approach to textual criticism aimed at reconstructing a kind of evolutionary tree (or *stemma*) for multiple versions of a text. In this lab, we address a different kind of data set: a group of translations into English of the same text. The translators' goals were certainly *not* to reproduce exactly an earlier translator's text; aligning the tokens in different translations in the order in which they occur is not going to be an effective model to understand their relations.

On the other hand, translations certainly could be influenced by or draw on earlier translations (intentionally or not). To look at how different translations are related, we will need a different data model

## Data model

We will use a different model of texts to compare translations. We'll begin by looking at the vocabulary sets used in each translation (its *lexicon*). This model is sometimes called the "Bag O' Words" model, because it reduces a text to a list ("bag") of unique vocabulary items.

### Ways this model fails

- The bag of words model takes no account of word order.
- The model we are following takes no account of word frequency, only presence of a token in the source text.

## Assignment 

You assignment will be to develop a function that produces a vocabulary list -- a list of tokens -- for a given input text.  You will need to decide what constitutes a meaningful token, and make sure that your function implements your decisions. For example, do you want your vocabulary list to be case sensitive or not? Do you want to include non-alphabetic tokens like numbers of punctuation symbols?  

In this assignment, we'll practice a slightly different development strategy. You'll work on testing and perfecting your function using only a small selection of test data. When you submit your tokenizing function, we'll then plug it into a larger notebook that aligns and tests numerous English translations of the Bible.


## Requirements

A template Julia notebook is available in two formats:

- as a web page (HTML file)
- as a Pluto notebook (`.jl` filename)

For this assignment:

- Complete the template notebook.
- Save your completed notebook using the “Notebook file” option.
- On your computer, find the file you saved, and name it {LASTNAME}-lab4.jl, replacing {LASTNAME} with your last name.
- Add the correctly named file to your personal folder on the course Google drive.
- Ensure that every member of your team successfully completes the steps to submit a notebook. The first part of your notebooks should be identical: only the final sections “Next steps” and “Reflection” should differ (although you’re free to discuss this with your teammates and share ideas).
