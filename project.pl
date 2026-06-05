:- use_module(library(clpfd)).

args(X) :- current_prolog_flag(argv,X).

file(Y) :- args(XS), [X|_] = XS, atom_string(X,FS), read_file_to_string(FS,Y,[]).

heads_and_tails([],[],[]).
heads_and_tails([[H|T]|L],[H|Heads],[T|Tails]) :- heads_and_tails(L,Heads,Tails).

myTranspose(L,[]) :- maplist( =([]), L).
myTranspose(L,[H|M]) :- heads_and_tails(L,H,T), myTranspose(T,M).


edgegrid([X|G],E) :- X1 + 1 #= X, length([X|G],L), edgegrid1([X|G],X,X1,E,L).
edgegrid1([X],X,0,[1],L) :- L #>= 0.
edgegrid1([X|G],X,N,[0|E],L) :- L #>= X, X #> 0,N #> 0, X #>= N, N1 + 1 #= N, edgegrid1(G,X,N1,E,L).
edgegrid1([X,Y|G],X,0,[1|E], L) :- L #>= X, X #> 0, Y #> 0, Y1 + 1 #= Y, edgegrid1([Y|G],Y,Y1,E,L).

hasEdgegrid(L) :- edgegrid(L,_).

isRect([X|LL]) :- maplist(same_length(X), LL).

squaregrid(LL) :- isRect(LL), myTranspose(LL,TL), maplist(hasEdgegrid,LL), maplist(hasEdgegrid, TL).

matches(X,X).
matches(_,0).
matches(0,_).

allMatches(L,M) :- maplist(matches, L, M).

allAllMatches(LL,MM) :- maplist(allMatches, LL, MM).

split_string1(Sep,Pad,Sub,String) :- split_string(String,Sep,Pad,Sub).

stringToLL(S, LL) :- split_string(S, "\n", "\n", L), maplist(split_string1(" ", " "), LL, L).

