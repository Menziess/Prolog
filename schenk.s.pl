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

/* example:
concat_lists([1, 2], [a, b], X).        : rule where X is passed as a shared memory address
  concat_lists([2], [a, b], X).         : rule " "
    concat_lists([], [a, b], X).        : fact list is empty so it hits the base case and X is matched
    concat_lists([], [a, b], [a, b]).   : fact = true, the shared memory address now contains [a, b]
  concat_lists([Elem = 2], [a, b], [Elem = 2 | [a, b] ]).    : Elem 2 is merged with list [a, b] and shared with previous stack memory address
concat_lists([Elem = 1, Tail = [2]], [a, b], [Elem = 1 | [2, a, b] ])

The return value is the list: X = [1, 2, a, b]
*/

% Print list
show(List) :-
  member(Element, List),
  write(Element),
  nl,
  fail.
