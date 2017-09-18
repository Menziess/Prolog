% PSS Huiswerk 2
% 13-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com


/*
|-------------------------------------------------------------------------------
| Opg 1 - Ulle Endriss: opg. 3.14. Hoe kan je de beste kandidaat in een
| quiz over het vinden van woorden verslaan?
|-------------------------------------------------------------------------------
*/

% Predicaat uit assignment 1
remove_first(_, [], []).
remove_first(Element, [Element|Tail], Tail).
remove_first(Element, [Head|Tail], [Head|Result]) :-
  remove_first(Element, Tail, Result).


% Kijkt of het element in een lijst zit en verwijdert het
cover([], _).
cover([H|T], List) :-
  member(H, List),
  remove_first(H, List, Remainder), !,
  cover(T, Remainder).

% Laadt de words in, zet de woorden om in lists met letters, kijkt of het
% aantal letters overeenkomt met de gewenste score
solution(List, Word, Score) :-
  ensure_loaded('assets/words'),
  word(Word),
  string_chars(Word, Letters),
  length(Letters, Score),
  cover(Letters, List).

% Kijkt of er een solution gevonden kan worden met de lengte van het aantal
% gegeven karakters, anders probeert hij het voor minder karakters
topsolution([], _, 0).
topsolution(List, Word, Score) :-
  length(List, TargetScore),
  topsolution(List, Word, Score, TargetScore).
topsolution(List, Word, Score, TargetScore) :-
  write("Finding word of "), write(TargetScore), write(" characters..."), nl,
  solution(List, Word, TargetScore) ->
  (
    string_chars(Word, Letters),
    length(Letters, Score)
  ) ; (
    Target is TargetScore - 1,
    topsolution(List, Word, Score, Target)
  ).

% ?- topsolution([y,c,a,l,b,e,o,s,x], Word, Score).
% Finding word of 9 characters...
% Finding word of 8 characters...
% Finding word of 7 characters...
% Word = calyxes,
% Score = 7.

% ?- topsolution([f,e,e,l,s,g,o,o,d,m,a,n], Word, Score).
% Finding word of 12 characters...
% Finding word of 11 characters...
% Finding word of 10 characters...
% Word = fondlesome,
% Score = 10.

% ?- topsolution([a, c, e, g, i, k, m, a, z], Word, Score).
% Finding word of 9 characters...
% Finding word of 8 characters...
% Finding word of 7 characters...
% Finding word of 6 characters...
% Word = agamic,
% Score = 6.

/*
|-------------------------------------------------------------------------------
| Opg 2 - Hopelijk weet je nog de wortelformule van de wiskundelessen
| op school.
|-------------------------------------------------------------------------------
*/

solveQuadratic([A, B, C], [Zero1|Zero2]) :-
  Discriminant is B**2 - 4 * A * C,
  Discriminant >= 0,
  sqrt(Discriminant, Root),
  Zero1 is (- B + Root) / (2*A),
  Zero2 is (- B - Root) / (2*A).

/*
|-------------------------------------------------------------------------------
| Opg 3 - Een wiskundige vergelijking die je misschien nog niet kende.
|-------------------------------------------------------------------------------
*/

% Oefenopdracht, implementatie faculteit berekenen
fac(N, R) :-
  N > 1,
  N1 is N - 1,
  fac(N1, R1),
  R is R1 * N.
fac(_, 1).

% Recursief wordt N keer de inverse faculteit berekend
sumInvFacs(N, R) :-
  N > 0,
  N1 is N - 1,
  sumInvFacs(N1, R1),
  fac(N, Fac),
  R is 1 / Fac + R1.
sumInvFacs(_, 1).

sumInvFacsLimit(_, _) :-
  write("Deze opdracht is iets te onduidelijk.").

/*
|-------------------------------------------------------------------------------
| Opg 4 - De zogenaamde zeef van Eratosthenes is een bekende methode om de
| verzameling van priemgetallen onder een gegeven getal n te berekenen.
|-------------------------------------------------------------------------------
*/

% Maakt een lijst met N integers vanaf 2 en roept de filter aan om vervolgens
% het resultaat te tonen
primes(N) :-
  findall(Num, between(2, N, Num), List),
  eratosthenesFilter(List, N, Result),
  write("Primes: "),
  print(Result).

% Roept voor elke prime P het filterpredikaat aan
eratosthenesFilter([P|T], N, [P|Result]) :-
  P > 1,
  P**2 < N,
  filterMultiples(P, T, Filtered),
  eratosthenesFilter(Filtered, N, Result).
eratosthenesFilter([], _, []).

% Filter alle integers die gedeeld kunnen worden door prime P
filterMultiples(_, [], []).
filterMultiples(P, [H|T], [H|Filtered]) :-
  H mod P =\= 0,
  filterMultiples(P, T, Filtered).
filterMultiples(P, [_|T], Filtered) :-
  filterMultiples(P, T, Filtered).
