% PSS Huiswerk 3
% 19-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com


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

% De originele code wordt twee keer meegegeven aan evaluate_trial/4.

evaluate_trial(Code, Attempt, Eval) :-
  evaluate_trial(Code, Code, Attempt, Eval).

% Als de kleur goed is wordt er een 'x' in de Evaluation gezet, als de kleur
% zich in de code bevind wordt er een 'o' in gezet, en anders een ' '.

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

% Print lijst op nette manier uit.

write_list([]).
write_list([H|T]):-
  write(H), write(" "),
  write_list(T).

% Kijkt of twee lijsten gelijk gemaakt kunnen worden.

listEquals([], []).
listEquals([H1|T1], [H2|T2]) :-
  H1 = H2,
  listEquals(T1, T2).

% Update possibilities door kleuren en correcte posities te filteren.

update(Code, Possibilities, Attempt, Leftovers) :-
  evaluate_trial(Code, Attempt, Eval),
  evaluate_attempt(Attempt, Eval, Colors, Correct, Incorrect),

  filterColors(Colors, Possibilities, Leftovers1),
  findall(X, filterCorrect(Correct, Leftovers1, [X]), Leftovers2),
  findall(Y, filterIncorrect(Incorrect, Leftovers2, [Y]), Leftovers),

  write_list(Attempt),
  write("\t"),
  write_list(Eval), nl.

% Creert lijsten met kleuren en posities die correct of incorrect waren om
% de Possibilities te kunnen filteren.

evaluate_attempt([], [], [], [], []).
evaluate_attempt([A|T], [E|T1], [A|Color], [A|Correct], [' '|Incorrect]) :-
  E = x,
  evaluate_attempt(T, T1, Color, Correct, Incorrect).
evaluate_attempt([A|T], [E|T1], [A|Color], [_|Correct], [A|Incorrect]) :-
  E = o,
  evaluate_attempt(T, T1, Color, Correct, Incorrect).
evaluate_attempt([A|T], [_|T1], Color, [_|Correct], [A|Incorrect]) :-
  evaluate_attempt(T, T1, Color, Correct, Incorrect).

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

% Behoudt de mogelijkheden met posities die goed geraden zijn.

filterCorrect(_, [], []).
filterCorrect(Correct, [Possibility|Rest], [Possibility|Leftovers]) :-
  listEquals(Correct, Possibility),
  filterCorrect(Correct, Rest, Leftovers).
filterCorrect(Correct, [_|Rest], Leftovers) :-
  filterCorrect(Correct, Rest, Leftovers).

% Filtert posities weg die niet goed geraden zijn. (Hier werkt iets nog niet
% correct)

filterIncorrect(_, [], []).
filterIncorrect(Incorrect, [Possibility|Rest], [Possibility|Leftovers]) :-
  \+ listEquals(Incorrect, Possibility),
  filterIncorrect(Incorrect, Rest, Leftovers).
filterIncorrect(Incorrect, [_|Rest], Leftovers) :-
  filterIncorrect(Incorrect, Rest, Leftovers).


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
  N =< 10,
  N1 is N + 1,
  write("Poging "), write(N), write(" = "),
  update(Code, Possibilities, Possibility, Leftover), !,
  trial(Code, Leftover, N1).


