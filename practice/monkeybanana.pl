
move(state(middle, onbox, middle, hasnot), 
  grasp,
  state(middle, onbox, middle, has)).

move(state(Pos, onfloor, Pos, Has), 
  climb,
  state(Pos, onbox, Pos, Has)).

move(state(Pos1, onfloor, Pos1, Has), 
  push(Pos1, Pos2),
  state(Pos2, onfloor, Pos2, Has)).

move(state(Pos1, onfloor, Box, Has), 
  walk(Pos1, Pos2),
  state(Pos2, onfloor, Box, Has)).

canget(state(_,_,_,has)).
canget(State1) :- 
  move(State1, Move, State2), 
  canget(State2).

/* examples
?- canget(state(middle, onfloor, middle, hasnot))
true.
*/