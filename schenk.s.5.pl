% PSS Huiswerk 5
% 10-10-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|	Helper
*/
remove_all(_, [], []).
remove_all(Element, [Element|Tail], Result) :-
  remove_all(Element, Tail, Result).
remove_all(Element, [Head|Tail], [Head|Result]) :-
  remove_all(Element, Tail, Result).

/*
|-------------------------------------------------------------------------------
| Opg 1
|-------------------------------------------------------------------------------
*/

:- writeln('-------------------------').
:- writeln('Type "go." to start').
:- writeln('-------------------------').

% Asserts a code where the first digit is nonzero.
draw() :-
	random_between(10000, 99999, Code),
	retractall(code(_)),
	assert(code(Code)),
	write_code(Code).

% Writes the code in a stylish fashion.
write_code(Code) :-
	write("********************"), nl,
	write("De code: "), write(Code), nl,
	write("********************"), nl.

/*
|-------------------------------------------------------------------------------
| Opg 2
|-------------------------------------------------------------------------------
*/

% Convert code to list.
string_chars(Atom, List) :-
	atom_chars(Atom, List).

% Calculate x-score.
scorex(N, X) :-
	code(Code),
	string_chars(Code, ListCode),
	string_chars(N, NN),
	scorex(NN, ListCode, X).
scorex([], [], 0).
scorex([H|T1], [H|T2], X) :-
	scorex(T1, T2, XX), !,
	X is XX + 1.
scorex([_|T1], [_|T2], X):-
	scorex(T1, T2, X).

% Calculate o-score.
scoreo(N, O) :-
	code(Code),
	string_chars(Code, ListCode),
	string_chars(N, NN),
	scoreo(NN, ListCode, OO),
	scorex(NN, ListCode, X),
	O is OO - X.
scoreo([], _, 0).
scoreo([H|T1], T2, O) :-
	member(H, T2),
	remove_all(H, T2, T2N), !,
	scoreo(T1, T2N, OO),
	O is OO + 1.
scoreo([_|T1], T2, O) :-
	scoreo(T1, T2, O).

/*
|-------------------------------------------------------------------------------
| Opg 3
|-------------------------------------------------------------------------------
*/

% Print alle mogelijke combinaties.
all_codes(Poss) :-
	findall(Guess, guess(Guess), Poss).

guess(Code) :-
    subList(5, Code, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).

% guess/1: Neem een lijst van 4 elementen uit de lijst van alle kleuren.


subList(0, [], _).
subList(N, [Head|Tail], List):-
    NN is N - 1,
    select(Head, List, Rest),
    subList(NN, Tail, Rest).

% subList/3: subList(+Number, -SubList, +List). Haal een deellijst
% (-SubList) van +Number elementen uit een gegeven +List.




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



/*
|-------------------------------------------------------------------------------
| Opg 4
|-------------------------------------------------------------------------------
*/

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


/*
|-------------------------------------------------------------------------------
| Opg 5
|-------------------------------------------------------------------------------
*/


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


% go/0: voor een simpele aanroep van het spel.
go :-
	random_code(Code),
	write_code(Code),
	all_codes(Poss),
	trials(Code,Poss,_).

