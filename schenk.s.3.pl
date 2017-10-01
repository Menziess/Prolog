% PSS Huiswerk 3
% 19-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com



/*

  Beste Mattijs,

  Bij de vorige opgave kreeg ik deze feedback:

  "
    # Opgave 4:
    ?- primes(30).
    Primes: [2,3,5]
    true .
    Dit zijn helaas niet alle priemgetallen onder de 30
    Exit: (11) filterMultiples(5, [7, 11, 13, 17, 19, 23, 25, 29], [11, 17]) ? creep
    De lijst rest zit wel ergens in je code maar moet nog teruggegeven. Het zou
    fijn als dergelijk gedrag ook terug is te vinden in je commentaar.
  "

  In de opgave staat dat bij een voorbeeld met n=30; de procedure moet stoppen
  zodra k**2 > n. Dit zorgt er dus voor dat er maar 3 priemgetallen worden
  gevonden: 2, 3 en 5. Omdat bij k=7, k**2 >= 30.

  Als ik de opdracht verkeerd heb begrepen, my bad. Maar na de opdracht opnieuw
  gelezen te hebben, lijkt mij dat dit juist wordt gevraagd.

*/

/*
|-------------------------------------------------------------------------------
| Opg 1 - Implementeer een Prolog-predicaat random_code/1 .
|-------------------------------------------------------------------------------
*/

% Alle kleuren.

color(rood).
color(oranje).
color(geel).
color(blauw).
color(groen).
color(bruin).
colors(X) :-
  findall(Y, color(Y), X).

% Een code bestaat uit een combinatie van 4 verschillende getallen van 0 tot en
% met 5. De zes verschillende getallen in een lijst worden geschuffled, daarna
% wordt met behulp van de combinatie append en een lijst van 2 elementen, de
% laaste 4 elementen uit de lijst opgehaald.

random_code(R) :-
  colors(Colors),
  random_permutation(Colors, List),
  length(Pre, 2),
  append(Pre, R, List).


/*
|-------------------------------------------------------------------------------
| Opg 2 - Implementeer een Prolog-predicaat all_codes/1 .
|-------------------------------------------------------------------------------
*/

% De rule colorCombo zorgt dat de verschillende variabelen verschillend zijn.

colorCombo([W, X, Y, Z]) :-
  color(W),
  color(X),
  color(Y),
  color(Z),
  \+ W = X, \+ W = Y, \+ W = Z,
  \+ Y = X, \+ Y = Z,
  \+ Z = X.

% De totale hoeveelheid mogelijkheden zou moeten zijn: 6 * 5 * 4 * 3 = 360.

all_codes(R) :-
  findall([C1, C2, C3, C4], colorCombo([C1, C2, C3, C4]), R),
  length(R, Length),
  write("Amount of possible combinations: "), write(Length), nl, nl.


/*
|-------------------------------------------------------------------------------
| Opg 3 - Implementeer een Prolog-predicaat evaluate_trial/3.
|-------------------------------------------------------------------------------
*/

% De originele code wordt meegegeven om te kunnen checken of de head van de
% poging zich bevind in de code in het predikaat evaluate_trial/4.

evaluate_trial(Code, Attempt, Eval) :-
  evaluate_trial(Code, Code, Attempt, Eval).

% Als de kleur goed is wordt er een 'x' in de Evaluation gezet, als de kleur
% zich in de code bevind wordt er een 'o' in gezet, en anders een 'wrong'.

evaluate_trial([], _, [], []).
evaluate_trial([H|T], O, [H|T1], [x|Eval]) :-
  evaluate_trial( T,  O, T1, Eval).
evaluate_trial([_|T], O, [H|T1], [o|Eval]) :-
  member(H, O),
  evaluate_trial( T,  O, T1, Eval), !.
evaluate_trial([_|T], O, [_|T1], [' '|Eval]) :-
  evaluate_trial( T,  O, T1, Eval), !.


/*
|-------------------------------------------------------------------------------
| Opg 4 - Implementeer een Prolog-predicaat update/4.
|-------------------------------------------------------------------------------
*/

write_list([]).
write_list([H|T]):-
  write(H), write(" "),
  write_list(T).

% Update possibilities door kleuren en correcte posities te filteren.

update(Code, Possibilities, Attempt, Leftovers) :-
  evaluate_trial(Code, Attempt, Eval),
  evaluate_attempt(Attempt, Eval, Colors, Positions),

  filterColors(Colors, Possibilities, ColorFiltered),
  filterPositions(Positions, ColorFiltered, Leftovers),

  length(Leftovers, Length),
  write(Length),
  write_list(Attempt),
  write("\t"),
  write_list(Eval), nl.

% Creert een lijst met kleuren en posities die correct waren.

evaluate_attempt([], [], [], []).
evaluate_attempt([A|T], [E|T1], [A|Color], [A|Position]) :-
  E = x,
  evaluate_attempt(T, T1, Color, Position).
evaluate_attempt([A|T], [E|T1], [A|Color], [' '|Position]) :-
  E = o,
  evaluate_attempt(T, T1, Color, Position).
evaluate_attempt([_|T], [_|T1], Color, [' '|Position]) :-
  evaluate_attempt(T, T1, Color, Position).

% Filtert kleuren weg die niet in de code zitten.

filterColors([], _, _).
filterColors([H|T], Possibilities, Leftovers) :-
  filterColors(T, Possibilities, Leftovers),
  filterColor(H, Possibilities, Leftovers).

filterColor(_, [], []).
filterColor(Color, [P|Possibilities], [P|Leftovers]) :-
  member(Color, P), !,
  filterColor(Color, Possibilities, Leftovers).
filterColor(Color, [_|Possibilities], Leftovers) :-
  filterColor(Color, Possibilities, Leftovers).

% Filtert posities weg die niet goed geraden waren.

filterPositions(Positions, Possibilities, Leftovers) :-
  filterPosition(Positions, Possibilities, Leftovers, 0).

filterPosition([], _, _, _).
filterPosition([H|T], Possibilities, Leftovers, Nth) :-
  \+ H = ' ',
  findall(
    H,
    (member(L, Possibilities), nth0(Nth, L, Elem), Elem = H),
    Leftovers
  ),
  Nth1 is Nth + 1,
  filterPosition(T, Leftovers, Leftovers, Nth1).
filterPosition([_|T], Possibilities, Leftovers, Nth) :-
  Nth1 is Nth + 1,
  filterPosition(T, Possibilities, Leftovers, Nth1).


/*
|-------------------------------------------------------------------------------
| Opg 5 - Implementeer een Prolog-predicaat trials.
|-------------------------------------------------------------------------------
*/

% Genereert een code en berekent alle possibilities, vervolgens begint de eerste
% trial met alle possibilities.

trials() :-
  random_code(Code),
  all_codes(Possibilities),
  write("--------------------------------------"),  nl,
  write("Geheime code = "), write_list(Code),       nl,
  write("--------------------------------------"),  nl,
  nl,
  trial(Code, Possibilities, 1).

% Met een loop worden de updates aangeroepen.

trial(Code, [Possibility|Possibilities], N) :-
  N =< 30,
  N1 is N + 1,
  write("Poging "), write(N), write(" = "),
  update(Code, Possibilities, Possibility, Leftover), !,
  trial(Code, Leftover, N1).


