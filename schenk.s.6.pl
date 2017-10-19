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
city("amsterdam"  /52.37  /4.89).
city("breda"      /51.57  /4.77).
city("enkhuizen"  /52.71  /5.27).
city("enschede"   /52.22  /6.89).
city("den helder" /52.96  /4.76).
city("groningen"  /53.22  /6.57).
city("haarlem"    /52.39  /4.65).
city("hoorn"      /52.64  /5.06).
city("rotterdam"  /51.92  /4.48).
city("maastricht" /50.85  /5.69).
city("roosendaal" /51.54  /4.47).
city("utrecht"    /52.09  /5.12).

/*
|-------------------------------------------------------------------------------
| Opg 3
|-------------------------------------------------------------------------------
*/

estimate(X, Y) :-
  write("").

% Berekent hemelsbreede afstand tussen twee steden, bijvoorbeeld: de afstand
% tussen Amsterdam en Enhuizen wordt geschat op 47,7 km.
distance_between(City1, City2, Dis) :-
  city(City1/Lat1/Lon1),
  city(City2/Lat2/Lon2),
  distance(Lat1, Lon1, Lat2, Lon2, Dis).

% Method to determine distance between two lat/lon coordinates.
distance(Lat1, Lon1, Lat2, Lon2, Dis) :-
    P is 0.017453292519943295,
    A is (0.5 - cos((Lat2 - Lat1) * P) / 2 + cos(Lat1 * P) * cos(Lat2 * P) * (1 - cos((Lon2 - Lon1) * P)) / 2),
    Dis is (12742 * asin(sqrt(A))).

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
