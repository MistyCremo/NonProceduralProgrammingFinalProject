:- use_module(library(clpfd)).

%Argument the file was run with
args(X) :- current_prolog_flag(argv,X).

%The contents of the file whose name the file was run with, as a string
file(Y) :- args(XS), [X|_] = XS, atom_string(X,FS), read_file_to_string(FS,Y,[]).

%Given a list of lists LL, argument 2 is the haskell-style heads and argument 3 is the haskell-style tails
heads_and_tails([],[],[]).
heads_and_tails([[H|T]|L],[H|Heads],[T|Tails]) :- heads_and_tails(L,Heads,Tails).

%A reversible array transpose for rectangular arrays
myTranspose(L,[]) :- maplist( =([]), L).
myTranspose(L,[H|M]) :- heads_and_tails(L,H,T), myTranspose(T,M).

%Returns true if the left argument is a string of digits, with each digit N appearing N times consecutively
%Second argument returns delimiters for each consecutive string
edgegrid([X|G],E) :- X1 + 1 #= X, length([X|G],L), edgegrid1([X|G],X,X1,E,L).
edgegrid1([X],X,0,[1],L) :- L #>= 0.
edgegrid1([X|G],X,N,[0|E],L) :- L #>= X, X #> 0,N #> 0, X #>= N, N1 + 1 #= N, edgegrid1(G,X,N1,E,L).
edgegrid1([X,Y|G],X,0,[1|E], L) :- L #>= X, X #> 0, Y #> 0, Y1 + 1 #= Y, edgegrid1([Y|G],Y,Y1,E,L).

hasEdgegrid(L) :- edgegrid(L,_).

%Handles the rule that there are no crossing edges on the grid
noCrosses([1],[1],[_],[_]).
noCrosses([0,Y|V1], [_,Y2|V2], [_,W|H1],[_,W2|H2]) :- noCrosses([Y|V1],[Y2|V2],[W|H1],[W2|H2]).
noCrosses([_,Y|V1], [0,Y2|V2], [_,W|H1],[_,W2|H2]) :- noCrosses([Y|V1],[Y2|V2],[W|H1],[W2|H2]).
noCrosses([_,Y|V1], [_,Y2|V2], [0,W|H1],[_,W2|H2]) :- noCrosses([Y|V1],[Y2|V2],[W|H1],[W2|H2]).
noCrosses([_,Y|V1], [_,Y2|V2], [_,0|H1],[_,W2|H2]) :- noCrosses([Y|V1],[Y2|V2],[0|H1],[W2|H2]).

neverCrosses([_],[_]).
neverCrosses([X,Y|V],[Z,W|H]) :- noCrosses(X,Y,Z,W), neverCrosses([Y|V],[W|H]).

%True if the given list of lists is a rectangle
isRect([X|LL]) :- maplist(same_length(X), LL).

%True if LL is a rectangular array full of squares, such that each square is marked by it's size
squaregrid(LL) :- isRect(LL), myTranspose(LL,TL), 
    maplist(edgegrid,LL,VE), maplist(edgegrid, TL, EG2),
    myTranspose(EG2,HE), neverCrosses(VE,HE).

edgegrids(LL,H,V) :- isRect(LL), myTranspose(LL,TL),
    maplist(edgegrid,LL,H), maplist(edgegrid, TL, EG2),
    myTranspose(EG2,V), printLL(H), nl, printLL(V).

%Two numbers are equal, or one is zero
matches(X,X).
matches(0,_).

allMatches(L,M) :- maplist(matches, L, M).

%All numbers match between 2 2d arrays
allAllMatches(LL,MM) :- maplist(allMatches, LL, MM).

%Rotation of split string
split_string1(Sep,Pad,Sub,String) :- split_string(String,Sep,Pad,Sub).

%Converts a string with spaces and line breaks to a 2d array
stringToLL(S, LL) :- split_string(S, "\n", "\n", L), maplist(split_string1(" ", " "), LL, L).

allNums(LS,LI) :- maplist(number_codes,LI,LS).

%Converts a 2d array of strings to a 2d array of integers
allAllNums(LLS,LLI) :- maplist(allNums, LLS, LLI).

%Takes a string input and solves it as a Square Jam puzzle
solve(S, MM) :- stringToLL(S,LL), allAllNums(LL,LLI), allAllMatches(LLI,MM), squaregrid(MM).

printL([]).
printL([X|L]) :- write(X), write(" "), printL(L).
printLL([]).
printLL([X|LL]) :- printL(X), nl, printLL(LL).