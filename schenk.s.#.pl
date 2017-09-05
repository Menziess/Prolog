% PSS Huiswerk # <nummer van de desbetreffende aflevering>
% <datum>
% <naam>, <student-nummer>, <e-mail-adres>

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

% concatinate a mixture of lists and / or elements
concat_lists([Elem | List1], List2, [Elem | List3]) :-
  concat_lists(List1, List2, List3).

/** <examples>
?- List = [apple, pear, cucumber, [1, 2, 3], []].
?- reverse(List).
?- length(List).
*/
