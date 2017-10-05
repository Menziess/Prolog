% PSS Huiswerk #
% <datum>
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|-------------------------------------------------------------------------------
| Opg 1
|-------------------------------------------------------------------------------
*/
emptyList(0, []).
emptyList(N, [.|List]) :-
  NN is N - 1,
  emptyList(NN, List), !.

emptySudoku(0, []).
emptySudoku(Size, [Col|State]) :-
  emptyList(Size, Col),
  NewSize is Size - 1,
  emptySudoku(NewSize, State), !.

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

% Alle indices beginnen met 0.

% Haalt kolom N op.
kolom(0, [H|State], H).
kolom(N, [_|State], List) :-
  NN is N - 1,
  kolom(NN, State, List).

% Haalt kolommen met indices [Start, End] op.
kolomrange(Start, End, _, []) :-
  Start > End.
kolomrange(Start, End, State, [Col|Columns]) :-
  Next is Start + 1,
  kolom(Start, State, Col),
  kolomrange(Next, End, State, Columns).

% Haalt rij N op.
rij(N, State, Row) :-
  findall(Elem, (member(Col, State), nth0(N, Col, Elem)), Row).

% Haalt kwadrant op.
kwadrant(N, State, Columns) :-
  Y is N // 3 * 3,
  X is N mod 3 * 3,
  XX is X + 2,
  findall(Col, kolomrange(X, XX, State, Col), Columns).



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
