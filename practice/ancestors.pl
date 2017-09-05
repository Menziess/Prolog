% Some simple test Prolog programs
% --------------------------------

% Knowledge bases

% vincent is the parent of mia
parentChild(vincent, mia).
% pepe is the parent of vincent and the ancestor of mia
parentChild(pepe, vincent).
% pope is the parent of pepe and the ancestor of vincent and mia
parentChild(pope, pepe).

% checks whether someone is parent of someone else
isParentOf(Parent, Of) :-
    parentChild(Parent, Of).

% checks whether someone is ancestor of someone recursively
isAncestorOf(Ancestor, Of) :-
    isParentOf(Ancestor, Of).
isAncestorOf(Ancestor, Of) :-
    isParentOf(Ancestor, X),
    isAncestorOf(X, Of).

% checks whether someone is predecessor of someone recursively
isPredecessorOf(Predecessor, Of) :-
    isParentOf(Of, Predecessor).
isPredecessorOf(Predecessor, Of) :-
    isParentOf(Of, X),
    isPredecessorOf(Predecessor, X).

/** <examples>

?- isParentOf(vincent, mia).
?- isParentOf(vincent, X).

?- isAncestorOf(pepe, mia).
?- isAncestorOf(pope, mia).
?- isAncestorOf(pope, X).


?- isPredecessorOf(mia, pepe).
?- isPredecessorOf(mia, pope).
?- isPredecessorOf(mia, X).


*/