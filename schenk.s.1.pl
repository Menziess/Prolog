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
| Om vast te stellen of verschillende input lists waren, heb ik de 
| predicate is_list/1 gebruikt.
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

/*
|--------------------------------------------------------------------------
| Opg. 4 - Bij deze opgave is member/2 dat test of een term een element 
| is van een lijst de enige built-in die je mag gebruiken.
|--------------------------------------------------------------------------
|
|   
*/

/*

Opg. 4 Bij deze opgave is member/2 dat test of een term een element is van een lijst de enige built-in die je mag gebruiken.2 Schrijf een Prolog-programma dat implementaties bevat van vier predicaten:
remove first/3, remove last/3, remove all/3 en remove list/3.
De eerste is bedoeld om het eerste voorkomen van een gegeven atoom in een gegeven lijst te verwijderen. Het atoom is het eerste argument, de te bewerken lijst het tweede argument, en het resultaat het derde. Bijvoorbeeld:

• ?- remove first(a, [b,a,c,a,d], X) levert X = [b,c,a,d]. (10 ptn)
Als het eerste argument helemaal niet voorkomt in de lijst in het tweede argument dan moet deze lijst gewoon in tact blijven. Het predicaat remove last moet analoog werken voor het laatste voorkomen van het eerste argument in de te bewerken lijst. Bijvoorbeeld:

• ?- remove last(a, [b,a,c,a,d], X) levert X = [b,a,c,d]. (10 ptn)
Wederom moet deze operatie de lijst ongeroerd laten indien het eerste argument niet in de lijst voorkomt. remove all/3 dient alle voorkomens van het eerste argument uit de te bewerken lijst te verwijderen. Bijvoorbeeld:

• ?- remove all(a, [b,a,c,a,d], X) levert X = [b,c,d]. (10 ptn)
De laatste operatie, remove list/3, veronderstelt een lijst als eerste argument. Het resultaat, het derde argument, is wat van de te bewerken lijst (het tweede argument) overblijft als alle voorkomens van elementen van het eerste argument uit het tweede argument verwijderd zijn. Bijvoorbeeld:

• ?- remove list([a,b], [b,a,c,a,d], X) levert X = [c,d]. (10 ptn)

Opg. 5 3 Bij deze opgave is wederom member/2 de enige built-in die je mag gebruiken. Geef een (15 ptn) Prolog-implementatie voor een operatie intersect/3 voor het bepalen van een lijst die de elementen bevat die twee gegeven lijsten gemeenschappelijk hebben. De bedoeling is dat het resultaat van al deze gemeenschappelijke elementen slechts ´e´en representant herbergt. Bijvoorbeeld:

• ?- intersect([a,c,a,b], [d,b,a,b], X) levert X = [a,b] of X = [b,a].
*/