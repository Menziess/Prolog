/** <module> PSS Huiswerk 6
 This module contains the homework from week 6.
 It is about finding the shortest route between two cities with the
 a-star algorithm.

 @author J.B.M. (Jim) Kamans, 10302905
 @email kamansjim@gmail.com
 @date 20-10-2017
*/

/*
 * Output Breda -> Haarlem:
 *
 * ?- route(breda, haarlem, Route, Distance).
 * Route = [breda, den_haag, haarlem],
 * Distance = 141 ;
 * Route = [breda, den_bosch, utrecht, amsterdam, haarlem],
 * Distance = 174 ;
 * Route = [breda, den_haag, utrecht, amsterdam, haarlem],
 * Distance = 215 .
 *
 * Output Amsterdam -> Groningen:
 *
 * ?- route(amsterdam, groningen, Route, Distance).
 * Route = [amsterdam, lelystad, zwolle, assen, groningen],
 * Distance = 221 ;
 * Route = [amsterdam, haarlem, leeuwarden, groningen],
 * Distance = 238 ;
 * Route = [amsterdam, haarlem, leeuwarden, assen, groningen],
 * Distance = 289 .
 */

% Import the a-star algorithm.
:- consult('assets/astar.pl').

% Stop Prolog's complaining about not knowing goal/1, because goal/1 doesn't exists until route/4 is called.
:- dynamic goal/1.


% Distances (approx.) from city to city in km, taken from
% http://nl.afstand.org/.
distance(groningen, leeuwarden, 65).
distance(groningen, assen, 34).
distance(leeuwarden, assen, 82).
distance(leeuwarden, haarlem, 152).
distance(assen, zwolle, 76).
distance(haarlem, amsterdam, 21).
distance(haarlem, den_haag, 59).
distance(zwolle, lelystad, 51).
distance(zwolle, arnhem, 67).
distance(amsterdam, lelystad, 60).
distance(amsterdam, utrecht, 48).
distance(den_haag, utrecht, 64).
distance(den_haag, middelburg, 158).
distance(den_haag, breda, 82).
distance(arnhem, utrecht, 68).
distance(arnhem, den_bosch, 62).
distance(arnhem, maastricht, 166).
distance(utrecht, den_bosch, 54).
distance(middelburg, breda, 102).
distance(breda, den_bosch, 51).
distance(den_bosch, maastricht, 131).


%!  get_distance(+City1:atom, +City2:atom, -Distance:int)
%
%   Get Distance from City1 to City2.
%
%   I made the assumption that the distance from A to B
%   is the same distance from B to A. This is not always true,
%   but I think this doesn't matter for this assignment.
%
%   @arg City1 an atom of a city name
%   @arg City2 an atom of a city name
%   @arg Distance an int representing the approx. distance in km
get_distance(City1, City2, Distance):-
    distance(City1, City2, Distance);
    distance(City2, City1, Distance).


% Latitude and longitude of cities, taken from https://www.latlong.net/.
latlong(haarlem, 52.387388, 4.646219).
latlong(den_haag, 52.070498, 4.3007).
latlong(middelburg, 51.498796, 3.610998).
latlong(den_bosch, 51.697816, 5.303675).
latlong(maastricht, 50.851368, 5.690973).
latlong(arnhem, 51.985103, 5.89873).
latlong(utrecht, 52.090737, 5.12142).
latlong(lelystad, 52.518537, 5.471422).
latlong(zwolle, 52.516775, 6.083022).
latlong(assen, 52.992753, 6.564228).
latlong(groningen, 53.219383, 6.566502).
latlong(leeuwarden, 53.201233, 5.799913).
latlong(amsterdam, 52.370216, 4.895168).
latlong(breda, 51.571915, 4.768323).


