heads([],[]).
heads([[X|_]|L], [X|M]) :- heads(L,M).

tails([],[]).
tails([[_|Y]|L], [Y|M]) :- tails(L,M).

transpose([[]|L],[[]]).