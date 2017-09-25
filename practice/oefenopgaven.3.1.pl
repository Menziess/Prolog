%
%    Uitwerkingen Oefenopgaven Week 3 19/9/17
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------Opg. 3--------------------------------

%------------ remove_first/3


remove_first(_, [], []).          % (1)
remove_first(X, [X|T], T).        % (2)
remove_first(X, [Y|T], [Y|NT]):-  % (3)
    remove_first(X, T, NT).

% Choice-points: matching op het tweede argument (de ingevoerde lijst)
% voor lijsten waarvan het eerste element gelijk is aan het te
% verwijderen element (X, 1ste arg). Zowel (2) als (3) is dan van
% toepassing. Prolog zal in eerste instantie daarvan geen last hebben
% omdat hij immers altijd bovenaan begint en (2) zal toepassen op het
% keuzepunt.
%
% Dit geeft bij  backtracking onjuiste aanroep van de recursieve
% regel. Het is immers niet vereist dat X ongelijk is aan Y in (3). Door
% een ! te plaatsen in de body van (2) zal backtracking na een
% succesvolle match met (2) niet meer plaatsvinden. Hieronder een kopie
% van remove_first/3 m.b.v. removeFirst/3 met een ! op de juiste plek.
%
% removeFirst/3 hieronder is de 'gesneden' versie:


removeFirst(_, [], []).
removeFirst(X, [X|T], T):-
    !.
removeFirst(X, [Y|T], [Y|NT]):-
    remove_first(X, T, NT).

% Ter illustratie:
%
% ?- remove_first(1,[1,2,1,3], L).
% L = [2, 1, 3] ;
% L = [1, 2, 3] ;
% L = [1, 2, 1, 3] ;
% false.
%
% ?- removeFirst(1,[1,2,1,3], L).
% L = [2, 1, 3].


%---------------- remove_last/3


remove_last(X, [Y|T], [Y|NT]):-   % (1)
    member(X, T),
    remove_last(X, T, NT).
remove_last(X, [X|T], T).         % (2)
remove_last(_, L, L).             % (3)

% Dit is de kortere versie die we bij het hoorcollege van woe 13/9
% hebben besproken. Zie voor een Proof Search Tree ook de Slides van dat
% college. Hier hebben we zelfs te maken met keuzepunten met drie keuzes
% ((3) is wel heel algemeen). Nogmaals, het werkt allemaal dankzij
% voor het eerste antwoord door het feit dat Prolog eerst bovenaan
% begint.
%
% Onjuiste backtrackings-resultaten zijn nu eenvoudig te verhelpen met
% twee !'s:

removeLast(X, [Y|T], [Y|NT]):-   % (1)
    member(X, T),
    !,
    removeLast(X, T, NT).
removeLast(X, [X|T], T):-        % (2)
    !.
removeLast(_, L, L).             % (3)

% De eerste ! in (1) is niet voldoende, omdat dan nog steeds het
% keuzepunt (2,3) blijft bestaan voor het moment dat de te verwijderen
% (laatste) X wordt aangetroffen.


%-------------- remove_all/3

% Voor remove_all/3  is het !-en nu makkelijk:

remove_all(_, [], []).
remove_all(X, [X|T], L):-
    remove_all(X, T, L).
remove_all(X, [Y|T], [Y|NT]):-
    remove_all(X, T, NT).

removeAll(_, [], []).
removeAll(X, [X|T], L):-
    !,
    removeAll(X, T, L).
removeAll(X, [Y|T], [Y|NT]):-
    removeAll(X, T, NT).

%------------ remove_list/3

% Bij remove_list lijkt geen ! nodig. We moeten alleen geen
% backtracking krijgen door de aanroep van remove_all in remove_list,
% die wel foute antwoorden na backtracking levert. En daardoor krijg je
% eventueel ook foute antwoorden na backtracken op remove_list. Je
% kan dat nu natuurlijk oplossen door aanroep van de nieuwe removeAll/3.
% Een andere mogelijkheid is de volgende simpele aanpassing met een !:

