
check(_, A, B) :-
    Goal =.. [<, A, B],
    call(Goal),
    step_counter(_).

% Vergelijk A en B op grond de relatie Rel.

% ----- de sorteeralgoritmen uit het hc 3/10
% ----- zie Slides voor uitleg

% bubblesort/3

bubblesort(Rel, List, SortedList):-
    swap(Rel, List, NewList),!,
    bubblesort(Rel, NewList, SortedList).
bubblesort(_, SortedList, SortedList).

swap(Rel, [A, B| Tail], [B, A| Tail]):-
    check(Rel, B, A).
swap(Rel, [A| Tail], [A| NewTail]):-
    swap(Rel, Tail, NewTail).

% bubblesort2/3

bubblesort2(Rel, List, SortedList):-
    swap2(Rel, List, NewList),
    List \= NewList, !,
    bubblesort2(Rel, NewList, SortedList).
bubblesort2(_, SortedList, SortedList).

swap2(Rel, [A, B| Tail], [B| NewTail]):-
    check(Rel, B, A),
    swap2(Rel, [A| Tail], NewTail).
swap2(Rel, [A| Tail], [A| NewTail]):-
    swap2(Rel, Tail, NewTail).
swap2(_, [], []).

% quicksort/3

quicksort(_, [], []).
quicksort(Rel, [Head|Tail], SortedList):-
    split(Rel, Head, Tail, FirstHalf, SecondHalf),
    quicksort(Rel, FirstHalf, SortedFirstHalf),
    quicksort(Rel, SecondHalf, SortedSecondHalf),
    append(SortedFirstHalf, [Head| SortedSecondHalf], SortedList).

split(_, _, [], [], []).
split(Rel, Middle, [Head|Tail], [Head|Tail1], List2):-
    check(Rel, Head, Middle), !,
    split(Rel, Middle, Tail, Tail1, List2).
split(Rel, Middle, [Head|Tail], List1, [Head|Tail2]):-
    split(Rel, Middle, Tail, List1, Tail2).
