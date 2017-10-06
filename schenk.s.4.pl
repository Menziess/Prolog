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
nth(N, [H|T], E) :-
  NN is N - 1,
  nth(NN, T, E), !.

% Haalt 3 elementen vanaf index N op
nth3(0, [H1, H2, H3|_], [H1,H2,H3]) :-
  !.
nth3(N, [H|T], L) :-
  NN is N - 1,
  nth3(NN, T, L), !.

% % Creert een lege lijst met '.'
% emptyList(0, []).
% emptyList(N, [.|List]) :-
%   NN is N - 1,
%   emptyList(NN, List), !.

% % Creert een lege sudoku
% emptySudoku(0, []).
% emptySudoku(Size, [Col|State]) :-
%   emptyList(Size, Col),
%   NewSize is Size - 1,
%   emptySudoku(NewSize, State), !.

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

/*
|-------------------------------------------------------------------------------
| Opg 2
|-------------------------------------------------------------------------------
*/

% Alle indices beginnen met index 0

% Haalt kolom N op.
kolom(0, [H|State], H).
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
goal(State) :-
  write("checkt eindtoestand").

/*
|-------------------------------------------------------------------------------
| Opg 4
|-------------------------------------------------------------------------------
*/
move(CurrentState, NewState) :-
  write("..").
