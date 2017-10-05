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
kolom(0, [H|State], H).
kolom(N, [_|State], List) :-
  NN is N - 1,
  kolom(NN, State, List).

rij(N, State, Row) :-
  findall(Elem, (member(Col, State), nth0(N, Col, Elem)), Row).

kwadrant(N, State, Quadrant) :-
  Y is N // 3,
  X is N mod 3,


test(R) :-
  beginToestand(State),
  rij(N, State, R).

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
