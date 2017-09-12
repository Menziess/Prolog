% Opg. 1 evenList/1
%
% Test of een gegeven lijst een even aantal elementen heeft.

evenList([]).
evenList([_,_|T]) :-
    evenList(T).

% Basis (het simpelste geval): de lege lijst is een lijst met een even
% aantal elementen.
%
% Recursieve regel (het moeilijkere geval): haal twee elementen van de
% lijst af en herhaal de test voor wat je over houdt (T).
%
% Let op: het predicaat faalt voor een lijst met slechts 1 element.
% Bijvoorbeeld: evenList([a]) matcht niet met het basis-geval en ook
% niet met de head van de recursieve rule.
%
% Een voorbeeld: evenList([1,2,3,4,5]) slaagt als en alleen als
% evenList([3,4,5]) slaagt, en die slaagt weer als en alleen als
% evenList([5]) slaagt. Maar die faalt, en daardoor ook
% eventList([3,4,5]) en eventList([1,2,3,4,5]) dus ook.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opg. 5 lastMember/2
%
% Bepaalt het laatste element van een lijst.

lastMember([Z], Z).
lastMember([_|T], Z) :- 
    lastMember(T, Z).

% Basis: Als een lijst 1 element heeft dan is dat tevens het laatste
% element (Z).
%
% Recursieve regel: In de andere gevallen haalt toepassing van de
% regel het eerste element (head) eraf en bepaalt vervolgens het laatste
% element (Z) van de rest (tail, T). Dit is natuurlijk ook het laatste
% element van de lijst waar je mee begon ([_|T]).
%
% Een voorbeeld: lastMember([1,2,3], Z). Alleen de recursieve regel is
% van toepassing (mismatch met de basis). De recursieve regel versimpelt
% de berekening naar lastMember([2,3], Z). Deze goal wordt weer dankzij
% herhaling van de recursieve regel (wederom mismatch met de
% basis) versimpeld naar lastMember([3], Z). Nu is de goal zover
% versimpeld dat de basis van toepassing is, en Prolog meldt succesvol
% Z=3.
%
% Ad. Dit predicaat faalt voor de lege lijst.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opg. 8 popBot/3
%
% Haalt het laatste element van een lijst er af en meldt het resultaat
% in het tweede argument en dat laatste element zelf als derde argument.

popBot([Z], [], Z).
popBot([H|T], [H|NT], Z) :- 
    popBot(T, NT, Z).

% Basis: Als een lijst slechts 1 element heeft dan is het resultaat van
% het poppen de lege lijst en het laatste element dat enige
% element zelf (Z).
%
% Recursie: In de overige gevallen wordt de head (H) bewaard, en
% vervolgens dezelfde procedure gestart voor de tail (T). Daar komt
% uiteindelijk een resultaat voor: NT voor de gepopte T en Z zijn
% laatste element. Z was dan ook het laatste element van [H|T] en moet
% dus overgenomen worden in het resultaat. De gepopte [H|T] is niks
% anders als NT overnemen als de gepopte T en H weer netjes terugzetten
% als eerste element: [H|NT].
%
% Voorbeeld: ?- popBot([1,2,3], L, Z). dwingt toepassing vd recursieve
% regel af. Deze query matcht met de head van deze regel. Prolog moet
% wel oppassen met de variabelen-administratie en daarom niet letterlijk
% de regel overnemen maar eentje met verse (herbenoemde) variabelen (de
% betekenis verandert daar niet door):
%
% popBot([H1|T1], [H1|NT1], Z1):- popBot(T1, NT1, Z1).
%
% De head van deze rule matcht met de query door de volgende
% variabelen-instantiaties H1 = 1, T1 = [2,3] en daarmee L = [1|NT1],
% en ook Z = Z1. Prolog onthoudt deze instantiaties om de
% tussenresultaten en het eindresultaat uiteindelijk uit te rekenen. Het
% invullen van de instatiaties in de body van de regel van hierboven
% geeft de goal:
%
% ?- popBot([2,3], NT1, Z1).
%
% Deze matcht weer niet met de basis, en dus moet wederom de recursieve
% regel gebruikt worden. Prolog zorgt weer voor een ververste kopie:
%
% popBot([H2|T2], [H2|NT2], Z2):- popBot(T2, NT2, Z2).
%
% Dit levert de instatiaties: H2 = 2, T2 = [3] en NT1 = [2|NT2], en Z2 =
% Z1.
%
% Het invullen van de instantiaties in de body van de regel geeft de
% volgende goal:
%
% ?- popBot([3], NT2, Z2).
%
% Deze matcht wel met de basis. Ook hiervan  wordt weer een verse kopie
% gebruikt:
%
% popBot([Z3], [], Z3).
%
% De instanties zijn nu simpel Z3 = 3, NT2 = [].
% Prolog slaagt! Nu moet-ie nog de variabelen administratie doen:
%
% NT1 = [2|NT2] = [2|[]] = [2].
% L = [1|NT1] = [1|[2]] = [1, 2].
% Z = Z1 = Z2 = Z3 = 3.
%
% Alleen de laatste twee stonden in de originele query en die meldt hij
% dus expliciet in zijn uiteindelijke antwoord.
%
% Een lang verhaal: uittekenen van een bewijsboom (zie slides) werkt
% korter en sneller. Zorg wel steeds voor het verversen van de
% variabelen als een clause (fact of rule) aangeroepen wordt. Anders
% gaat het heel erg mis.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opg. 11 midMember/2
%
% Bepaalt het middelste element van een lijst

midMember([A], A).
midMember([_|T], M):-
    popBot(T, PT, _),
    midMember(PT, M).


% Basis: lijst met 1 element. Dat element is dan ook het middelste
% element.
%
% Recursie: lijst met meer elementen. Haal de head eraf (mag anoniem
% blijven, want in zijn naam zijn we niet geinteresseerd). Gebruik nu
% popBot/3 om de tail (T) van de originele lijst te poppen, d.i. zijn
% laatste element te verwijderen. Het resultaat noemen we PT. Het
% laatste element van T dat popBot/3 in zijn derde argument meldt zijn
% we ook weer niet in geinteresseerd. PT is dus de lijst die je krijgt
% door het eerste element en het laatste element van de originele lijst
% af te halen. Als je daar het middelste element van neemt dan is dat
% hetzelfde object als het middelste element van de originele
% lijst.