%!  pythagoras(+A:number, +B:number, -C:double).
%!  pythagoras(+A:number, -B:double, +C:number).
%!  pythagoras(-A:double, +B:number, +C:number).
%
%   Use Pythagorean theorem to calculate the variable argument.
%   C needs to be larger than A and B.
%
%   ?- pythagoras(3.2, 5.1, C).
%   C = 6.020797289396148.
%
%   ?- pythagoras(3.2, B, 5.1).
%   B = 3.9711459303329555.
%
%   ?- pythagoras(A, 5.1, 3.2).
%   false.
%
%   @arg A a number
%   @arg B a number
%   @arg C a number
%
pythagoras(A, B, C):-
    number(A), number(B), !, C is sqrt(abs(A)**2 + abs(B)**2);
    number(A), number(C), C >= A, !, B is sqrt(abs(C)**2 - abs(A)**2);
    number(B), number(C), C >= B, !, A is sqrt(abs(C)**2 - abs(B)**2).


%!  route(+From:atom, +To:atom, -Route:list, -Distance:int).
%
%   Calculate the Distance of the shortest Route of From -> To.
%
%   @arg From the atom of the starting city
%   @arg To the atom of the destination city
%   @arg Route the list of cities on route.
%   @arg Distance the int representing the total distance in km of
%   Route.
route(From, To, Route, Distance):-
    setGoal(To), % Dynamically set goal.
    solve_astar(From, Route/Distance). % Let A-star solve the shortest route.


%!  setGoal(+City).
%
%   Add the predicate goal(City) and remove all other goal/1 predicates.
%   Called by route/4 and used in solve_astar/2.
%
%   @arg City an atom of a city name
%
setGoal(City):-
    retractall(goal(_)),
    assert(goal(City)).


%!  estimate(+From:atom, -Distance:double).
%
%   Estimate what the remaining Distance is between From and the
%   destination (goal(X)).
%   The estimation is the "hemelsbrede" distance, calculated from the
%   latitude and longitude of both cities and used in solve_astar/2
%   to find the best place to go to next.
%
%   @arg From an atom of a city.
%   @arg Distance a double represenating the "hemelsbrede" distance
%
estimate(From, Distance):-
    latlong(From, Lat, Long),
    goal(To),
    latlong(To, LatTo, LongTo),
    LatDiff is (LatTo - Lat) * 111, % universal diff between latitudes.
    LongDiff is (LongTo - Long) * 64, % "constant" diff in NL between longitudes.
    pythagoras(LatDiff, LongDiff, Distance).


%!  move(+City1:atom, -City2:atom, -Distance:int).
%
%   Find a City2 directly connected to City1 and with distance Distance
%   km.
%   Used in solve_astar/2 to get the cities to go to next and select
%   the best choice.
%
%   @arg City1 an atom of a city name
%   @arg City2 an atom of a city name
%   @arg Distance an int representing the distance in km.
%
move(City1, City2, Distance):-
    get_distance(City1, City2, Distance).


%!  route_print(+From:atom, +To:atom).
%
%   Print the shortest route between From and To including distances.
%
%   @arg From an atom of a city name
%   @arg To an atom of a city name
%
route_print(From, To):-
    route(From, To, Route, Distance),
    pretty_print_route(Route, Distance).


%!  pretty_print_route(+Route:list, +Distance:int).
%
%   Pretty prints the Route incl. distances and also the total Distance.
%
%   @arg Route a list of cities
%   @arg Distance an int representing the total distance in km.
%
pretty_print_route(Route, Distance):-
    print_NL(Route),
    print_km(Route),
    write_sequence("-", 34), write(" +"), nl,
    format('~tTotal distance = ~27|~t~d km.~35|~n', Distance).


% Helper function of pretty_print_route/2.
% Prints the distance between each two next cities on route.
print_km([_]).
print_km([City1, City2|OtherCities]):-
    get_distance(City1, City2, Distance),
    format('~s~t~10| -> ~s~t~24| = ~t~27|~t~d km~34|~n', [City1, City2, Distance]),
    print_km([City2|OtherCities]).


% Write a sequence of the same character.
write_sequence(_, 0):- !.
write_sequence(String, N):-
    write(String),
    NN is N - 1,
    write_sequence(String, NN).


