
/**
 * Opg. 1 Implementeer een predicaat sumList/2 waarmee je de som 
 * van de getallen in een gegeven lijst van getallen kan bepalen.
 */

sumList([], 0).
sumList([H|T], S) :-
  sumList(T, S1),
  S is S1 + H.

/**
 * Opg. 2 Implementeer een predicaat sumListInteger/2 waarmee je 
 * de som van de gehele getallen (integers) in een willekeurige 
 * lijst, (d.i. een lijst waar bij naast gehele getallen ook
 * andere objecten kunnen zitten) kan bepalen.
 */

sumListInteger([], 0).
sumListInteger([H|T], S) :-
  integer(H),
  sumListInteger(T, S1), 
  S is S1 + H.
sumListInteger([_|T], S) :-
  sumListInteger(T, S).

/**
 * Opg. 3 Implementeer een predicaat orderedList/1 waarmee je 
 * bepaalt of een gegeven lijst van getallen naar omvang oplopend 
 * geordend is. M.a.w., er mag geen tweetal getallen x en y voorkomen 
 * waarbij x > y terwijl x voor y in de lijst staat.
 */

orderedList([]).
orderedList([H|T]) :-
  orderedList(T, H).
orderedList([], _).
orderedList([H|T], Prev) :-
  Prev < H,
  orderedList(T, H).

/**
 * Opg. 4 Implementeer een predicaat maxList/2 waarmee je het maximum 
 * van een lijst van getallen kan bepalen.
 */

maxList([], _).
maxList([H|T], R) :-
  maxList(H, T, R).
maxList(H, [], R) :-

/**
 * Opg. 5 De bedoeling van deze opgave is om een n×m-rooster, d.i. wiskunde papier van n bij m blokjes, waarbij n staat voor de hoogte van het rooster en m voor de breedte van het rooster. Hier moet je dus uiteindelijk een predicaat writeGrid/2 implementeren zodat een aanroep als
 * ?- writeGrid(3, 4).
 * het volgende resultaat geeft:
     _ _ _ 
    |_|_|_| 
    |_|_|_| 
    |_|_|_|
    |_|_|_|

    Dit zal niet in een keer lukken. Daarom bouwen we de implementatie op met hulp-predicaten.

    (a) Om een horizontale lijn te maken deﬁnieer eerst een predicaat writeHorizontal/1 dat een gegeven aantal keer (d.i. een spatie gevolgd door een liggend streepje, underscore) uitschrijft:

    ?- writeHorizontal(10).
    _ _ _ _ _ _ _ _ _ _ 
    true

    (b) Deﬁnieer vervolgens writeVertical/1 voor de staande streepjes (bar) en een afsluitende horizontale lijn. Let op: Deze moet beginnen en eindigen met een | en daartussen moeten weer liggende streepjes komen:

    ?- writeVertical(10). 
    | | | | | | | | | | | 
    true

    (c) En afsluitend, deﬁnieer writeGrid/2 met behulp van recursie. Het basis-geval is een rooster van hoogte 0 (slechts een horizontale lijn) en de recursieve regel heb je nodig om te speciﬁceren hoe je van een rooster van hoogte n er een maakt van hoogte n + 1.

*/

/**
 * Opg. 6 Deﬁnieer een predicaat split/3 om een gegeven lijst van lengte 2n op te delen in twee gelijke helften (lengte n). Bijvoorbeeld:
 * ?- split([a,b,c,1,2,3], L1, L2). L1 = [a,b,c] L2 = [1,2,3]
 * Hierbij kan je gebruikmaken van pushBot/3 en popBot/3 uit opgaven 7 en 8 van de oefenopgaven van woensdag 6/9. split/3 moet falen voor lijsten met een oneven aantal elementen.
 */

/**
 * Opg. 7 Implementeer een predicaat fac/2 dat de faculteit n! van getal een niet-negatief geheel getal n uitrekent en in zijn tweede argument aﬂevert.2
 */

/**
 * Opg. 8 Opgave 3.3 en 3.4 uit de Lecture Notes van Ulle Endriss. De eerste is tamelijk eenvoudig, de tweede lastiger, maar wel belangrijk.3
 */