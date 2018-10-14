/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  func pre(p: Place, t: Transition) -> Nat{
    switch (p, t) {
        // de 0 à 1
      case (Place("p"), Transition("t1")): return 1
        // de 1 à 2
      case (Place("b0"), Transition("t2")): return 1
        // de 2 à 3
      case (Place("b1"), Transition("t3")): return 1
        // de 3 à 4
      case (Place("b1"), Transition("t4")): return 1
      case (Place("b0"), Transition("t4")): return 1
        // de 4 à 5
      case (Place("b2"), Transition("t5")): return 1
        // de 5 à 6
      case (Place("b2"), Transition("t6")): return 1
      case (Place("b0"), Transition("t6")): return 1
        // de 6 à 7
      case (Place("b2"), Transition("t7")): return 1
        // de 7 à 0
      case (Place("b0"), Transition("t0")): return 1
      case (Place("b1"), Transition("t0")): return 1
      case (Place("b2"), Transition("t0")): return 1
      default: return 0

    }
  }

  func post(p: Place, t: Transition) -> Nat{
      switch (p, t) {
        // de 0 à 1
      case (Place("b0"), Transition("t1")): return 1
        // de 1 à 2
      case (Place("b1"), Transition("t2")): return 1
        // de 2 à 3
      case (Place("b1"), Transition("t3")): return 1
      case (Place("b0"), Transition("t3")): return 1
        // de 3 à 4
      case (Place("b2"), Transition("t4")): return 1
        // de 4 à 5
      case (Place("b2"), Transition("t5")): return 1
      case (Place("b0"), Transition("t5")): return 1
        // de 5 à 6
      case (Place("b2"), Transition("t6")): return 1
      case (Place("b1"), Transition("t6")): return 1
        // de 6 à 7
      case (Place("b0"), Transition("t7")): return 1
      case (Place("b1"), Transition("t7")): return 1
      case (Place("b2"), Transition("t7")): return 1
        // de 7 à 0
      case (Place("p"), Transition("t0")): return 1
      default: return 0
      }
  }



  return PetriNet(
    places     : [Place("p"), Place("b0"), Place("b1"), Place("b2")],
    transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3"), Transition("t4"), Transition("t5"), Transition("t6"), Transition("t7")],
    pre        : pre,
    post       : post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  func initialMarking(_ place: Place) -> Nat{
    switch place {
    case Place("p"): return 1
    default: return 0
    }
  }
  return initialMarking
}
