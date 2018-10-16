
/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  func pre(p: Place, t: Transition) -> Nat { /// définit les pré-conditions de notre réseau de pétri
    switch (p, t) {
    case (Place("p1"), Transition("t0")): return 1

    case (Place("b0"), Transition("t1")): return 1
    case (Place("p2"), Transition("t1")): return 1

    case (Place("p3"), Transition("t2")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b1"), Transition("t2")): return 1

    case (Place("b0"), Transition("t3")): return 1
    case (Place("b1"), Transition("t3")): return 1
    case (Place("b2"), Transition("t3")): return 1
    default: return 0
    }
  }

  func post(p: Place, t: Transition) -> Nat { ///définit les post-conditions de notre réseau de pétri
    switch (p, t) {
    case (Place("b0"), Transition("t0")): return 1

    case (Place("b1"), Transition("t1")): return 1
    case (Place("p1"), Transition("t1")): return 1

    case (Place("p1"), Transition("t2")): return 1
    case (Place("b2"), Transition("t2")): return 1
    case (Place("p2"), Transition("t2")): return 1

    case (Place("p3"), Transition("t3")): return 1
    case (Place("p2"), Transition("t3")): return 1
    case (Place("p1"), Transition("t3")): return 1

    default: return 0
    }
  }
	// on renvoie notre reseau de pétri
  return PetriNet(places: [Place("b0"), Place("b1"),Place("b2"),Place("p1"),Place("p2"),Place("p3")], transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")], pre: pre, post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
	// marquage initial : p1 = p2 = p3 = 1, reste à 0.
  func initialMarking(_ place: Place) -> Nat {
    switch place {
    case Place("p1"): return 1
    case Place("p3"): return 1
    case Place("p2"): return 1
    default: return 0
    }
  }
  return initialMarking
}
