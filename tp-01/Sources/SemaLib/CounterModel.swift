// Define the preconditions of a simple Petri net.
private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("a2"), Transition("put1")): return 1
  case (Place("a1"), Transition("put1")): return 1
  case (Place("a0"), Transition("put1")): return 1

  case (Place("a2"), Transition("put2")): return 1
  case (Place("a1"), Transition("put2")): return 1
  case (Place("b0"), Transition("put2")): return 1

  case (Place("a2"), Transition("put3")): return 1
  case (Place("b1"), Transition("put3")): return 1
  case (Place("a0"), Transition("put3")): return 1

  case (Place("a2"), Transition("put4")): return 1
  case (Place("b1"), Transition("put4")): return 1
  case (Place("b0"), Transition("put4")): return 1

  case (Place("a1"), Transition("put5")): return 1
  case (Place("a0"), Transition("put5")): return 1
  case (Place("b2"), Transition("put5")): return 1

  case (Place("a1"), Transition("put6")): return 1
  case (Place("b2"), Transition("put6")): return 1
  case (Place("b0"), Transition("put6")): return 1

  case (Place("a0"), Transition("put7")): return 1
  case (Place("b2"), Transition("put7")): return 1
  case (Place("b1"), Transition("put7")): return 1

  case (Place("b2"), Transition("put8")): return 1
  case (Place("b1"), Transition("put8")): return 1
  case (Place("b0"), Transition("put8")): return 1
  default: return 0
  }
}

// Define the postconditions of a simple Petri net.
private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("a2"), Transition("put1")): return 1
  case (Place("a1"), Transition("put1")): return 1
  case (Place("b0"), Transition("put1")): return 1

  case (Place("a2"), Transition("put2")): return 1
  case (Place("a0"), Transition("put2")): return 1
  case (Place("b1"), Transition("put2")): return 1

  case (Place("a2"), Transition("put3")): return 1
  case (Place("b1"), Transition("put3")): return 1
  case (Place("b0"), Transition("put3")): return 1

  case (Place("a1"), Transition("put4")): return 1
  case (Place("a0"), Transition("put4")): return 1
  case (Place("b2"), Transition("put4")): return 1

  case (Place("a1"), Transition("put5")): return 1
  case (Place("b2"), Transition("put5")): return 1
  case (Place("b0"), Transition("put5")): return 1

  case (Place("a0"), Transition("put6")): return 1
  case (Place("b2"), Transition("put6")): return 1
  case (Place("b1"), Transition("put6")): return 1

  case (Place("b2"), Transition("put7")): return 1
  case (Place("b1"), Transition("put7")): return 1
  case (Place("b0"), Transition("put7")): return 1

  case (Place("a2"), Transition("put8")): return 1
  case (Place("a1"), Transition("put8")): return 1
  case (Place("a0"), Transition("put8")): return 1
  default: return 0
  }
}

// Define the structure of a simple Petri net.
let myCounter = PetriNet(
  places      : [Place("a0"), Place("a1"), Place("a2"), Place("b0"), Place("b1"), Place("b2")],
  transitions : [Transition("put1"), Transition("put2"), Transition("put3"), Transition("put4"), Transition("put5"), Transition("put6"), Transition("put7"), Transition("put8")],
  pre         : pre,
  post        : post)

/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  return myCounter
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  let initMarking: Marking = { place in
  switch place {
  case Place("a2"): return 1
  case Place("a1"): return 1
  case Place("a0"): return 1
  // The b_i places (i.e. the bits of the counter) are set to 0 by default.
  default: return 0
  }
  }


  return initMarking
}
