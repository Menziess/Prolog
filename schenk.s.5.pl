% PSS Huiswerk 5
% 10-10-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|-------------------------------------------------------------------------------
| Opg 1 -
|-------------------------------------------------------------------------------
*/

:- writeln('-------------------------').
:- writeln('Aanroepen vh spel = ?-go.').
:- writeln('-------------------------').

% ------------ Opg. 1-----------------------------------

random_code(Code):-
    colors(AllColors),
    draw(4, Code, AllColors, _), !.

% Neem 4 random members van de lijst van alle kleuren:

colors([blauw, bruin, geel, groen, oranje, rood]).

% Hulp-predicaten uit de opgaven van dinsdag 19/9
% -----------------------------------------------


nth_select(1, H, [H|T], T):-!.
nth_select(N, Element, [H|T], [H|TRest]):-
    integer(N), N > 0,
    NewN is N-1,
    nth_select(NewN, Element, T, TRest).

% Selecteert het N-de element Element uit de lijst als gegeven in het
% derde argument. In het vierde argument wordt een lijst van de overige
% elementen gegeven (analoog aan de built-in select/3).



drawMember(Element, List, Rest):-
    length(List, Length),
    random(Random),
    RandomNumber is ceiling(Random*Length),
    nth_select(RandomNumber, Element, List, Rest).

% Selecteer een willekeurig element Element uit Lijst List en
% administreer de rest Rest in 3e arg.

draw(0, [], List, List).
draw(N, [Head|Tail], List, Rest):-
    NewN is N-1,
    drawMember(Head, List, Rest1),
    draw(NewN, Tail, Rest1, Rest).

% Analoog, maar dan een willekeurige trekking van N (1st arg.)
% elementen.

% -----------Opg. 2-----------------------------------------

all_codes(Poss):- findall(Guess, guess(Guess), Poss).

guess(Code):-
    colors(AllColors),
    subList(4, Code, AllColors).

% guess/1: Neem een lijst van 4 elementen uit de lijst van alle kleuren.


subList(0, [], _).
subList(N, [Head|Tail], List):-
    NN is N-1,
    select(Head, List, Rest),
    subList(NN, Tail, Rest).

% subList/3: subList(+Number, -SubList, +List). Haal een deellijst
% (-SubList) van +Number elementen uit een gegeven +List.


% ----------Opg. 3----------------------------------------------



evaluate_trial_x([], [], 0).
evaluate_trial_x([H|T1], [H|T2], N):- !,
	evaluate_trial_x(T1, T2, NN),
	N is NN + 1.
evaluate_trial_x([_|T1], [_|T2], N):-
	evaluate_trial_x(T1, T2, N).

% evaluate_trial_x registreert het aantal (3de arg.) goed geplaatste
% kleuren. Het eerste argument is de poging, en het tweede argument de
% te raden code.

evaluate_trial_xo([], _, 0).
evaluate_trial_xo([H|T], L, N):-
	member(H, L),!,
	evaluate_trial_xo(T, L, NN),
	N is NN+1.
evaluate_trial_xo([_|T], L, N):-
	evaluate_trial_xo(T, L, N).

% evaluate_trial_xo registreert het aantal (3de arg.) goede kleuren (x en
% o). Wederom is het eerste argument de te evalueren poging en de tweede
% de te raden code.

evaluate_trial_o(Code, Trial, N):-
	evaluate_trial_xo(Code, Trial, N2),
	evaluate_trial_x(Code, Trial, N1),
	N is N2 - N1.

% evaluate_trial_o registreert het aantal goede kleuren die niet goed
% geplaatst zijn. Dit is eenvoudig te definieren als het verschil tussen
% de resultaten van de twee predicaten hierboven.

evaluate_trial(Code, Trial, Result):-
	evaluate_trial_x(Code, Trial, NX),       % bepaal het aantal x-jes
	evaluate_trial_o(Code, Trial, NO),       % bepaal het aantal o-tjes
	to_list(NX, x, LX),                      % maak een lijst van de x-jes
	to_list(NO ,o, LO),                      % maak een lijst van de o-tjes
	append(LX, LO, Result).                  % voeg samen

% Dit predicaat geeft de totale evaluatie. Het resultaat is een lijstje
% van x'en en o's.

