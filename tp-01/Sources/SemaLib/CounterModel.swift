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
  // The model works as follows:
  // There are 6 places: (a2, a1, a0) and (b2, b1, b0).
  // There are 8 transitions: putN, where N is the number to be displayed by the counter.
  // The b_i places represent the bits of the counter; the a_i places represent their negations.
  // This means that if b=010, the value of a is 101.

  // When a putN transition is fired, we remove all previous tokens and
  // add the tokens that correspond to N.
  // For example, if we want to do 101 -> 110:
  // b2,b0 and a1 tokens are removed.
  // New tokens are placed in b2,b1 and a0.
  return myCounter
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
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
