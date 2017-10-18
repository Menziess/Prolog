% PSS Huiswerk 6
% 16-10-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|-------------------------------------------------------------------------------
| Opg 1
|-------------------------------------------------------------------------------
*/

:- ['assets/astar'].

:- writeln('-------------------------').
:- writeln('Type "go." to start').
:- writeln('Type "go(VertrekStad, AankomstStad)" om een route te plannen').
:- writeln('-------------------------').

go :-
  go("maastricht", "enkhuizen").
go(Vertrekstad, AankomstStad) :-
  route(VertrekStad, AankomstStad, Route, Distance),

% solve_astar(Node, Path/Cost) :-
%   estimate(Node, Estimate),
%   astar([[Node]/0/Estimate], RevPath/Cost/_),
%   reverse(RevPath, Path).

route(VertrekStad, AankomstStad, Route, Distance) :-
  writeln("do stuff").

/*
|-------------------------------------------------------------------------------
| Opg 2
|-------------------------------------------------------------------------------
*/

%     Stadnaam    N.B.    O.L.
city("amsterdam"  /52.23  /4.54).
city("breda"      /51.59  /4.82).
city("enkhuizen"  /52.42  /5.17).
city("enschede"   /52.13  /6.54).
city("den helder" /52.56  /4.46).
city("groningen"  /53.13  /6.34).
city("haarlem"    /52.37  /4.66).
city("hoorn"      /52.39  /5.04).
city("rotterdam"  /51.55  /4.29).
city("maastricht" /50.51  /5.41).
city("roosendaal" /51.32  /4.28).
city("utrecht"    /52.06  /5.07).

/*
|-------------------------------------------------------------------------------
| Opg 3
|-------------------------------------------------------------------------------
*/

estimate(X, Y) :-
  write("").

/*
|-------------------------------------------------------------------------------
| Opg 4
|-------------------------------------------------------------------------------
*/

move(X, Y, Z) :-
  write("").

goal(X) :-
  write("").

/*
|-------------------------------------------------------------------------------
| Opg 5
|-------------------------------------------------------------------------------
| Breda en Haarlem:
|
| Amsterdam en Groningen:
|
*/

/*
|-------------------------------------------------------------------------------
| Opg 6
|-------------------------------------------------------------------------------
*/

route_print(VertrekStad, AankomstStad).
