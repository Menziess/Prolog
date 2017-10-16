:- writeln(' ').
:- writeln('*****************************************'), nl.
:- writeln('Huiswerk4: De depth-first Sudoku-solver.'), nl.
:- writeln('Aanroep = ?- go.'), nl.
:- writeln('d.i. voor het oplossen van de Sudoku uit').
:- writeln('de opgaven (Inleiding). Voor andere').
:- writeln('voorbeelden kan je go/1 gebruiken waarbij').
:- writeln('het argument t0, t1, ... of t7 moet zijn.').
:- writeln('Geeft o.a. gevarieerde rekentijden. t3').
:- writeln('neemt de meeste tijd in beslag. Op mijn').
:- writeln('oudere mac mini: 49 sec.'), nl.
:- writeln('*****************************************'), nl.


/*

       go/0. Kort AANROEPPREDICAAT om de sudoku-solver te starten. Het
       principiële predicaat is solve/2, hier vervangen door een
       uitbreiding solveTime/3, die in het extra (laatste) argument de
       rekentijd bijhoudt.
*/


go:-
	beginToestand(B),
        print_solve_print(B).

/*
       go/1 met als argument de sudoku die opgelost moet worden.
       Aan het eind van het programma zijn nog een paar op te lossen
       sudoku's gegeven: t0 t/m t7.

*/

go(Sudoku):-
    AanroepSudoku =.. [Sudoku, Matrix],
    call(AanroepSudoku),
    print_solve_print(Matrix).




print_solve_print(Matrix):-
        nl,
        printMatrix(Matrix),
        writeln('Return "ok." voor het starten!'),
        read(_),
        writeln('Momentje ....'),
	solve_simple_depth_first(Matrix, E, Time),   % De depth-first solver, met Timer.
	printMatrix(E),
	writeln('Brute force depth first'),
	write('kostte me dit '),
	TTime is floor(Time),
	CTime is floor((Time - TTime)*100),
	write(TTime),
	write('.'),
	write(CTime),
	write(' seconden.').


/*
       VRAAG 1. REPRESENTATIE van Sudoku's: lijsten van lijsten
       (matrix). Elke lijst is een rij in het Sudoku-vierkant. De lege
       plekken worden gerepresenteerd door een 0. Onderaan in het
       programma staan nog een paar voorbeeldsudoku's: t0/1, t1/1, ...
       plaats dit in de go-clause als je die wilt uitproberen (t3 is de
       lastigste ... tenminste, die kost met dit brute force depth first
       programma het meeste tijd.
*/


beginToestand([
    [1,0,0, 0,0,2, 7,6,0],
    [2,0,0, 0,0,1, 0,0,8],
    [0,3,6, 0,0,7, 0,0,4],

    [0,0,0, 0,6,0, 8,7,2],
    [6,0,7, 0,2,9, 0,0,0],
    [0,0,0, 0,0,0, 0,0,0],

    [0,8,0, 0,7,0, 3,0,0],
    [0,1,3, 0,0,0, 5,0,0],
    [0,0,0, 0,1,0, 0,9,7]
]).



/*
      HULP-PREDICATEN VOOR HET LIJST-WERK
*/