%!  print_NL(+Route:list).
%
%   Print a ASCII map of NL with only the cities in Route.
%   See print_NL_original below for a better "picture".
%
%   @arg Route a list of cities
%
print_NL(Route):-
    write("                           ____  __  _       "),nl,
    write("                       ___                   "),nl,
    write("                     /               ____      "),nl,
    write("                            ________/    |     "),nl,
    write("                 /\\        /             \\_  "),nl,
    %write("                /_|       /   LW       G   |    LW = Leeuwarden"),nl,
    write("                /_|       /   "),
    (   member(leeuwarden, Route),
        write("LW");
        write("  ")
    ),
    write("       "),
    (   member(groningen, Route),
        write("G");
        write(" ")
    ),
    write("   |    "),
    (   member(leeuwarden, Route),
        write("LW = Leeuwarden");
        write("")
    ), nl,
    %write("                         /                 |    G = Groningen"),nl,
    write("                         /                 |    "),
    (   member(groningen, Route),
        write("G = Groningen");
        write("")
    ), nl,
    %write("               /\\__/\\   |           AS     |    AS = Assen"),nl,
    write("               /\\__/\\   |           "),
    (   member(assen, Route),
        write("AS");
        write("  ")
    ),
    write("     |    "),
    (   member(assen, Route),
        write("AS = Assen");
        write("")
    ), nl,
    write("              |      \\  |__                |   "),nl,
    write("              |      |_   /                |    "),nl,
    %write("              |       _|  |__          ____|    LY = Lelystad"),nl,
    write("              |       _|  |__          ____|    "),
    (   member(lelystad, Route),
        write("LY = Lelystad");
        write("")
    ), nl,
    %write("              |      |    /LY|    Z   |         Z = Zwolle"),nl,
    write("              |      |    /"),
    (   member(lelystad, Route),
        write("LY");
        write("  ")
    ),
    write("|    "),
    (   member(zwolle, Route),
        write("Z");
        write(" ")
    ),
    write("   |         "),
    (   member(zwolle, Route),
        write("Z = Zwolle");
        write("")
    ), nl,
    %write("              |H    AM\\__/__/         |___      H = Haarlem"),nl,
    write("              |"),
    (   member(haarlem, Route),
        write("H");
        write(" ")
    ),
    write("    "),
    (   member(amsterdam, Route),
        write("AM");
        write("  ")
    ),
    write("\\__/__/         |___      "),
    (   member(haarlem, Route),
        write("H = Haarlem");
        write("")
    ), nl,
    %write("              |                           \\     AM = Amsterdam"),nl,
    write("              |                           \\     "),
    (   member(amsterdam, Route),
        write("AM = Amsterdam");
        write("")
    ), nl,
    write("              |                           |    "),nl,
    %write("             /                            |     DH = Den Haag"),nl,
    write("             /                            |     "),
    (   member(den_haag, Route),
        write("DH = Den Haag");
        write("")
    ), nl,
    %write("            /DH       U                  /      U = Utrecht"),nl,
    write("            /"),
    (   member(den_haag, Route),
        write("DH");
        write("  ")
    ),
    write("       "),
    (   member(utrecht, Route),
        write("U");
        write(" ")
    ),
    write("                  /      "),
    (   member(utrecht, Route),
        write("U = Utrecht");
        write("")
    ), nl,
    %write("           /                   AR       /       AR = Arnhem"),nl,
    write("           /                   "),
    (   member(arnhem, Route),
        write("AR");
        write("  ")
    ),
    write("       /       "),
    (   member(arnhem, Route),
        write("AR = Arnhem");
        write("")
    ), nl,
    write("          /                             \\      "),nl,
    write("         /                          ____/      "),nl,
    write("        |                          /           "),nl,
    write("        \\                          \\         "),nl,
    %write("         /               DB         \\           DB = Den Bosch"),nl,
    write("         /               "),
    (   member(den_bosch, Route),
        write("DB");
        write("  ")
    ),
    write("         \\           "),
    (   member(den_bosch, Route),
        write("DB = Den Bosch");
        write("")
    ), nl,
    write("        /                            \\        "),nl,
    write("       /                              \\       "),nl,
    %write("      /        B                      |         B = Breda"),nl,
    write("      /        "),
    (   member(breda, Route),
        write("B");
        write(" ")
    ),
    write("                      |         "),
    (   member(breda, Route),
        write("B = Breda");
        write("")
    ), nl,
    write("     /                                |        "),nl,
    %write("    /MI    _________________         /          MI = Middelburg"),nl,
    write("    /"),
    (   member(middelburg, Route),
        write("MI");
        write("  ")
    ),
    write("    _________________         /          "),
    (   member(middelburg, Route),
        write("MI = Middelburg");
        write("")
    ), nl,
    write("   /     _|                 \\       /        "),nl,
    write("  |_____/                    |__   /          "),nl,
    write("                                \\  |          "),nl,
    write("                                |  |           "),nl,
    write("                                |  \\          "),nl,
    %write("                               / MA |           MA = Maastricht"),nl,
    write("                               / "),
    (   member(maastricht, Route),
        write("MA");
        write("  ")
    ),
    write(" |           "),
    (   member(maastricht, Route),
        write("MA = Maastricht");
        write("")
    ), nl,
    write("                               |____|          "),nl,
    write("                                           "),nl,
    write("                                           "),nl,
    !.


