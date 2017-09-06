% PSS Huiswerk #
% <datum>
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/* Introductie methodes */
f(X, Y, Z) :-
  g(X, Y), 
  g(Y, Z). 
g(X, X).

% makes bobbyJr a child of bobbySr
female(mary). 
female(sandra). 
female(juliet). 
female(lisa). 
male(peter). 
male(paul). 
male(dick). 
male(bob). 
male(harry). 
parent(bob, lisa). 
parent(bob, paul). 
parent(bob, mary). 
parent(juliet, lisa). 
parent(juliet, paul). 
parent(juliet, mary). 
parent(peter, harry). 
parent(lisa, harry). 
parent(mary, dick). 
parent(mary, sandra).

% method checks whether a child parent relatin exists
child(Child, Parent) :- 
  parent(Parent, Child).

% some important groceries

% concatinate a mixture of lists and / or elements recursively
concat_lists([], L, L).
concat_lists([Elem | List1], List2, [Elem | List3]) :-
  concat_lists(List1, List2, List3).

% Print list
show(List) :-
  member(Element, List),
  write(Element),
  nl.
  fail.



/** <examples>
?- List = [apple, pear, cucumber, [1, 2, 3], []].
?- reverse(List).
?- length(List).
?- concat_lists([1, 2], [a, b], L).
*/
