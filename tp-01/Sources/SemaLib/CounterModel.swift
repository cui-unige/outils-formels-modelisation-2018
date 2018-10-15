/// This function creates the model of a binary counter on three bits.
// Input : None
// Output : A Petri net with 4 transitions and 6 places
public func createCounterModel() -> PetriNet {
  func pre(p: Place, t: Transition) -> Nat { // Define a function for the preconditions
    switch (p, t) {
    case (Place("b0"), Transition("t1")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b0"), Transition("t3")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("b1"), Transition("t3")): return 1
    case (Place("b2"), Transition("t3")): return 1
    case (Place("c0"), Transition("t0")): return 1
    case (Place("c1"), Transition("t1")): return 1
    case (Place("c2"), Transition("t2")): return 1
    default: return 0
    }
  }

  func post(p: Place, t: Transition) -> Nat { // Define a function for the postconditions
    switch (p, t) {
    case (Place("b0"), Transition("t0")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b2"), Transition("t2")): return 1
    case (Place("c0"), Transition("t1")): return 1
    case (Place("c0"), Transition("t2")): return 1
    case (Place("c0"), Transition("t3")): return 1
    case (Place("c1"), Transition("t2")): return 1
    case (Place("c1"), Transition("t3")): return 1
    case (Place("c2"), Transition("t3")): return 1
    default: return 0
    }
  }
  return PetriNet(
    places: [Place("b0"),Place("b1"),Place("b2"),Place("c0"),Place("c1"),Place("c2")],
    transitions: [Transition("t0"),Transition("t1"),Transition("t2"),Transition("t3")],
    pre: pre,
    post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
// Input : None
// Output : The initial marking
public func createCounterInitialMarking() -> Marking {
  func initialMarking(_ place: Place) -> Nat {
    switch place {
    case Place("c0"): return 1
    case Place("c1"): return 1
    case Place("c2"): return 1
    default: return 0
    }
  }
  return initialMarking
}
