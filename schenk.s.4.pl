% PSS Huiswerk #
% <datum>
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|-------------------------------------------------------------------------------
| Helper predicates
|-------------------------------------------------------------------------------
*/

% Haalt het nth element op
nth(0, [H|_], H) :-
  !.
nth(N, [_|T], E) :-
  NN is N - 1,
  nth(NN, T, E), !.

% Haalt 3 elementen vanaf index N op
nth3(0, [H1, H2, H3|_], [H1,H2,H3]) :-
  !.
nth3(N, [_|T], L) :-
  NN is N - 1,
  nth3(NN, T, L), !.

/*
|-------------------------------------------------------------------------------
| Opg 1
|-------------------------------------------------------------------------------
*/

% Elke list stelt een kolom voor.
beginToestand(State) :-
  State = [
    [1, 2, ., ., 6, ., ., ., .],
    [., ., 3, ., ., ., 8, 1, .],
    [., ., 6, ., 7, ., ., 3, .],
    [., ., ., ., ., ., ., ., .],
    [., ., ., 6, 2, ., 7, ., 1],
    [2, 1, 7, ., 9, ., ., ., .],
    [7, ., ., 8, ., ., 3, 5, .],
    [6, ., ., 7, ., ., ., ., 9],
    [., 8, 4, 2, ., ., ., ., 7]
  ].

eindToestand(State) :-
  State = [
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [2, 3, 4, 5, 6, 7, 8, 9, 1],
    [3, 4, 5, 6, 7, 8, 9, 1, 2],
    [4, 5, 6, 7, 8, 9, 1, 2, 3],
    [5, 6, 7, 8, 9, 1, 2, 3, 4],
    [6, 7, 8, 9, 1, 2, 3, 4, 5],
    [7, 8, 9, 1, 2, 3, 4, 5, 6],
    [8, 9, 1, 2, 3, 4, 5, 6, 7],
    [9, 1, 2, 3, 4, 5, 6, 7, 8],
  ].

/*
|-------------------------------------------------------------------------------
| Opg 2
|-------------------------------------------------------------------------------
*/

% Alle indices beginnen met index 0

% Haalt kolom N op.
kolom(0, [H|_], H).
kolom(N, [_|State], List) :-
  NN is N - 1,
  kolom(NN, State, List).

% Haalt kolommen met indices [Start, End] op
kolomrange(Start, End, _, []) :-
  Start > End.
kolomrange(Start, End, State, [Col|Columns]) :-
  Next is Start + 1,
  kolom(Start, State, Col),
  kolomrange(Next, End, State, Columns), !.

% Haalt rij N op
rij(N, State, Row) :-
  findall(Elem, (member(Col, State), nth(N, Col, Elem)), Row).

% Haalt kwadrant op door eerst de juiste kolommen op te halen, en daarna de
% juiste sublijsten uit de kolommen te halen.
kwadrant(N, State, Subs) :-
  Y is N // 3 * 3,
  X is N mod 3 * 3,
  XX is X + 2,
  findall(Col, kolomrange(X, XX, State, Col), [Columns]),
  findall(Sub, (member(Col, Columns), nth3(Y, Col, Sub)), Subs).

/*
|-------------------------------------------------------------------------------
| Opg 3
|-------------------------------------------------------------------------------
*/

% Bepaalt of alle elementen van een lijst uniek en geen '.' zijn
unique([]).
unique([_, []]).
unique([H|T]) :-
  \+ member('.', H),
  \+ member(H,T),
  unique(T).

% Als alle kolommen en rijen uniek zijn, en geen '.' bevatten, is de sudoku
% opgelost
goal(State, Rows) :-
  findall(Row, rij(N, State, Row), Rows),
  unique(State).

test() :-
  eindToestand(State),
  goal(State).

/*
|-------------------------------------------------------------------------------
| Opg 4
|-------------------------------------------------------------------------------
*/
move(CurrentState, NewState) :-
  write("..").

/*
|-------------------------------------------------------------------------------
| Opg 5
|-------------------------------------------------------------------------------
*/
% go()
% ------------------------
% | 1 . . | . . 2 | 7 6 . |
% | 2 . . | . . 1 | . . 8 |
% | . 3 6 | . . 7 | . . 4 |
% ------------------------
% | . . . | . 6 . | 8 7 2 |
% | 6 . 7 | . 2 9 | . . . |
% | . . . | . . . | . . . |
% ------------------------
% | . 8 . | . 7 . | 3 . . |
% | . 1 3 | . . . | 5 . . |
% | . . . | . 1 . | . 9 7 |
% ------------------------
