%
%    Uitwerkingen Oefenopgaven Week 2 aflevering 2, 13/9/17
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Opg.1
%



remove_first(_, [], []).
remove_first(X, [X|T], T).
remove_first(X, [Y|T], [Y|NT]):-
    remove_first(X, T, NT).

% Deze opgave van het vorige huiswerk komt goed van pas.

cover([], _).
cover([H|T], L):-
    member(H, L),
    remove_first(H, L, NL),
    cover(T, NL).

% cover/2 is nou simpel. Basis: de lege lijst past overal in.
% Recursie: Een lijst past helemaal in L als de head H een element is
% van L en (rec.) de tail T past in L met H (1x) daaruit verwijderd.
% Je had hier ook select/3 (built-in) kunnen gebruiken.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Opg.2
%

removeMultiples(_, [], []).
removeMultiples(N, [H|T], L):-
    H mod N =:= 0,
    H > N,
    removeMultiples(N, T, L), !.
removeMultiples(N, [H|T], [H|NT]):-
    removeMultiples(N, T, NT).

% Basis: verwijderen van veelvouden uit de lege lijst levert weer een
% lege lijst.
% Recursie: indien de head H een veelvoud is van N dan moet H niet in
% het eindresultaat komen, en anders wel.


removeHeadMultiples([H|T], L):-
    removeMultiples(H, [H|T], L).

% Spreekt voor zich.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Opg. 3
%

firstDiv(N, Div):-
    firstDiv(N, Div, 2).

firstDiv(N, Div, Counter):-
    N mod Counter =\= 0,
    CounterPlusOne is Counter + 1,
    firstDiv(N, Div, CounterPlusOne).

firstDiv(N, Div, Div):-
    N mod Div =:= 0.



% Dit is ingewikkelder, maar het idee werd al besproken bij
% het hoorcollege van 12/9: Je wilt het kleinste positieve gehele getal
% vinden met een bepaalde eigenschap. Dit doe je door een extra argument
% toe te voegen aan een predicaat, in dit geval firstDiv. Daarmee
% mee krijg je een nieuw predicaat firstDiv/3 (Prolog onderscheidt die
% netjes van elkaar: het zijn twee verschillende predicaten. Indien je
% dit verwarrend vind dan had je ook een nieuwe naam voor dit predicaat
% kunnen kiezen).
%
% Dit nieuwe argument is de zogenaamde teller (Counter). Er wordt gekeken of
% Counter de gewenste eigenschap heeft. In dat geval is dat een test of
% Counter een echte deler is van N. Als dit niet het geval is (eerste
% clause van firstDiv) dan hogen we de Counter op met 1 (CounterPlusOne)
% en herhalen de procedure. Als Counter wel een echte deler is van N dan
% melden we het resultaat in het tweede argument (Counter = Div): de
% Counter is dan de kleinste echte deler die groter dan of gelijk is aan
% de waarde waarmee je bent begonnen.
%
% Bij de aanroep van firstDiv/2 zorg je er dan voor dat de
% start-waarde goed gekozen is. In ons geval is dat het getal 2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opg. 4
%
%

invExp2(N, InvExp2):-
    InvExp2 is 1/(2 ** N).

% De waarde van de indivuele sommanten.

sumInvExp2(0, Start):-
    invExp2(0, Start).
sumInvExp2(N, Sum):-
    integer(N), N > 0,
    NN  is N - 1,
    sumInvExp2(NN, SSum),
    invExp2(N, Summant),
    Sum is Summant + SSum.

% Basis: bereken de eerste sommant.
% Recursie: tel de (N+1)-de sommant op bij het resultaat dat je krijgt
% bij de som van de eerste N sommanten.

boundedSumInvExp2(End, EndSum):-
    boundedSumInvExp2(0, End, 0, EndSum).

boundedSumInvExp2(Counter, End, Sum, EndSum):-
    %integer(Begin), integer(End),
    invExp2(Counter, Summant),
    NewSum is Sum + Summant,
    NewSum =\= Sum,
    NextCounter is Counter + 1,
    boundedSumInvExp2(NextCounter, End, NewSum, EndSum).
boundedSumInvExp2(End, End, EndSum, EndSum).



% Hier gebruiken we een soortgelijke techniek als bij opgave 3.
% We hanteren nu twee extra argumenten: een om de teller steeds 1 op te
% hogen, en de ander om het tussenresultaat van de optellingen (Sum)
% te registreren. Tenslotte hebben we deze steeds nodig om te kijken of
% we nog wel moeten doorgaan met optellen.
%
% boundedSumInvExp2/2 roept boundedSumInvExp2/4 aan met de teller op 0
% gezet en ook in de som zit nog niks (0). We gebruiken dus hier het
% eerste argument van boundedSumInvExp2/4 voor de teller, en het derde
% voor de som. In de eerste clause gebeurt nu het werk. Eerst wordt de
% sommant (Summant) voor Counter berekend. De nieuwe som (NewSum) is
% niets anders dan het optellen van Sum en Summant.
%
% Als er van een
% rekenkundig verschil sprake is tussen NewSum en Sum dan heeft de
% laatste optelling dus nog een effect. In dat geval gaan we door. We
% hogen de teller op (NextCounter) en herhalen de procedure door
% boundedSumInvExp2/4 recursief aan te roepen.
%
% De recursie stopt als de test NewSum =\= Sum faalt. De sommant is dan
% verwaarloosbaar klein. We melden dan de Counter-waarde in het tweede
% argument (Counter = End) en de Sum in het vierde argument (Sum =
% EndSum).
%
% SWI-Prolog op mijn Mac stopt bij 54 optellingen en meldt netjes 2.0
% als som.


invExp(G, N, InvExp):-
    InvExp is 1/(G ** N).

boundedSumInvExp(G, End, EndSum):-
    boundedSumInvExp(G, 0, End, 0, EndSum).

boundedSumInvExp(G, Counter, End, Sum, EndSum):-
    %integer(Begin), integer(End),
    invExp(G, Counter, Summant),
    NewSum is Sum + Summant,
    NewSum =\= Sum,
    NextCounter is Counter + 1,
    boundedSumInvExp(G, NextCounter, End, NewSum, EndSum).
boundedSumInvExp(_, End, End, EndSum, EndSum).

% Toegift: analoog aan hierboven met 2 vervangen door een variabel getal
% (G, geplaatst als extra - eerste - argument). Je krijgt nu voor
% G=3 het antwoord op vraag c. Als het goed is krijgt voor G = 3 de
% eindsom de waarde 1.5 (of iets daar net onder). I.h.a. is de limiet
% van de som gelijk aan G/(G-1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%















