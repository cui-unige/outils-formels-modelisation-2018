/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  //fonction pour préconditions.
  func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {

      case (Place("p"), Transition("t1")): return 1

      case (Place("b0"), Transition("t2")): return 1
      case (Place("b0"), Transition("t4")): return 1
      case (Place("b0"), Transition("t6")): return 1
      case (Place("b0"), Transition("t0")): return 1

      case (Place("b1"), Transition("t3")): return 1
      case (Place("b1"), Transition("t4")): return 1
      case (Place("b1"), Transition("t7")): return 1
      case (Place("b1"), Transition("t0")): return 1

      case (Place("b2"), Transition("t5")): return 1
      case (Place("b2"), Transition("t6")): return 1
      case (Place("b2"), Transition("t7")): return 1
      case (Place("b2"), Transition("t0")): return 1

      default: return 0
    }
  }
  //fonction pour postconditions.
  func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {

      case (Place("b0"), Transition("t1")): return 1 //001

      case (Place("b1"), Transition("t2")): return 1 //010

      //011
      case (Place("b0"), Transition("t3")): return 1
      case (Place("b1"), Transition("t3")): return 1

      case (Place("b2"), Transition("t4")): return 1 //100

        //101
      case (Place("b0"), Transition("t5")): return 1
      case (Place("b2"), Transition("t5")): return 1

        //110
      case (Place("b1"), Transition("t6")): return 1
      case (Place("b2"), Transition("t6")): return 1

        //111
      case (Place("b0"), Transition("t7")): return 1
      case (Place("b1"), Transition("t7")): return 1
      case (Place("b2"), Transition("t7")): return 1

      case (Place("p"), Transition("t0")): return 1 //000

      default: return 0
    }
  }

  return PetriNet(
    places: [Place("p"), Place("b0"), Place("b1"), Place("b2")],
    transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3"), Transition("t4"), Transition("t5"), Transition("t6"), Transition("t7")],
    pre: pre,
    post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  func initialMarking(_ place: Place) -> Nat {
    //commence uniquement par "p" car a le marqueur inital.
    switch place {
    case Place("p"): return 1
    default: return 0
    }
  }
  return initialMarking
}
