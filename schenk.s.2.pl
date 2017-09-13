% PSS Huiswerk 2
% 13-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com


/*
|--------------------------------------------------------------------------
| Opg 1 - Ulle Endriss: opg. 3.14. Hoe kan je de beste kandidaat in een 
| quiz over het vinden van woorden verslaan? 
|--------------------------------------------------------------------------
| 
*/

cover([], _).
cover([H|T], List) :- 
  member(H, List),                  % Checks if element is covered by List
  cover(T, List).     

solution(List, Word, Score) :-
  ensure_loaded('assets/words'),    % Laadt de words 1 keer
  word(Word),                       % We zoeken een woord
  string_chars(Word, Letters),      % Van dat woord hebben we de letters nodig
  length(Letters, Score),           % Letters moet gelijk zijn aan de Score
  cover(Letters, List).             % De letters moeten in de lijst voor komen

topsolution([], _, 0).
topsolution(List, Word, Score) :-
  solution(List, Word, Score).

% Example: [y,c,a,l,b,e,o,s,x]

/*
|--------------------------------------------------------------------------
| Opg 2 - Hopelijk weet je nog de wortelformule van de wiskundelessen 
| op school.
|--------------------------------------------------------------------------
| ax2 + bx + c heeft — indien b^2 - 4ac ≥ 0 — zijn nulpunten in x1 en x2 in
| de formule (-b +/- sqrt(b^2 - 4ac)) / 2a
*/

% solveQuadratic/2 
% eerste argument een lijst met de gegeven coefficienten zijn (a, b en c) en
% het tweede argument de uitkomst in de vorm van een lijst met 2, 1 of 0 
% elementen die de nulpunten weergeven.

/*
|--------------------------------------------------------------------------
| Opg 3 - 
|--------------------------------------------------------------------------
| 1/0! + 1/1! + ... + 1/n!
*/

% a) t sumInvFacs/2 

% b) Het resultaat van hierboven is nog niet wat we willen. Toch is de 
% sommatie al redelijk dicht tot e genaderd. Dit kan je controleren door de 
% volgende query:

% ?- S is e - 8/3. 
% S = 0.05161516179237857

% De benadering gaat zelfs zo snel dat een beperkt aantal keer het optellen 
% van nieuwe sommanten 1 k! geen eﬀect meer heeft. Met andere woorden 
% Prolog kan geen verschil meer meten tussen

/*
|--------------------------------------------------------------------------
| Opg 4 - De zogenaamde zeef van Eratosthenes is een bekende methode om de 
| verzameling van priemgetallen onder een gegeven getal n te berekenen.
|--------------------------------------------------------------------------
|
*/

% voor n = 30:
% [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29] 
% [2,3,5,7,9,11,13,15,17,19,21,23,25,27,29] 
% [2,3,5,7,11,13,17,19,23,25,29] 
% [2,3,5,7,11,13,17,19,23,29]

% Create array of N integers and start filter
primes(N) :-
  print(N).

% Filter multiples of H from T if H^2 < N
eratosthenesFilter([H|T], N) :-
  H**2 < N,
  filterMultiples(H, T, N1),
  eratosthenesFilter(T, )

filterMultiples(H, T, N1) :-
