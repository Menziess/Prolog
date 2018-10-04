# Prolog-Problem-Solving-And-Search

Some quick tools to get started on windows:

  - Install VSCode, Windows subsystem for Linux, Ubuntu
  - From VSCode press ```Ctrl + ` ``` to open the terminal, and enter ```bash```
  - Navigate to this project directory and install swi-prolog using ```sudo apt-get install swi-prolog```
  - Use ```swipl``` and ```consult(<filename>).``` to load a [.pl](#) file

If swipl returns:
```
?- consult('schenk.s.#').
true.
```
...it means the file is compiled. Run ```halt.``` to exit.
