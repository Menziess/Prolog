
/**
 * Opg 1 - Implementeer een predicaat paste/3.
 */
paste([H1], [], [H1]).
paste([], [H2], [H2]).
paste([H1|T], [], [H1|Rest]) :-
  paste(T, [], Rest).
paste([], [H2|T], [H2|Rest]) :-
  paste([], T, Rest).
paste([H1|T1], [H2|T2], [H2|Rest]) :-
  check(>, H1, H2),
  paste([H1|T1], T2, Rest), !.
paste([H1|T1], [H2|T2], [H1|Rest]) :-
  paste(T1, [H2|T2], Rest), !.

/**
 * Opg 2 - Implementeer predicaat div/3 en newquicksort/3.
 */

%a .
div([], [], []).
div([H|T], L1, [H|L2]) :-
  length(T, Length),
  Length mod 2 =:= 0,
  div(T, L1, L2).
div([H|T], [H|L1], L2) :-
  div(T, L1, L2).

% b.
newquicksort(_, [X], [X]).
newquicksort(_, List, Sorted) :-
  div(List, Left, Right),
  newquicksort(_, Left, SortedLeft),
  newquicksort(_, Right, SortedRight),
  paste(SortedLeft, SortedRight, Sorted), !.

/**
 * Opg 3 - Implementeer predicaat init_counter/0, step_counter/0 en
 * get_counter/0.
 */

% a.
init_counter() :-
  retractall(counter(_)),
  assert(counter(0)).

step_counter(New) :-
  counter(Previous),
  retractall(counter(Previous)),
  New is Previous + 1,
  assert(counter(New)).

get_counter(Current) :-
  counter(Current).

% b.
experiment(Name, List, Count) :-
  init_counter(),
  call(Name, _, List, _),
  get_counter(Count).

% c.
random_list()


/**
 * Import algorithms.
 */
:- ["assets/sort"].