% sudokuMaat/1. Geeft de maat van de sudoku. Voor een standaard-Sudoku
% is dat gelijk aan 3, en geeft een 9x9-matrix. In het algemene geval is
% de omvang van een sudoku het kwadraat van de maat. Indien we dit
% wijzigen is het programma ook bruikbaar voor een 4x4-sudoku, en ook
% een 16x16-sudoku (maar daar ga je wel de exponentiele complexiteit van
% depth-first voelen (= extreem lange wachttijden).
%
% Dit was op zich niet verlangd, maar het is in het algemeen prettiger
% voor het programmeerwerk om de implementatie algemeen te houden.
% Bovendien is het dan ook breder inzetbaar.

sudokuMaat(3).

% vullers/2. Geeft een lijstje vullers [1,...,N] (arg2) voor een
% positief geheel getal N (arg2).

vullers(1, [1]).
vullers(BovenGrens, L):-
	BovenGrens > 0,
	N is BovenGrens - 1,
	vullers(N, LN),
	append(LN, [BovenGrens], L).

% vullers/1. Geeft een lijstje van vullers (getallen) voor de gegeven
% sudoku-maat. In het geval van de gewone sudoku's is dat [1,2,...,9].

vullers(LijstVanVullers):-
	sudokuMaat(Maat),
	BovenGrens is Maat * Maat,
	vullers(BovenGrens, LijstVanVullers).

/*
      HULP-PREDICATEN voor het berekenen van rijen, kolommen en
      kwadranten (de negen vet-omlijnde 3x3-vierkantjes in een
      Sudoku-vierkant).
*/

% nth_member/3: Selecteer in arg3 het n-de (arg1) element uit een lijst
% (arg2).

nth_member(1, [H|_], H).
nth_member(N, [_|T], M):-
	NN is N-1,
	nth_member(NN, T, M).

% ntomth_member/4: Selecteer in arg4 de lijst van het n-de (arg1) t/m
% het m-de (arg2) elemenent uit een lijst (arg3).

ntomth_member(N, N, L, [Element]):-
	nth_member(N, L, Element).
ntomth_member(N, M, L, [H|T]):-
	nth_member(N, L, H),
	NN is N+1,
	ntomth_member(NN, M, L, T).

% ntomth_members/4: Selecteer in arg4 de lijst van alle n t/m m-de
% (arg1, arg2, resp.) elementen uit de lijst van lijsten (matrix)
% gegeven in arg3.

ntomth_members(N, M, [H|T], L):-
	ntomth_member(N, M, H, LH),
	ntomth_members(N, M, T, LT),
	append(LH, LT, L).
ntomth_members(_, _, [], []).


/*
       VRAAG 2. RIJEN, KOLOMMEN EN KWADRANTEN
*/

% rij/3. Geeft de N-de (arg1) rij van een matrix (arg2) in arg3.

rij(N, Matrix, CijfersInRij):-
	nth_member(N, Matrix, CijfersInRij).

% kolom/3. Geeft de N-de (arg1) kolom van een matrix (arg2) in arg3.

kolom(_, [], []).
kolom(N, [EersteRij|RestRijen], [EersteCijferInKolom|RestCijfersInKolom]):-
	nth_member(N, EersteRij, EersteCijferInKolom),
	kolom(N, RestRijen, RestCijfersInKolom).

% Deze haalt het N-de element uit elke Rij van de Matrix.


% kwadrant/3. Geeft het N-de (arg1) kwadrant van een matrix (arg2) in
% arg3. Hierbij is de nummering van kwadranten (arg1) tellend van links
% naar rechts en vervolgens boven naar beneden, als hieronder
% aangegeven:
%                  1 2 3
%                  4 5 6
%                  7 8 9



kwadrant(N, Matrix, CijfersInKwadrant):-
	sudokuMaat(Size),                % standaard Size = 3
	Y is (N - 1) // Size,
	X is (N - 1) mod Size,
	MinRijIndex is Y*Size + 1,
	MaxRijIndex is (Y+1)*Size,
	MinKolomIndex is X*Size + 1,
	MaxKolomIndex is (X+1)*Size,
	ntomth_member(MinRijIndex, MaxRijIndex, Matrix, KwadRijen),
	ntomth_members(MinKolomIndex, MaxKolomIndex, KwadRijen, CijfersInKwadrant).

% Een veel complexere operatie. Om de desbetreffende cijfers voor de
% gegeven kwadrant te bereken delen we de kwadranten op mbv een
% verticale index (Y) en een horizontale index (X). Als we deze als
% X,Y-paren noteren dan worden de kwadranten als volgt opnieuw
% ingedeeld.
%
%                  (0,0)  (1,0)  (2,0)
%
%                  (0,1)  (1,1)  (2,1)
%
%                  (0,2)  (1,2)  (2,2)
%
% Om nu X en Y uit N te berekenen kan je het volgende doen: Y is het
% getal dat je krijgt door N-1 te delen door 3 en naar beneden af te
% ronden. Dat kan vrij direct door integer deling // te gebruiken (zie
% ook de syllabus hf 3. De X coordinaat is dan niks anders dan de rest
% die je overhoudt nadat je N-1 door 3 integer-deelt. Hiervoor hebben we
% mod/2 (in NLs: "modulo") ter beschikking.
%
% Aan de hand van de X en Y coordinaat kunnen we snel aflezen welke
% kolommen en rijen resp. het N-de kwadrant doorkruisen. We beginnen met
% de rijen want die zijn het makkelijkst af te lezen uit de Matrix.
% Hiervoor hebben we Y nodig. Dit kan je doen door Y met 3 te
% vermenigvuldigen en er 1 bij op te tellen. Dit is de index van de
% hoogste rij (MinRijIndex) die door het kwadrant gaat. Bijvoorbeeld
% voor het kwadrant nummer 6 is de (X,Y) gelijk aan (2,1) en daarmee is
% dus de 4de rij (3*1+1) de hoogstliggende rij die door dat kwadrant
% heen gaat. De laagstliggende rij (MaxRijIndex) is gelijk aan (Y+1)*3.
% In het geval van kwadrant nummer 6 levert dat 6 op, en daarmee is dus
% de 6-de rij de laagstliggende rij die door dat kwadrant heen gaat.
% Met behulp van het predicaat ntomth_member/4 kunnen we nou die drie
% rijen (KwadRijen) uit de matrix halen. Dit is dus een 9x3-matrix: 3
% lijsten van lengte 9.
%
% We hebben nu ook de kolom-indices nodig om de cijfers van het kwadrant
% te krijgen. Hiervoor kunnen we dezelfde in feite dezelfde procedure
% gebruiken, maar dan toegepast op X. De meest linkse kolom is gelijk
% aan X*3+1 en de meest rechtse is gelijk aan (X+1)*3. In het geval van
% de 6de kwadrant krijgen we zodoende (X,Y) = (2,1) en daarmee
% MinKolomIndex = 7 en MaxKolomIndex = 9. Nu weten we dus dat we van de
% drie lijsten in KwadRijen de 7de tot en met de 9de elementen moeten
% verzamelen. Hiervoor roepen we het predicaat ntomth_members/4 aan.
% Dit was de lijst-generalisering van ntomth_member/4.
%
% Voila, het resultaat staat nu in het laatste argument:
% CijfersInKwadrant.





/*
	CELLEN VULLEN

	Predicaten voor het vullen van lege vakjes (cellen) in de Sudoku's.
*/



% gevuld/1. Slaagt als een matrix helemaal gevuld is = geen nullen
% bevat.

gevuld([EersteRij|RestMatrix]):-
	gevuldRij(EersteRij),
	gevuld(RestMatrix).
gevuld([]).

% gevuldRij/1. Basis voor het predicaat hierboven. Slaagt als een lijst
% geen nullen bevat.

gevuldRij([H|T]):-
	H > 0,
	gevuldRij(T).
gevuldRij([]).



% vulCel/5. Vult een getal (arg1) in op de eerste lege plek (waar een 0
% staat) van een Matrix (arg2) en levert in arg3 het resultaat af. In de
% laatste twee argumenten geeft hij ook de X- (horizontale) en Y-
% (verticale) coordinaat af waar hij het arg1 heeft neergezet. De
% X-coordinaat is het nummer van de kolom, en de Y-coordinaat die van
% het nummer van de rij. Dit is later handig
% om te gebruiken bij het bepalen van het kwadrantnummer, en daarmee te
% controleren of het resultaat een legale sudoku aflevert (d.i. de
% elementaire regels van het spel niet schendt).

vulCel(Getal, [EersteRij|RestMatrix], [Rij|RestMatrix],X,1):-
	vulCelInRij(Getal, EersteRij, Rij, X).
vulCel(Getal, [EersteRij|RestMatrix], [EersteRij|Matrix], X, Y):-
	gevuldRij(EersteRij), !,
	vulCel(Getal,RestMatrix, Matrix, X, YY),
	Y is YY+1.



% vulCelRij/4. De basis voor het predicaat van hierboven. Het zet het
% getal in arg1 neer op de eerste lege plek (waar een 0 staat) van een
% rij (lijst, arg2) en geeft het resultaat af in arg3 en in arg4 meldt
% het ook de plek van plaatsing.


vulCelInRij(Getal, [0|Tail], [Getal|Tail], 1).
vulCelInRij(Getal, [Head|Tail], [Head|VTail], N):-
	Head > 0,
	vulCelInRij(Getal, Tail, VTail, NN),
	N is NN + 1.

% legaleCelVuller/4. Bepaalt voor een Matrix (arg4), of de vuller
% (Getal, arg 1) bij vulling een legale sudoku aflevert. Hierbij
% helpen de X en Y coordinaten van plaatsing.
% We hebben nog wel iets nodig (geefKwadrantNummer/3) om ook de kwadrant
% van plaatsing te controleren.

legaleCelVuller(Getal, X, Y, Matrix):-
	kolom(X, Matrix, Kolom),
	\+ member(Getal, Kolom),
	rij(Y, Matrix, Rij),
	\+ member(Getal, Rij),
	geefKwadrantNummer(X, Y, Q),
	kwadrant(Q, Matrix, Kwadrant),
	\+ member(Getal, Kwadrant).

% geefKwadrantNummer/3. Geeft voor cel in de X-ste kolom, en de Y-de rij
% het kwadrantnummer.

geefKwadrantNummer(X, Y, KwadrantNummer):-
	sudokuMaat(Size),     %  standaard Size = 3
	YY is (Y-1) // Size,
	XX is (X-1) // Size,
	KwadrantNummer is YY*Size + XX + 1.

/*
	VRAAG 3. goal/1. Die is gemakkelijk in deze implementatie.
        Als de matrix helemaal gevuld is, dan is het doel bereikt.
	Onderweg wordt steeds per stap gecontroleerd of de cellen
	volgens de sudoku-regels worden gevuld.
*/

goal(Toestand):-
	gevuld(Toestand).

/*
	VRAAG 4. MOVE

	... met member/2 de mogelijke vullers aflopen ..
	... vul resultaat in ...
        ... kijk of dit een legale matrix oplevert ....
*/

move(Toestand, NieuweToestand):-
	vullers(GetallenLijst),        % standaard Getallenlijst = [1,...,9]
	member(Getal, GetallenLijst),
	vulCel(Getal, Toestand, NieuweToestand, X, Y),
	legaleCelVuller(Getal, X, Y, Toestand).

/*
	VRAAG 5. SOLVE

	... het "brute force" depth-first-predicaat. Omdat de goal-toestand
	in het geval van sudoku al het succesvolle pad weergeeft
	hoeven we die niet bij te houden. De cellen worden in volgorde
	ingevuld van het succesvolle pad immers ingevuld.

        Omdat het formaat door het weglaten van het pad er iets anders
        uitziet dan als gepresenteerd dan bij het hoorcollege noemen we
        hier het depth_first predicaat simple_depth_first/2.

*/

simple_depth_first(EindToestand, EindToestand):-
	goal(EindToestand).

simple_depth_first(Toestand, EindToestand):-
	move(Toestand, NieuweToestand),
	simple_depth_first(NieuweToestand, EindToestand).

% solve_simple_depth_first/3. Zelfde als boven, met extra argument
% (arg3) waarin de verlopen tijd bijgehouden wordt (mbv get_time/1,
% built-in).

solve_simple_depth_first(Toestand, EindToestand, Time):-
	get_time(Start),
	simple_depth_first(Toestand, EindToestand),
	get_time(End),
	Time is End - Start.



/*
	PRINT-SERVICE
*/

% printMatrix/3. Zet een lijst van lijsten (Matrix, arg3) van gelijke
% lengte (Size, arg2) met elke Interval x Interval (arg1) submatrix
% afgescheiden door verticale en horizontale strepen. Dit is nodig om de
% kwadranten te onderscheiden in de printMatrix.


printMatrix(_, Size, []):-
	printVerticaleLijn(Size), nl.
printMatrix(Interval, Size, Matrix):-
	getFirstMembers(Interval, Matrix, Members, Rest),
	printVerticaleLijn(Size),nl,
	printRijen(Interval, Size, Members),
	printMatrix(Interval, Size, Rest).

% printMatrix/1. Specifieke versie van printMatrix voor
% standaard-sudoku's.

printMatrix(Matrix):-
	sudokuMaat(Size),
	N is Size * Size,
	printMatrix(Size, N, Matrix).

% getFirstMembers/4. Geeft de N (arg1) eerste elementen van een lijst
% (arg2) en levert deze af (arg3) en ook wat er overblijft nadat deze
% eerste N elementen zijn weggenomen (arg4).

getFirstMembers(0, L, [], L).
getFirstMembers(N, [H|T], [H|NT], Rest):-
	NN is N - 1,
	getFirstMembers(NN, T, NT, Rest).

% printRijen/2. Schrijft een lijst (arg2) op een enkele regel. De
% elementen worden gescheiden door spaties, en bovendien wordt om
% de Interval (arg1) elementen een horizontaal streepje neergezet.
% Ook het begin en het einde worden met een streepje gemarkeerd.
% Vb "?-printRij(3,[1,2,3,4,5,6])." geeft "| 1 2 3 | 4 5 6 |".

printRij(_, []):- write('|').
printRij(Interval, [H|T]):-
	getFirstMembers(Interval, [H|T], Members, Rest),
	write('|'),
	printRij(Members),
	printRij(Interval, Rest).

% printRij/1. Schrijft een lijst als zijn elementen gescheiden door
% spaties. Vb "?-printRij([1,2,3])." geeft "1 2 3".

printRij([]):- write(' ').
printRij([Head|Tail]):-
	write(' '),
	printGetal(Head),
	printRij(Tail).

% printRijen/3 De meervoudige versie van printRij/2, waarbij de
% verschillende rijen onder elkaar gezet worden. Het laatste argument is
% nu een matrix = lijst van lijsten van gelijke lengte. Die lengte moet
% in arg2 gespecificeerd worden. Het interval vd horizontale streepjes
% moet in arg1 gegeven worden. Vb
% "?printRijen(2,4,[[1,2,3,4],[5,6,7,8]])." geeft
% | 1 2 | 3 4 |
% | 5 6 | 7 8 |
% .

printRijen(_, _, []).
printRijen(Interval, Size, [Head|Tail]):-
	printRij(Interval, Head), nl,
	printRijen(Interval, Size, Tail).

% printGetal/1. Print een getal, alleen als arg1 een 0 is zet hij een
% punt neer om een lege plek in een Sudoku te markeren.

printGetal(0):-
	write('.').
printGetal(N):-
	N \= 0,
	write(N).

% printVerticaleLijn/2. Trekt een aantal (arg2) verticale lijnen.
% Arg1 is de breedte van de matrix waarvoor deze verticale lijn wordt
% gebruikt.

printVerticaleLijn(Size, Aantal):-
	Interval is floor(sqrt(Size)),
	Breedte is Aantal*((Size+2) * 2) + Interval,
	printLijnSymbool(Breedte).

% printVerticaleLijn/1. Trekte één verticale lijn. Arg1 is de breedte
% van de matrix waarvoor deze verticale lijn wordt gebruikt.

printVerticaleLijn(Size):-
	printVerticaleLijn(Size,1).


% printLijnSymbool/1. Print het lijnsymbool - een N (arg1) aantal keer
% achtereen.

printLijnSymbool(0).
printLijnSymbool(N):-
	N > 0, integer(N),
	write('-'),
	NN is N - 1,
	printLijnSymbool(NN).


/*
	Andere voorbeelden Sudoku's
*/

t0([
[1,0,0, 0,0,2, 7,6,0],
[2,0,0, 0,0,1, 0,0,8],
[0,3,6, 0,0,7, 0,0,4],

[0,0,0, 0,6,0, 8,7,2],
[6,0,7, 0,2,9, 0,0,0],
[0,0,0, 0,0,0, 0,0,0],

[0,8,0, 0,7,0, 3,0,0],
[0,1,3, 0,0,0, 5,0,0],
[0,0,0, 0,1,0, 0,9,7]
]).

t1([
[0,0,6, 0,0,0, 0,9,0],
[0,0,4, 0,0,9, 1,0,0],
[0,0,0, 0,0,6, 4,0,5],

[0,0,0, 6,0,0, 0,1,0],
[0,3,0, 0,0,8, 6,2,0],
[0,4,0, 0,0,3, 0,0,0],

[5,0,3, 0,0,0, 7,0,0],
[0,0,0, 7,0,0, 8,0,0],
[0,9,0, 0,2,0, 3,0,0]
]).

t2([
[0,0,0, 0,0,6, 0,0,0],
[0,5,0, 0,2,0, 0,0,0],
[7,0,0 ,0,9,0, 2,3,0],

[0,1,2, 0,3,0, 5,0,0],
[4,0,0, 0,0,0, 0,0,1],
[0,0,0, 0,6,0, 9,4,0],

[0,7,8, 0,0,0, 0,0,2],
[0,0,0, 0,4,0, 0,9,0],
[0,0,0, 1,0,0, 0,0,0]
]).


t3([
[7,0,0, 0,0,4, 0,5,0],
[0,0,0, 0,8,0, 0,0,0],
[0,2,0, 0,0,9, 0,3,0],

[2,0,9, 0,0,6, 0,1,0],
[0,0,0, 0,9,0, 0,0,4],
[8,5,0, 0,2,0, 0,0,0],

[0,6,0, 0,0,1, 3,0,5],
[0,0,7, 0,4,0, 0,0,0],
[3,0,0, 2,0,8, 4,0,0]
]).

t4([
[0,2,0, 0,6,0, 0,0,9],
[0,0,5, 1,0,0, 0,0,0],
[0,0,9, 4,0,0, 3,0,0],

[3,0,0, 9,0,0, 0,5,0],
[0,0,0, 0,0,0, 0,0,0],
[0,1,0, 0,0,8, 0,0,2],

[0,0,4, 0,0,6, 5,0,0],
[0,0,0, 0,0,9, 7,0,0],
[5,6,0, 0,2,0, 0,4,0]
]).

t5([
[0,0,0, 2,0,5, 7,0,0],
[7,5,0, 0,4,0, 0,0,0],
[2,0,0, 0,0,0, 0,9,5],

[0,2,3, 4,0,0, 0,0,0],
[9,0,0, 1,0,8, 0,0,7],
[0,0,0, 0,0,2, 9,3,0],

[1,9,0, 0,0,0, 0,0,6],
[0,0,0, 0,8,0, 0,1,4],
[0,0,2, 3,0,1, 0,0,0]
]).

t6([
[6,0,0, 0,0,3, 0,1,8],
[0,0,9, 5,0,0, 0,0,0],
[4,0,0, 0,7,0, 2,0,0],

[0,0,0, 0,0,1, 0,0,0],
[0,8,0, 0,2,0, 0,7,0],
[1,0,0, 8,0,0, 4,0,0],

[0,0,4, 0,8,0, 0,0,1],
[0,0,0, 0,0,7, 9,0,0],
[5,2,0, 6,0,0, 0,3,0]
]).

t7([
    [3,1,7, 0,0,0, 0,6,4],
    [0,6,0, 0,0,3, 0,0,0],
    [0,9,0, 0,0,0, 0,0,0],

    [2,0,5, 0,0,0, 0,1,0],
    [6,4,0, 0,0,0, 0,0,5],
    [0,8,0, 0,9,0, 0,0,0],

    [7,0,8, 4,5,9, 6,0,0],
    [0,0,1, 0,3,6, 0,4,0],
    [0,0,0, 1,2,0, 0,7,9]
]).








