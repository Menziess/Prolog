
/*
|-------------------------------------------------------------------------------
| Opg 1 - Bratko, opgaven 5.1 en 5.3 (pag. 134–135).
|-------------------------------------------------------------------------------
*/

/* 5.1 */
p(1).
p(2) :- !.
p(3).

% ?- p(X).
% X = 1 ;
% X = 2.

% ?- p(X), p(Y).
% X = Y, Y = 1 ;
% X = 1,
% Y = 2 ;
% X = 2,
% Y = 1 ;
% X = Y, Y = 2.

% p(X), !, p(Y).
% X = Y, Y = 1 ;
% X = 1,
% Y = 2.

/* 5.3 */
split([], [], []).
split([H|T], [H|Positives], Negatives) :-
  H >= 0,
  split(T, Positives, Negatives). % Without cut
split([H|T], Positives, [H|Negatives]) :-
  split(T, Positives, Negatives).

split([], [], []).
split([H|T], [H|Positives], Negatives) :-
  H >= 0,
  split(T, Positives, Negatives), !. % With cut
split([H|T], Positives, [H|Negatives]) :-
  split(T, Positives, Negatives).

/*
|-------------------------------------------------------------------------------
| Opg 2 - Endriss, opgaven 5.1 en 5.2 (pag. 58).
|-------------------------------------------------------------------------------
*/

/* 5.1 */
[trace]  ?- (Result = a ; Result = b), !, Result = b.
Call: (8) _G1230=a ? creep
Exit: (8) a=a ? creep
Call: (8) a=b ? creep
Fail: (8) a=b ? creep
false.

member(X, [a, b, c]), !, X = b.
Call: (8) lists:member(_G2233, [a, b, c]) ? creep
Exit: (8) lists:member(a, [a, b, c]) ? creep
Call: (8) a=b ? creep
Fail: (8) a=b ? creep
false.

/* 5.2 */
result([_, E | L], [E | M]) :-
  !, result(L, M).
result(_, []).

(a) After having consulted this program, what would Prolog reply when presented with the following query? Try answering this question ﬁrst without actually typing in the program, but verify your solution later on using the Prolog system.
?- result([a, b, c, d, e, f, g], X).

(b) Brieﬂy describe what the program does and how it does what it does, when the ﬁrst argument of the result/2-predicate is instantiated with a list and a variable is given in the second argument position, i.e., as in item (a). Your explanations should include answers to the following questions:
  – What case(s) is/are covered by the Prolog fact?
  – What e↵ect has the cut in the ﬁrst line of the program?
  – Why has the anonymous variable been used?


/*
|-------------------------------------------------------------------------------
| Opg 3 - Voorzie de code van opgave 4 en 5 van het huiswerk (zie blackboard
| voor Prolog-bestand met de uitwerkingen) van de eerste collegeweek van cuts
| zodanig dat aanroep eenduidige (en correcte) beantwoording oplevert (d.i.
| geen verdere zinloze antwoorden na geforceerd backtracking geeft).
|-------------------------------------------------------------------------------
*/