%!  print_NL_original
%
%   Original predicate to print NL.
%   After implementing this predicate, I made print_NL/1 which prints
%   only the placenames in the route.
%   So print_NL_original is the same as:
%   ?- findall(City, latlong(City, _, _), Cities), print_NL(Cities).
%
print_NL_original():-
    write("                           ____  __  _       "),nl,
    write("                       ___                   "),nl,
    write("                     /               ____      "),nl,
    write("                            ________/    |     "),nl,
    write("                 /\\        /             \\_  "),nl,
    write("                /_|       /   LW       G   |    LW = Leeuwarden"),nl,
    write("                         /                 |    G = Groningen"),nl,
    write("               /\\__/\\   |           AS     |    AS = Assen"),nl,
    write("              |      \\  |__                |   "),nl,
    write("              |      |_   /                |    "),nl,
    write("              |       _|  |__          ____|    LY = Lelystad"),nl,
    write("              |      |    /LY|    Z   |         Z = Zwolle"),nl,
    write("              |H    AM\\__/__/         |___      H = Haarlem"),nl,
    write("              |                           \\     AM = Amsterdam"),nl,
    write("              |                           |    "),nl,
    write("             /                            |     DH = Den Haag"),nl,
    write("            /DH       U                  /      U = Utrecht"),nl,
    write("           /                   AR       /       AR = Arnhem"),nl,
    write("          /                             \\      "),nl,
    write("         /                          ____/      "),nl,
    write("        |                          /           "),nl,
    write("        \\                          \\         "),nl,
    write("         /               DB         \\           DB = Den Bosch"),nl,
    write("        /                            \\        "),nl,
    write("       /                              \\       "),nl,
    write("      /        B                      |         B = Breda"),nl,
    write("     /                                |        "),nl,
    write("    /MI    _________________         /          MI = Middelburg"),nl,
    write("   /     _|                 \\       /        "),nl,
    write("  |_____/                    |__   /          "),nl,
    write("                                \\  |          "),nl,
    write("                                |  |           "),nl,
    write("                                |  \\          "),nl,
    write("                               / MA |           MA = Maastricht"),nl,
    write("                               |____|          "),nl,
    write("                                           "),nl,
    write("                                           "),nl.


% Print instructions how to use the route planner when this file is consulted.
:- print_NL_original.
:- write_sequence("*", 60), nl, writeln("To start the route planner, use:"), nl.
:- writeln("?- route_print(To, From)."), nl.
:- writeln("with the following place names: ").
:- findall(_City, (latlong(_City, _, _), writeln(_City)), _), write_sequence("*", 60), nl.
