% Huiswerk week 3 Jim Kamans
nth_select(1, [H|T], H, T):- !.
nth_select(N, [H|T], Elem, [H|T2]):-
    NN is N - 1,
    nth_select(NN, T, Elem, T2).

drawMember(List, Elem, Rest):-
    length(List, Length),
    Rand is random(Length) + 1,
    nth_select(Rand, List, Elem, Rest).

% Opg. 1
colors(Colors):-
    Colors = ["red", "blue", "green", "yellow", "orange", "brown"].

random_code(X):-
    colors(Colors),
    CodeLength = 4,
    random_code(CodeLength, Colors, X).

random_code(0, _, []):- !.
random_code(K, Colors, [Color|NextColor]):-
    length(Colors, Length),
    Rand is random(Length) + 1,
    nth_select(Rand, Colors, Color, LessColors),
    KK is K - 1,
    random_code(KK, LessColors, NextColor).

% Opg. 2
all_codes(Codes):-
    colors(Colors),
    Template = [X1, X2, X3, X4],
    Goal = (member(X1, Colors),
            member(X2, Colors),
            member(X3, Colors),
            member(X4, Colors),
            X1 \= X2,
            X1 \= X3,
            X1 \= X4,
            X2 \= X3,
            X2 \= X4,
            X3 \= X4
           ),
    setof(Template, Goal, Codes).

% Opg. 3
evaluate_trial(TheCode, Guess, Result):-
    evaluate(TheCode, Guess, Xs, Os),
    append(Xs, Os, Result).

evaluate(_, [], [], []):- !.
evaluate([H|T], [H|T2], [x|T3], Os):-
    !,
    evaluate(T, T2, T3, Os).
evaluate(CodeColors, [H|T], Xs, [o|T2]):-
    member(H, CodeColors),
    !,
    evaluate(CodeColors, T, Xs, T2).
evaluate(CodeColors, [_|T], X2, Os):-
    evaluate(CodeColors, T, X2, Os).

%Opg. 4
update(TheCode, PossibleCodes, Guess, RemainingPossibleCodes):-
    evaluate_trial(TheCode, Guess, Pins),
    write(Guess), write(Pins), nl,
    Goal = (member(PossibleCode, PossibleCodes),
            evaluate_trial(PossibleCode, Guess, Pins)
           ),
    findall(PossibleCode, Goal, RemainingPossibleCodes).

%Opg. 5
trials():-
    all_codes(AllCodes),
    random_code(TheCode),
    write(--------------------------------), nl,
    write("Secret code = "), write(TheCode), nl,
    write(--------------------------------), nl,
    nl,
    guess(TheCode, AllCodes).

guess(TheCode, [TheCode]):- !.
guess(TheCode, PossibleCodes):-
    drawMember(PossibleCodes, Guess, _),
    update(TheCode, PossibleCodes, Guess, RemainingPossibleCodes),
    guess(TheCode, RemainingPossibleCodes).
