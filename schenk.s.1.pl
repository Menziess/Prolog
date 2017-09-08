% PSS Huiswerk 1
% 06-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com


/*
|--------------------------------------------------------------------------
| Opg 1 - De studievereniging organiseert een pannenkoekenfeestje.
|--------------------------------------------------------------------------
|
| answer/1 kijkt of de topping TA van de student die gegeven is, gelijk 
| is aan de topping die als input meegegeven wordt. Bijvoorbeeld: 
|
| ?- answer(stefan).
| The favourite pancake topping of the TA of this student is 'stroop met suiker'.
| 
| true.
*/
  
has_ta(alice, mary). 
has_ta(bob, mary). 
has_ta(cecilia, paul).
has_ta(stefan, mattijs). % Mattijs is mijn TA

has_favourite_topping(peter, 'nutella'). 
has_favourite_topping(paul, 'strawberry jam'). 
has_favourite_topping(mary, 'caramel').
has_favourite_topping(mattijs, 'stroop met suiker'). % Mattijs houdt van 

answer(Student) :-
  has_ta(Student, TA),
  write('The favourite pancake topping of the TA of this student is '), 
  read(Topping), % user input
  nl,
  has_favourite_topping(TA, Topping).


/*
|--------------------------------------------------------------------------
| Opg. 2 - Bepaal voor de volgende termen of het lijsten zijn.
|--------------------------------------------------------------------------
|
| 
*/

isList([]).
isList([_]).
% 1. [1, 2| 3]
% 2. [1| [2, 3]]
% 3. [[1]| 2, 3]
% 4. [[1]| [2, 3]]
% 5. [1| [2| 3]]
% 6. [1| [2| [3]]]
% 7. [1, 2| [3]]
% 8. [[]| []]

/*
|--------------------------------------------------------------------------
| Opg. 3 - Beschouw het volgende simpele programmaatje:
|--------------------------------------------------------------------------
|
| 
*/

whatisthis([]). 
whatisthis([_, b| L]) :- 
  whatisthis(L).

% Onder welke voorwaarden slaagt een query:
% ?- whatisthis(X)?

/*
|--------------------------------------------------------------------------
| Opg. 4 - Bij deze opgave is member/2 dat test of een term een element 
| is van een lijst de enige built-in die je mag gebruiken.
|--------------------------------------------------------------------------
|
| 
*/
