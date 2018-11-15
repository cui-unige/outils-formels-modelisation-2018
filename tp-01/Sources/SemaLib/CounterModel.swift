// Made by Paul Lucas & Marc Heimendinger

/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  let Places: Set<Place> = [Place("b0"), Place("b1"), Place("b2"), Place("Ib0"), Place("Ib1"), Place("Ib2")]
  let Transitions: Set<Transition> = [Transition("t1"), Transition("t2"), Transition("t100"), Transition("t000")]

  func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b0"), Transition("t100")): return 1
    case (Place("b0"), Transition("t000")): return 1
    case (Place("b1"), Transition("t000")): return 1
    case (Place("b1"), Transition("t100")): return 1
    case (Place("b2"), Transition("t000")): return 1
    case (Place("Ib0"), Transition("t1")): return 1
    case (Place("Ib1"), Transition("t2")): return 1
    case (Place("Ib2"), Transition("t100")): return 1
    default: return 0
    }
  }

  func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("b0"), Transition("t1")): return 1
    case (Place("Ib0"), Transition("t2")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("Ib0"), Transition("t000")): return 1
    case (Place("Ib1"), Transition("t000")): return 1
    case (Place("Ib2"), Transition("t000")): return 1
    case (Place("Ib0"), Transition("t100")): return 1
    case (Place("Ib1"), Transition("t100")): return 1
    case (Place("b2"), Transition("t100")): return 1
    default: return 0
    }
  }

  return PetriNet(places: Places, transitions: Transitions, pre: pre, post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  func initialMarking(_ place: Place) -> Nat {
    switch place {
    case Place("Ib0"): return 1
    case Place("Ib1"): return 1
    case Place("Ib2"): return 1
    default: return 0
    }
  }
  return initialMarking
}
