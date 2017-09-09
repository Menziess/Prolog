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
|
| of:
|
| ?- answer(stefan).
| The favourite pancake topping of the TA of this student is 'smeerworst'.
| 
| false.
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
| Om vast te stellen of verschillende input lists waren, heb ik de 
| ingebouwde predicate is_list/1 gebruikt.
*/

% 1. is_list([1, 2| 3]).     : false  : bevat 1 en conditional
% 2. is_list([1| [2, 3]]).   : true   : bevat 1 of list [2, 3]
% 3. is_list([[1]| 2, 3]).   : true   : bevat list [1] of 2, 3
% 4. is_list([[1]| [2, 3]]). : true   : bevat list [1] of list [2, 3] 
% 5. is_list([1| [2| 3]]).   : false  : bevat 1 of list met conditional
% 6. is_list([1| [2| [3]]]). : true   : bevat 1 of list [[2]] of [[[3]]]
% 7. is_list([1, 2| [3]]).   : true   : bevat 1 en 2 of list [3]
% 8. is_list([[]| []]).      : true   : bevat lege list

/*
|--------------------------------------------------------------------------
| Opg. 3 - Beschouw het volgende simpele programmaatje:
| Onder welke voorwaarden slaagt een query:
| ?- whatisthis(X)?
|--------------------------------------------------------------------------
| 
| De query 'whatisthis(X) slaagt als X een lege list is, of als X een list
| is met twee elementen, waarvan het tweede element een b is.
*/

whatisthis([]). 
whatisthis([_, b| L]) :- 
  whatisthis(L).

% whatisthis([]).             : slaagt
% whatisthis([wildcard, b]).  : slaagt

/*
|--------------------------------------------------------------------------
| Opg. 4 - Schrijf een Prolog-programma dat implementaties bevat van vier 
| predicaten: remove first/3, remove last/3, remove all/3 en remove list/3.
| De eerste is bedoeld om het eerste voorkomen van een gegeven atoom in een 
| gegeven lijst te verwijderen. Het atoom is het eerste argument, de te 
| bewerken lijst het tweede argument, en het resultaat het derde.
|--------------------------------------------------------------------------
| 
| Ik heb als eerste de base cases gedefinieerd, daarna gekeken in welke
| staat het programma zou verkeren als er 1 element gevonden werd. 
| Vervolgens het programma verder laten zoeken of de recursie af laten
| maken.
*/
remove_first(_, [], []).                              % Base case
remove_first(Element, [Element|Tail], Tail).          % Het element bevind zich op de eerste positie van de list, dus tail is het resultaat
remove_first(Element, [Head|Tail], [Head|Result]) :-  % Het element bevind zich niet op de eerste positie, dus wordt er verder gezocht
  remove_first(Element, Tail, Result).                % Op recursieve wijze wordt het element gezocht


remove_last(_, [], []).                               % Base case
remove_last(Element, [Element|Tail], Tail) :-         % Het element bevind zich op de eerste positie
  not(member(Element, Tail)).                         % en niet in de tail
remove_last(Element, [Head|Tail], [Head|Result]) :-   % Het element bevind zich niet op de eerste positie, dus wordt er verder gezocht
  remove_last(Element, Tail, Result).                 % Op recursieve wijze wordt het element gezocht


remove_all(_, [], []).                                % Base case
remove_all(Element, [Element|Tail], Result) :-        % Het element bevind zich op de eerste positie
  remove_all(Element, Tail, Result).                  % Verwijder element en ga verder
remove_all(Element, [Head|Tail], [Head|Result]) :-    % Het element bevind zich misschien in de tail
  remove_all(Element, Tail, Result).                  % Op recursieve wijze wordt het element gezocht


remove_list([], [], []).
remove_list([First], List, Result) :-
  remove_all(First, List, Result).
remove_list([First|Rest], List, Result) :-
  remove_list(Rest, List, Result).


/*
|--------------------------------------------------------------------------
| Opg. 5 - Geef een Prolog-implementatie voor een operatie intersect/3 
| voor het bepalen van een lijst die de elementen bevat die twee gegeven 
| lijsten gemeenschappelijk hebben. De bedoeling is dat het resultaat van 
| al deze gemeenschappelijke elementen slechts een representant herbergt. 
|--------------------------------------------------------------------------
|
|   
*/

intersect([], [], []).
intersect([Head|Tail], List, Result) :-
  
% ?- intersect([a,c,a,b], [d,b,a,b], X) levert X = [a,b] of X = [b,a].