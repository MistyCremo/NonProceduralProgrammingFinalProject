args(X) :- current_prolog_flag(argv,X).

file(Y) :- args(XS), [X|_] = XS, atom_string(X,FS), read_file_to_string(FS,Y,[]).

heads_and_tails([],[],[]).
heads_and_tails([[H|T]|L],[H|Heads],[T|Tails]) :- heads_and_tails(L,Heads,Tails).

transpose(L,[]) :- maplist( =([]), L).
transpose(L,[H|M]) :- heads_and_tails(L,H,T), transpose(T,M).