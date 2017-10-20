% PSS Huiswerk 6
% 16-10-17
% Stefan Schenk, 11881798, stefan_schenk@hotmail.com

/*
|-------------------------------------------------------------------------------
| Opg 1
|-------------------------------------------------------------------------------
*/

:- ['assets/astar'].

:- writeln('-------------------------------------------------------------').
:- writeln('Type "go." to start').
:- writeln('Type "go(VertrekStad, AankomstStad)." om een route te plannen').
:- writeln('-------------------------------------------------------------').

go :-
  go("maastricht", "enkhuizen").
go(Vertrekstad, AankomstStad) :-
  route(VertrekStad, AankomstStad, Route, Distance).

% solve_astar(Node, Path/Cost) :-
%   estimate(Node, Estimate),
%   astar([[Node]/0/Estimate], RevPath/Cost/_),
%   reverse(RevPath, Path).

route(VertrekStad, AankomstStad, Route, Distance) :-
  retractall(destination(_)),
  assert(destination(AankomstStad)),
  writeln("do stuff").

/*
|-------------------------------------------------------------------------------
| Opg 2
|-------------------------------------------------------------------------------
*/

%     Stadnaam    Latitude      Longitude
city("amsterdam"  /52.37        /4.89).
city("breda"      /51.57        /4.77).
city("eindhoven"  /51.44        /5.47).
city("enkhuizen"  /52.71        /5.27).
city("enschede"   /52.22        /6.89).
city("den helder" /52.96        /4.76).
city("groningen"  /53.22        /6.57).
city("haarlem"    /52.39        /4.65).
city("hoorn"      /52.64        /5.06).
city("rotterdam"  /51.92        /4.48).
city("maastricht" /50.85        /5.69).
city("utrecht"    /52.09        /5.12).

%     Stadnaam1    Stadnaam2    Afstand
path("den helder" /"hoorn"      /52.5 ).
path("den helder" /"haarlem"    /76.7 ).
path("hoorn"      /"enkhuizen"  /20.3 ).
path("enkhuizen"  /"utrecht"    /96.2 ).
path("amsterdam"  /"hoorn"      /44.8 ).
path("amsterdam"  /"utrecht"    /44.0 ).
path("amsterdam"  /"haarlem"    /17.5 ).
path("amsterdam"  /"rotterdam"  /78.8 ).
path("hoorn"      /"groningen"  /164.0).
path("enschede"   /"groningen"  /148.0).
path("utrecht"    /"breda"      /72.9 ).
path("utrecht"    /"enschede"   /141.0).
path("utrecht"    /"eindhoven"  /91.6 ).
path("breda"      /"eindhoven"  /59.5 ).
path("eindhoven"  /"maastricht" /88.7 ).
path("eindhoven"  /"enschede"   /177.0).
path("maastricht" /"enschede"   /241.0).


/*
|-------------------------------------------------------------------------------
| Opg 3
|-------------------------------------------------------------------------------
*/

% Heuristische functie om afstand van laatste stad in path tot destination te
% berekenen.
estimate([H|Node], Estimate) :-
  destination(Destination),
  distance_between(H, Destination, Estimate).

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

% move(Paths, [Path|Paths], ) :-

move(X, Y, Z) :-
  write("").

% De ge-asserte destination moet het laatste punt zijn in de route.
goal([Path|Paths]) :-
  destination(Path).

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
