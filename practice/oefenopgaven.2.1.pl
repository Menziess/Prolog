
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
maxList([H|T], X) :-
  maxList(T, H, X).
maxList([], H, H).
maxList([H|T], Max, X) :-
  H > Max,
  maxList(T, H, X) ; maxList(T, Max, X).

/**
 * Opg. 5 De bedoeling van deze opgave is om een n×m-rooster, d.i. wiskunde 
 * papier van n bij m blokjes, waarbij n staat voor de hoogte van het rooster 
 * en m voor de breedte van het rooster. Hier moet je dus uiteindelijk een 
 * predicaat writeGrid/2 implementeren zodat een aanroep als
 * ?- writeGrid(3, 4).
 * het volgende resultaat geeft:
     _ _ _ 
    |_|_|_| 
    |_|_|_| 
    |_|_|_|
    |_|_|_|

    Dit zal niet in een keer lukken. Daarom bouwen we de implementatie op met 
    hulp-predicaten.

    (a) Om een horizontale lijn te maken deﬁnieer eerst een predicaat 
    writeHorizontal/1 dat een gegeven aantal keer (d.i. een spatie gevolgd 
    door een liggend streepje, underscore) uitschrijft:

    ?- writeHorizontal(10).
    _ _ _ _ _ _ _ _ _ _ 
    true
 */

writeNChar(N, Char) :-
  (string(Char) ; atom(Char)), 
  integer(N),
  N > 1, 
  N1 is N - 1,
  write(Char),
  writeNChar(N1, Char).
writeNChar(_, Char) :-
  write(Char). 

writeHorizontal(X) :-
  writeNChar(X, ' _').

/**
    (b) Deﬁnieer vervolgens writeVertical/1 voor de staande streepjes (bar) en 
    een afsluitende horizontale lijn. Let op: Deze moet beginnen en eindigen 
    met een | en daartussen moeten weer liggende streepjes komen:

    ?- writeVertical(10). 
    |_|_|_|_|_|_|_|_|_| 
    true
*/

writeVertical(X) :-
  writeNChar(X, '|_'),
  write('|').

/**
    (c) En afsluitend, deﬁnieer writeGrid/2 met behulp van recursie. Het basis-geval 
    is een rooster van hoogte 0 (slechts een horizontale lijn) en de recursieve regel 
    heb je nodig om te specificeren hoe je van een rooster van hoogte n er een maakt 
    van hoogte n + 1.
*/

writeGrid(N, M) :-
  writeHorizontal(M), nl,
  drawGrid(N, M).
drawGrid(_, M) :-
  integer(M),
  M > 0,
  writeVertical(M).
drawGrid(N, M) :-
  integer(N), integer(M),
  N > 1, M > 0,
  N1 is N - 1,
  writeHorizontal(M), nl,
  writeVertical(M), nl,
  writeGrid(N1, M).

/**
 * Opg. 6 Definieer een predicaat split/3 om een gegeven lijst van 
 * lengte 2n op te delen in twee gelijke helften (lengte n). Bijvoorbeeld:
 * ?- split([a,b,c,1,2,3], L1, L2). L1 = [a,b,c] L2 = [1,2,3]
 * Hierbij kan je gebruikmaken van pushBot/3 en popBot/3 uit opgaven 7 en 8 van de 
 * oefenopgaven van woensdag 6/9. split/3 moet falen voor lijsten met een oneven 
 * aantal elementen.
 */

split([], [], []).
split(List, L1, L2) :-
  length(List, Length),
  mod(Length, 2) =:= 0,
  Half is div(Length, 2),
  split(Half, List, L1, L2).
split(_, [], [], []).
split(Mid, [H|T], [H|List1], List2) :-
  length(T, Length),
  Length >= Mid,
  split(Mid, T, List1, List2).
split(Mid, [H|T], List1, [H|List2]) :-
  split(Mid, T, List1, List2).

/**
 * Opg. 7 Implementeer een predicaat fac/2 dat de faculteit n! van getal een 
 * niet-negatief geheel getal n uitrekent en in zijn tweede argument aﬂevert.
 */

fac(N, R) :-
  N > 1,
  N1 is N - 1,
  fac(N1, R1),
  R is R1 * N.
fac(_, 1).


/**
 * Opg. 8 Opgave 3.3 en 3.4 uit de Lecture Notes van Ulle Endriss. 
 * De eerste is tamelijk eenvoudig, de tweede lastiger, maar wel belangrijk.
 */

fibonacci(N, 1) :-
  N < 2.
fibonacci(N, R) :-
  N1 is N - 1,
  N2 is N - 2,
  fibonacci(N1, R1),
  fibonacci(N2, R2),
  R is R2 + R1.

fastfibo(N, R) :-
  print('todo').

% (1 + sqr(5))^n - (1 - sqrt(5))^n
% / 2^n * sqrt(5)