to_list(0, _, []).
to_list(N, X, [X|T]):-
	N > 0,
	NN is N-1,
	to_list(NN,X,T).

% Administratief hulp-predicaat om de x-en o-scores in een lijst te
% zetten.



% ---------------Opg. 4-----------------------------------------

% update/4
%
% Arg. 1 de te raden code.
% Arg. 2 de nog over gebleven mogelijke codes.
% Arg. 3 Nieuwe poging
% Arg  4 de overgebleven codes na de nieuwe poging.

update(_, [], _, []).
update(Code, [H|T], Trial, [H|NT]):-
	evaluate_trial_x(Code, Trial, Xscore),
	evaluate_trial_o(Code, Trial, Oscore),
	evaluate_trial_x(H, Trial, HXscore),
	evaluate_trial_o(H, Trial, HOscore),
	Xscore =:= HXscore,
	Oscore =:= HOscore,!,
	update(Code, T, Trial, NT).
update(Code, [_|T], Trial, L):-
	update(Code, T, Trial, L).



% update/4 bepaalt de nieuwe overgebleven lijst van mogelijkheden op
% grond van het resultaat van de laatste poging.
%
% Basis ([]): als er geen mogelijkheden meer over zijn dan verandert
% geen enkele poging daar iets aan. Dit zal zich niet voordoen, maar we
% hebben hem hier wel nodig als basis van de recursie (het rekenwerk).
%
% Recursie 1 ([H|T], H moet bewaard blijven): H is een mogelijkheid die
% overblijft als Trial dezelfde evaluatie zou krijgen als H de te raden
% code zou zijn.
%
% Recursie 2 ([_|T], de eerste in de lijst moet verwijderd worden): De
% eerste mogelijkheid valt af als Trial een andere evaluatie krijgt als
% H de te raden code zou zijn.
%

%------------Opg. 5----------------------------------------------


% trials/3: Output van pogingen met scores:
%
% Argument 1 = de te raden code
% Argument 2 = lijst van overgebleven mogelijkheden. De speler neemt de
% head van deze lijst als volgende poging.
% Argument 3 = poging plus zijn xo-score (appended).
%
% trials/3 roept uiteindelijk write_colors/3 aan om de lijst van poging
% netjes uit te schrijven.

trials(Code, [Code|_], [CodeWithScore]):-!,
	evaluate_trial(Code, Code, Score),
	append(Code, Score, CodeWithScore),
	write_colors(CodeWithScore), nl.

% Dit is de basis. Als de poging (head van de lijst van overgebleven
% mogelijkheden) gelijk is aan de te raden code dan zijn we klaar.

trials(Code, [Trial|T], [TrialWithScore|TT]):-
	evaluate_trial(Code, Trial, Score),
	append(Trial, Score, TrialWithScore),
	write_colors(TrialWithScore),nl,
	update(Code, [Trial|T], Trial, NewPoss),
	trials(Code, NewPoss, TT).

% De recursie: De poging Trial wordt uitgevoerd en het resultaat met
% score toegevoegd aan de lijst.
%
% Eerst wordt de score Score uitgerekend en samengevoegd met de poging
% Trial. Hierna wordt hij uitgeschreven. Daarna wordt op grond van Trial
% de niewe lijst van mogelijkheden NewPoss uitgerekend met behulp van
% update/4. De recursie is de herhaling van trials toegepast op de
% nieuwe lijst van mogelijkheden NewPoss. De volgende poging zal dus de
% head van deze nieuwe lijst zijn.



%------ Het uitschrijven van de resultaten

% write_colors/1. Schrijft een poging met score uit. Hier simpel
% gekozen met enkele spatie-overslag. Kan mooier, maar laten we de code
% niet langer maken dan nodig.

write_colors([]).
write_colors([H|T]):-
	write(' '),
	write(H),
	write_colors(T).


% write_code/1. De aanhef. Het geven van de te raden code.

write_code(Code):-
	writeln('-------------------------'),
	write_colors(Code),nl,
	writeln('-------------------------').


% go/0: voor een simpele aanroep van het spel.

go:-
	random_code(Code),
	write_code(Code),
	all_codes(Poss),
	trials(Code,Poss,_).

