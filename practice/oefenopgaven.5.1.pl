%******************************************
%
%  Oefenopgaven week 5
%
%******************************************


:- writeln('--------------------------------------------------------------').
:- nl.
:- writeln('Aanroep: ').
:- nl.
:- writeln('?- go(+Algoritme, +#Kanibalen, +#Missionarissen, +#MaxInBoot).').
:- nl.
:- writeln('--------------------------------------------------------------').

%******************************************
%
%  Opg. 1 set_conditions/3
%
%******************************************

:- consult('search.pl').

%******************************************
%
%  Opg. 2 set_conditions/3
%
%******************************************

set_conditions(C, M, P):-
    retractall(numberMaxInBoat(_)),
    retractall(numberOfCanibals(_)),
    retractall(numberOfMissionaries(_)),
    assert(numberMaxInBoat(P)),
    assert(numberOfCanibals(C)),
    assert(numberOfMissionaries(M)).

%******************************************
%
%  Opg. 3 dangerous
%
%******************************************

dangerous(C, M):-
    M > 0,
    C > M.


%******************************************
%
%  Opg. 4 cargo/0
%
%******************************************

cargo:-
    numberOfCanibals(C),
    numberOfMissionaries(M),
    makeNumberList(C, CL),
    makeNumberList(M, ML),
    findall(NC/NM, (member(NC, CL), member(NM, ML), cargo(NC, NM)), PL),
    retractall(passengerList(_)),
    assert(passengerList(PL)).

cargo(C, M):-
    C + M > 0,           % Iemand moet de boot besturen!
    \+ dangerous(C, M),
    numberMaxInBoat(P),
    C + M < P+1.

% cargo/2 geeft aantal kanibalen en missionarissen voor een toelaatbare
% bootlading.


numberList(0, [0]).
numberList(N, [N|T]):-
    N > 0,
    NN is N-1,
    numberList(NN, T).

makeNumberList(N, L):-
    numberList(N, RL),
    reverse(RL, L).

% makeNumberList/2: hulp-predicaat voor het maken van lijsten
% L = [0,...,N].

%******************************************
%
%  Opg. 5 start/1 en goal/1
%
%******************************************

start(node(C, M, 0, 0, wal)):-
    numberOfCanibals(C),
    numberOfMissionaries(M).
goal(node(0, 0, C, M, overkant)):-
    numberOfCanibals(C),
    numberOfMissionaries(M).

% De toestanden (nodes) worden opgeslagen in
% een predicaat node/5 met
% Arg 1 = Aantal kanibalen aan de wal.
% Arg 2 = Aantal missionarissen aan de wal.
% Arg 3 = Aantal kanibalen aan de overkant.
% Arg 4 = Aantal missionarissen aan de overkant.
% Arg 5 = Ligging van de boot = wal/overkant.


%******************************************
%
%  Opg. 6 trip/4
%
%******************************************


trip(NC, NM, Node, NextNode):-
    Node = node(CW, MW, CO, MO, wal),
    CW > NC-1,
    MW > NM-1,
    NewCW is CW - NC,
    NewCO is CO + NC,
    NewMW is MW - NM,
    NewMO is MO + NM,
    NextNode = node(NewCW, NewMW, NewCO, NewMO, overkant).

trip(NC, NM, Node, NextNode):-
    Node = node(CW, MW, CO, MO, overkant),
    CO > NC-1,
    MO > NM-1,
    NewCO is CO - NC,
    NewCW is CW + NC,
    NewMO is MO - NM,
    NewMW is MW + NM,
    NextNode = node(NewCW, NewMW, NewCO, NewMO, wal).

%******************************************
%
%  Opg. 7 move/2
%
%******************************************

move(Node, NextNode):-
    passengerList(P),
    member(NC/NM, P),
    trip(NC, NM, Node, NextNode),
    \+ danger(NextNode).


danger(node(CW, MW, _, _, _)):-
    dangerous(CW, MW).
danger(node(_, _, CO, MO, _)):-
    dangerous(CO, MO).




%******************************************
%
%  Opg. 8 go/4
%
%******************************************



go(Algorithm, NCanibals, NMissionaries, MaxPassengers):-
    set_conditions(NCanibals, NMissionaries, MaxPassengers),
    cargo,
    start(Node),
    Search =.. [Algorithm, Node, Path],
    call(Search),
    nl, writePath(Path), nl,
    write('Aantal trips = '),
    length(Path, Length),
    Trips is Length-1,
    writeln(Trips).


%******************************************
%
%  Print Service
%
%******************************************



writeChars(_ , 0).
writeChars(Char, N):-
    N > 0,
    write(Char),
    NN is N-1,
    writeChars(Char, NN).

% Print karakter Char N maal.

writeKant(C, M):-
   numberOfCanibals(MaxC),
   numberOfMissionaries(MaxM),
   SpacesC is MaxC - C,
   SpacesM is MaxM - M,
   writeChars(' ', SpacesC),
   writeChars('K', C),
   write('.'),
   writeChars('M', M),
   writeChars(' ', SpacesM).

% Notatie voor de kanten.

writeBoat(C, M, wal):-
    numberMaxInBoat(Max),
    Spaces is Max -(C+M),
    write('|['),
    writeChars('.', Spaces),
    writeChars('K', C),
    writeChars('M', M),
    write('>'),
    Tildes is Max + 5,
    writeChars('~', Tildes),
    write('|').
writeBoat(C, M, overkant):-
    numberMaxInBoat(Max),
    Spaces is Max -(C+M),
    write('|'),
    Tildes is Max + 5,
    writeChars('~', Tildes),
    write('<'),
    writeChars('K', C),
    writeChars('M', M),
    writeChars('.', Spaces),
    write(']|').

% Notatie voor bootladingen en de rivier.

writeTrip(node(_, _, CO, MO, wal), node(NewCW, NewMW, NewCO, NewMO, _)):-
    CB is NewCO - CO,
    MB is NewMO - MO,
    writeChars(' ', 10),
    writeKant(NewCW, NewMW),
    writeBoat(CB, MB, wal),
    writeKant(CO, MO).
writeTrip(node(CW, MW, _, _, overkant), node(NewCW, NewMW, NewCO, NewMO, _)):-
    CB is NewCW - CW,
    MB is NewMW - MW,
    writeChars(' ', 10),
    writeKant(CW, MW),
    writeBoat(CB, MB, overkant),
    writeKant(NewCO, NewMO).

% Notatie voor trips: situatie aan de wal & overkant,
% en de situatie in het water.

writePath([]).
writePath([_]):-
    numberOfCanibals(C),
    numberOfMissionaries(M),
    writeChars(' ', 10),
    writeKant(0, 0),
    writeBoat(0, 0, overkant),
    writeKant(C,M), nl.

writePath([Node1, Node2| Tail]):-
    writeTrip(Node1, Node2), nl,
    writePath([Node2|Tail]).

% Onder elkaar uitprinten van de boottochtjes.
% De tweede clause is voor het printen van de eindsituatie.
