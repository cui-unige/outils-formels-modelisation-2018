// Initialisation des preconditions
private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("s"), Transition("t3")): return 4
  case (Place("b0"), Transition("t0")): return 1
  case (Place("b1"), Transition("t1")): return 1
  case (Place("b2"), Transition("t2")): return 1
  default: return 0
  }
}
// Initialisation des postconditions
private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("s"), Transition("t0")): return 1
  case (Place("b0"), Transition("t1")): return 1
  case (Place("b0"), Transition("t2")): return 1
  case (Place("b0"), Transition("t3")): return 1
  case (Place("b1"), Transition("t2")): return 1
  case (Place("b1"), Transition("t3")): return 1
  case (Place("b2"), Transition("t3")): return 1
  default: return 0
  }
}

let petrinet = PetriNet(
  places      : [Place("s"), Place("b0"), Place("b1"), Place("b2")],
  transitions : [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
  pre         : pre,
  post        : post)

/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  return PetriNet(places: [Place("s"), Place("b0"), Place("b1"), Place("b2")], transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")], pre: { _, _ in 0 }, post: { _, _ in 0 })
}

/// This function returns the initial marking corresponding to the model of your binary counter.
/*
switch place {
case Place("p0"): return 1
default: return 0
}
*/
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  return  {

  switch ($0){
  case (Place("s")): return 4
  default: return 0
  }
  }
}



/*
  private func initialMarking(_ place: Place) -> Nat {

  }*/
