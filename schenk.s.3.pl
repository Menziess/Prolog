% PSS Huiswerk 3
% 19-09-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com



/*

  Beste Mattijs,

  Bij de vorige opgave kreeg ik deze feedback:

  "
    # Opgave 4:
    ?- primes(30).
    Primes: [2,3,5]
    true .
    Dit zijn helaas niet alle priemgetallen onder de 30
    Exit: (11) filterMultiples(5, [7, 11, 13, 17, 19, 23, 25, 29], [11, 17]) ? creep
    De lijst rest zit wel ergens in je code maar moet nog teruggegeven. Het zou
    fijn als dergelijk gedrag ook terug is te vinden in je commentaar.
  "

  In de opgave staat dat bij een voorbeeld met n=30; de procedure moet stoppen
  zodra k**2 > n. Dit zorgt er dus voor dat er maar 3 priemgetallen worden
  gevonden: 2, 3 en 5. Omdat bij k=7, k**2 >= 30.

  Als ik de opdracht verkeerd heb begrepen, my bad. Maar na de opdracht opnieuw
  gelezen te hebben, lijkt mij dat dit juist wordt gevraagd.

*/

/*
|-------------------------------------------------------------------------------
| Opg 1 - Implementeer een Prolog-predicaat random_code/1 .
|-------------------------------------------------------------------------------
*/

% Alle kleuren.

color(rood).
color(oranje).
color(geel).
color(blauw).
color(groen).
color(bruin).
colors(X) :-
  findall(Y, color(Y), X).

% Een code bestaat uit een combinatie van 4 verschillende getallen van 0 tot en
% met 5. De zes verschillende getallen in een lijst worden geschuffled, daarna
% wordt met behulp van de combinatie append en een lijst van 2 elementen, de
% laaste 4 elementen uit de lijst opgehaald.

random_code(R) :-
  colors(Colors),
  random_permutation(Colors, List),
  length(Pre, 2),
  append(Pre, R, List).


/*
|-------------------------------------------------------------------------------
| Opg 2 - Implementeer een Prolog-predicaat all_codes/1 .
|-------------------------------------------------------------------------------
*/

% De rule colorCombo zorgt dat de verschillende variabelen verschillend zijn.

colorCombo([W, X, Y, Z]) :-
  color(W),
  color(X),
  color(Y),
  color(Z),
  \+ W = X, \+ W = Y, \+ W = Z,
  \+ Y = X, \+ Y = Z,
  \+ Z = X.

% De totale hoeveelheid mogelijkheden zou moeten zijn: 6 * 5 * 4 * 3 = 360.

all_codes(R) :-
  findall([C1, C2, C3, C4], colorCombo([C1, C2, C3, C4]), R),
  length(R, Length),
  write("Amount of possible combinations: "), write(Length).


/*
|-------------------------------------------------------------------------------
| Opg 3 - Implementeer een Prolog-predicaat evaluate_trial/3.
|-------------------------------------------------------------------------------
*/

% De originele code wordt meegegeven om te kunnen checken of de head van de
% poging zich bevind in de code in het predikaat evaluate_trial/4.

evaluate_trial(Code, Attempt, Eval) :-
  evaluate_trial(Code, Code, Attempt, Eval).

% Als de kleur goed is wordt er een 'x' in de Evaluation gezet, als de kleur
% zich in de code bevind wordt er een 'o' in gezet, en anders een 'wrong'.

evaluate_trial([], _, [], []).
evaluate_trial([H|T], O, [H|T1], [x|Eval]) :-
  evaluate_trial( T,  O, T1, Eval).

evaluate_trial([_|T], O, [H|T1], [o|Eval]) :-
  member(H, O),
  evaluate_trial( T,  O, T1, Eval), !.

evaluate_trial([_|T], O, [_|T1], [wrong|Eval]) :-
  evaluate_trial( T,  O, T1, Eval), !.


/*
|-------------------------------------------------------------------------------
| Opg 4 - Implementeer een Prolog-predicaat update/4.
|-------------------------------------------------------------------------------
*/

%
update(Code, PrePossibilities, Attempt, PostPossibilities) :-
  write()

trials() :-
print(lol).
