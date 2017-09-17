% Oefenopgaven Week 1
% 06-09-17

/**
 * Opg. 1 Implementeer een predicaat evenList/1 zodanig dat evenList(List) 
 * slaagt als en alleen als List een lijst met een even aantal members. 
 * 
 * Als de lijst leeg is, is deze even. Elke recursieve stap worden de eerste
 * twee elementen verwijderd uit de lijst.
 */
evenList([]).
evenList([_, _ | T]) :-
  evenList(T).

opgave1 :- 
  write('Geef een list: '),
  nl, 
  read(List),
  write('List is even: '),
  evenList(List).

/**
 * Opg. 2 Vul de implementatie uit Opgave 1 aan met de implementatie van 
 * een predicaat oddList/1 dat slaagt als en alleen als zijn argument een 
 * lijst is met een oneven aantal members.
 *
 * De not operator wordt gebruikt om te kijken of de lijst niet even is.
 */
oddList(List) :-
  not(evenList(List)).

opgave2 :- 
  write('Geef een oneven lijst: '),
  nl, 
  read(List),
  write('List is odd: '),
  oddList(List).

/**
 * Opg. 3 Implementeer een predicaat evenMembers/2 dat voor een gegeven 
 * lijst de members op de ’even’ plekken (de 2-de, de 4-de, de 6-de plek, 
 * etc.) staan eruit ﬁltert. Bijvoorbeeld:
 * ?- evenMembers([1,2,3,4,5], L). geeft L = [2,4] 
 * ?- evenMembers([a,b,c,d,e,f], L). geeft L = [b,d,f]
 * 
 * 
 * Dan wordt gecheckt of de lijst leeg is, or maar 1 element heeft.
 */
evenMembers([], []).
evenMembers([_], []).
evenMembers([_,Even|Tail], [Even|NT]) :-
  evenMembers(Tail, NT).
 
opgave3 :- 
  write('Geef een lijst: '),
  nl, 
  read(List),
  write('List even members: '),
  evenMembers(List).

/**
 * Opg. 4 Breid de implementatie van Opgave 3 uit met de regels voor een
 * predicaat oddMembers/2 dat de members op de ’oneven’ plekken (de 1-ste, 
 * de 3-de, de 5-de plek, etc.) uit een gegeven lijst haalt.
 *
 */
oddMembers([], []).
oddMembers([_], []).
oddMembers([Odd,_|Tail], [Odd|NT]) :-
  oddMembers(Tail, NT).

opgave4 :- 
  write('Geef een lijst: '),
  nl, 
  read(List),
  write('List even members: '),
  oddMembers(List).

/**
 * Opg. 5 Implementeer een predicaat lastMember/2 zodanig dat lastMember
 * voor gegeven lijst List zijn laatste member LastMember geeft 
 * (in het geval van een lege lijst moet lastMember falen).
 * 
 * 
 */
lastMember([], LastMember) :-
  fail.
lastMember([_,Tail], LastMember) :-
  lastMember()