remove_list([], L, L).
remove_list([X|T], L, NL):-
    remove_all(X, L, LminusX),
    remove_list(T, LminusX, NL).

removeList([], L, L).
removeList([X|T], L, NL):-
    remove_all(X, L, LminusX),
    !,
    removeList(T, LminusX, NL).

% intersect/3 is nu te helpen mbv twee incisies. Dit is identiek aan het
% geval van remove_last (choice points met 3 opties).

%---------------- intersect

intersect([], _, []).
intersect([H|T], L, NL):-
    member(H,T),
    intersect(T, L, NL).
intersect([H|T], L, [H|NT]):-
    member(H,L),
    intersect(T, L, NT).
intersect([_|T], L, NL):-
    intersect(T, L, NL).

%--------------- interSect


interSect([], _, []).
interSect([H|T], L, NL):-
    member(H,T),!,
    interSect(T, L, NL).
interSect([H|T], L, [H|NT]):-
    member(H,L), !,
    interSect(T, L, NT).
interSect([_|T], L, NL):-
    interSect(T, L, NL).

%----------------- Opg. 4 --------------------------------------


selekt(X, [X|T], [], T).
selekt(X, [Y|T], [Y|NT1], Rest):-
    selekt(X, T, NT1, Rest).

% selekt/4 neemt een element X uit de lijst en levert in het derde
% argument de lijst van elementen die voor X voorkwamen, en in het
% vierde die erna voorkwamen. Dit predicaat helpt om zo efficient
% mogelijk sublijsten te genereren.


subList(0, [], _).
subList(N, [Head|Tail], List):-
    NN is N-1,
    selekt(Head, List, _, Rest),
    subList(NN, Tail, Rest).

% subList/3 geeft een sublist van N elementen van een lijst als
% gegeven in het tweede argument. De sublist
% zal altijd de volgorde van de elementen als gegeven in de
% oorspronkelijke lijst hanteren. Dit om te voorkomen dat uiteindelijk
% ook permutaties worden opgesomd.


aantalZetelsPartij(Partij, 1, Aantal):-
    zetels(Partij, Aantal, _).
aantalZetelsPartij(Partij, 2, Aantal):-
    zetels(Partij, _, Aantal).

aantalZetelsCoalitie([], _, 0).
aantalZetelsCoalitie([Head|Tail], Kamer, Aantal):-
    aantalZetelsPartij(Head, Kamer, AantalHead),
    aantalZetelsCoalitie(Tail, Kamer, AantalTail),
    Aantal is AantalHead + AantalTail.


meerderheidInBeideKamers(Partijen):-
    aantalZetelsCoalitie(Partijen, 1, A1),
    aantalZetelsCoalitie(Partijen, 2, A2),
    A1 > 37,
    A2 > 75.

coalitie(Coalitie):-
    findall(Partij, zetels(Partij, _, _), Partijen),
    subList(4, Coalitie, Partijen),
    meerderheidInBeideKamers(Coalitie).

% Verzamel alle partijen, neem een sublist met vier partijen en
% beoordeel of de meerderheid hebben in beide kamers.

coalities(Coalities):-
    findall(C, coalitie(C), Coalities).

% Alle mogelijk coalities ook nog in een lijst (Coalities).

%------------------Opg. 5--------------------------------

in_word(String, Word):-
    string_chars(String, Chars),
    word(Word),
    string_chars(Word, Letters),
    cover(Letters, Chars).

cover(_, []).
cover(L, [H|T]):-
    select(H, L, R),
    cover(R, T).

% Deze hadden we nog van de vorige keer.

opg5(Words):- findall(Word, in_word(abcdefg, Word), Words).

% Als het goed is geeft dit een lijst met 1 element:
%
% ?- opg5(Words).
% Words = [blackfigured].


