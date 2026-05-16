heads([],[]).
heads([[X|_]|L], [X|M]) :- heads(L,M).

tails([],[]).
tails([[_|Y]|L], [Y|M]) :- tails(L,M).

transpose([[]|_],[[]]).

args(X) :- current_prolog_flag(argv,X).

file(Y) :- args(XS), [X|_] = XS, atom_string(X,FS), read_file_to_string(FS,Y,[]).