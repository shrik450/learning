# Chapter 4 Highlights

## Storage

I never thought I'd arrive at a fundamental concept of computation while literally in a shower thinking about the subexpression problem in Regen, but here we are...

## Pushdown Automata

An FSA with a stack memory is a PDA.

## PDARule

A PDARule is a FARule +

1. A character to pop off the stack;
2. A sequence of characters to push onto the stack after the character in Rule 1 has been popped.

Note that this means that *every* rule must pop something from the stack. To work with an empty stack in a rule, the conventional character $ is used. Any rule that pops a $ must also replace it.

## Determinsim in PDAs

PDAs can be determinstic even with free moves so long as there is no other rule for the same state and character on top of the stack state. Also, DPAs generally do not need to specify rules for every state, input and stack combination, and by convention it is assumed that an unspecified combination leads to a stuck state.

