/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  func pre(p: Place, t: Transition) -> Nat { /// défini les pré-conditions
    switch (p, t) { //Selon les places et les transitions
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

  func post(p: Place, t: Transition) -> Nat { ///défini les post-conditions
    switch (p, t) { //Selon les places et les transitions
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
  //On retourne le pétrinet
  return PetriNet(places: [Place("b0"), Place("b1"),Place("b2"),Place("p1"),Place("p2"),Place("p3")], transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")], pre: pre, post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  func initialMarking(_ place: Place) -> Nat { //Créé le marquage initial
    switch place { //Selon la place
    case Place("p1"): return 1 //On initialise les jetons des places p1,p2 et p3 à 1 et les autres à 0
    case Place("p3"): return 1
    case Place("p2"): return 1
    default: return 0
    }
  }
  return initialMarking //On retourne le marquage initial
}
