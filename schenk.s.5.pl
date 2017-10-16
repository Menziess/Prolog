% PSS Huiswerk 5
% 10-10-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|-------------------------------------------------------------------------------
| Opg 1
|-------------------------------------------------------------------------------
*/

% :- ['assets/search'].

:- writeln('-------------------------').
:- writeln('Type "go." to start').
:- writeln('-------------------------').

% Asserts a code where the first digit is nonzero.
draw() :-
	random_between(10000, 99999, Code),
	retractall(code(_)),
	assert(code(Code)),
	write_code(Code).

% Writes the code in a stylish fashion.
write_code(Code) :-
	writeln("********************"),
	write("De code: "), writeln(Code),
	writeln("********************").

/*
|-------------------------------------------------------------------------------
| Opg 2
|-------------------------------------------------------------------------------
*/

% Calculate x-score.
scorex(N, X) :-
	code(Code),
	string_chars(Code, ListCode),
	string_chars(N, NN),
	scorex(NN, ListCode, X), !.
scorex([], [], 0).
scorex([H|T1], [H|T2], X) :-
	scorex(T1, T2, XX), !,
	X is XX + 1.
scorex([_|T1], [_|T2], X):-
	scorex(T1, T2, X), !.

% Calculate o-score.
scoreo(N, O) :-
	code(Code),
	string_chars(Code, ListCode),
	string_chars(N, NN),
	scoreo(NN, ListCode, OO),
	scorex(NN, ListCode, X),
	O is OO - X, !.
scoreo([], _, 0).
scoreo([H|T1], T2, O) :-
	member(H, T2),
	select(H, T2, T2N),
	scoreo(T1, T2N, OO),
	O is OO + 1, !.
scoreo([_|T1], T2, O) :-
	scoreo(T1, T2, O).

/*
|-------------------------------------------------------------------------------
| Opg 3
|-------------------------------------------------------------------------------
*/

scorex_of_code(Code, N, X) :-
	string_chars(Code, ListCode),
	string_chars(N, NN),
	scorex(NN, ListCode, X).
scoreo_of_code(Code, N, O) :-
	string_chars(Code, ListCode),
	string_chars(N, NN),
	scoreo(NN, ListCode, OO),
	scorex(NN, ListCode, X),
	O is OO - X.

% Controleert of Trial dezelfde evauatie krijgt als PossibleCode de geheime
% code was.
equalScore(PossibleCode, Trial) :-
	scorex(Trial, X),
	scorex_of_code(PossibleCode, Trial, X),
	scoreo(Trial, O),
	scoreo_of_code(PossibleCode, Trial, O).

% Voert deze controle uit voor een lijst met trials.
equalScores(_, []).
equalScores(PossibleCode, [H|Trials]) :-
	equalScore(PossibleCode, H), !,
	equalScores(PossibleCode, Trials).

/*
|-------------------------------------------------------------------------------
| Opg 4
|-------------------------------------------------------------------------------
*/

% Kijkt of de code klopt.
goal(PossibleCode) :-
	code(PossibleCode), !.

/*
|-------------------------------------------------------------------------------
| Opg 5
|-------------------------------------------------------------------------------
*/

% Move predicate.
move(Visited, Number, NextNumber) :-
	determineNextNumber(Visited, Number, NextNumber).

% Begint te tellen bij N en slaagt als de code de equalscores trial
% passeert.
determineNextNumber(Lijst, N, Code) :-
	Code is N + 1,
	equalScores(Code, Lijst), !.
determineNextNumber(Lijst, N, Resultaat) :-
	Code is N + 1,
	determineNextNumber(Lijst, Code, Resultaat).

/*
|-------------------------------------------------------------------------------
| Opg 5
|-------------------------------------------------------------------------------
*/

% Depthfirst cyclefree uit "search.pl".
solve_depthfirst_cyclefree(Node, Path) :-
  depthfirst_cyclefree([Node], Node, RevPath),
  reverse(RevPath, Path).
depthfirst_cyclefree(Visited, Node, Visited) :-
  goal(Node).
depthfirst_cyclefree(Visited, Node, Path) :-
  move(Visited, Node, NextNode),
  depthfirst_cyclefree([NextNode|Visited], NextNode, Path).

% Print X en O scores.
printScoreXO(Code) :-
	scorex(Code, X),
	scoreo(Code, O),
	writeln(X / O).

% Formatted output.
printSolution([]).
printSolution([H|T]) :-
	write(H), write(" -- "), printScoreXO(H),
	printSolution(T).

% Aanroep solver.
go :-
	draw(),
	solve_depthfirst_cyclefree(10000, Result),
	printSolution(Result), !,
	writeln("********************").
