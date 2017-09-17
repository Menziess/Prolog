% PSS Huiswerk 2
% 13-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com


/*
|--------------------------------------------------------------------------
| Opg 1 - Ulle Endriss: opg. 3.14. Hoe kan je de beste kandidaat in een 
| quiz over het vinden van woorden verslaan? 
|--------------------------------------------------------------------------
| topsolution should start at the highest possible score.
| Explain solution with 3 lists.
*/

% Predicaat uit assignment 1
remove_first(_, [], []).                                                      
remove_first(Element, [Element|Tail], Tail).
remove_first(Element, [Head|Tail], [Head|Result]) :-
  remove_first(Element, Tail, Result). 

cover([], _).
cover([H|T], List) :-               
  member(H, List),                      % Als het element in de lijst zit
  remove_first(H, List, Remainder), !,  % Verwijder het
  cover(T, Remainder).                  % Ga door met het volgende element.

solution(List, Word, Score) :-
  ensure_loaded('assets/words'),        % Laadt de words 1 keer
  word(Word),                           % We zoeken een woord
  string_chars(Word, Letters),          % Van dat woord hebben we de letters nodig
  length(Letters, Score),               % Letters moet gelijk zijn aan de Score
  cover(Letters, List).                 % De letters moeten in de lijst voor komen

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
|--------------------------------------------------------------------------
| Opg 2 - Hopelijk weet je nog de wortelformule van de wiskundelessen 
| op school.
|--------------------------------------------------------------------------
| ax2 + bx + c heeft — indien b^2 - 4ac ≥ 0 — zijn nulpunten in x1 en x2 in
| de formule (-b +/- sqrt(b^2 - 4ac)) / 2a
*/

solveQuadratic([A, B, C], [Zero1|Zero2]) :-   % Coefficienten en Resultaat
  Discriminant is B**2 - 4 * A * C,           % De discriminant wordt berekend
  Discriminant >= 0,                          % Is deze groter dan nul?
  sqrt(Discriminant, Root),                   
  Zero1 is (- B + Root) / (2*A),              % Twee mogelijke resultaten worden berekend
  Zero2 is (- B - Root) / (2*A).

/*
|--------------------------------------------------------------------------
| Opg 3 - Een wiskundige vergelijking die je misschien nog niet kende.
|--------------------------------------------------------------------------
| 1/0! + 1/1! + ... + 1/n!
*/

fac(N, R) :-          % Oefenopdracht, implementatie faculteit berekenen
  N > 1,
  N1 is N - 1,
  fac(N1, R1),
  R is R1 * N.
fac(_, 1).

sumInvFacs(N, R) :-   % Recursief wordt N keer de inverse faculteit berekend
  N > 0,
  N1 is N - 1,
  sumInvFacs(N1, R1),
  fac(N, Fac),
  R is 1 / Fac + R1.
sumInvFacs(_, 1).     % 1/0! is 1/1 is gelijk aan 1

sumInvFacsLimit(_, _) :-
  write("Deze opdracht is onduidelijk.").

/*
|--------------------------------------------------------------------------
| Opg 4 - De zogenaamde zeef van Eratosthenes is een bekende methode om de 
| verzameling van priemgetallen onder een gegeven getal n te berekenen.
|--------------------------------------------------------------------------
|
*/

primes(N) :-
  findall(Num, between(2, N, Num), List),     % Generate list of consecutive numbers
  eratosthenesFilter(List, N, Result),        % Filter list to reveal all primes
  write("Primes: "), 
  print(Result).

eratosthenesFilter([P|T], N, [P|Result]) :-
  P > 1,                                      % First number must be greater than 1
  P**2 < N,                                   % Square of prime smaller than N
  filterMultiples(P, T, Filtered),            % Filter list for particular prime P
  eratosthenesFilter(Filtered, N, Result).    % Perform recursively for all P's
eratosthenesFilter([], _, []).

filterMultiples(_, [], []).                   % Base case
filterMultiples(P, [H|T], [H|Filtered]) :-    % Keep the first element in the result
  H mod P =\= 0,                              % If the first element is not divisible by the prime P
  filterMultiples(P, T, Filtered).            % Filter rest of the list
filterMultiples(P, [_|T], Filtered) :-        % Else if element is divisible, it is not prime
  filterMultiples(P, T, Filtered).            % So it gets discarded and the recursion continues
