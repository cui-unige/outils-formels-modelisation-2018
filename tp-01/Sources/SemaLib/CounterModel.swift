
/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  // Define the preconditions of a simple Petri net.
func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("p0"), Transition("t0")): return 1
    case (Place("b0"), Transition("t1")): return 1
    case (Place("b0"), Transition("t3")): return 1
    case (Place("b0"), Transition("t5")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("b1"), Transition("t3")): return 1
    case (Place("b1"), Transition("t5")): return 1
    case (Place("p1"), Transition("t1")): return 1
    case (Place("p2"), Transition("t3")): return 1
    case (Place("b2"), Transition("t4")): return 1
    case (Place("b2"), Transition("t5")): return 1

    case (Place("p4"), Transition("t4")): return 1
    case (Place("p3"), Transition("t2")): return 1

    default: return 0
    }
  }

  // Define the postconditions of a simple Petri net.
 func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("b0"), Transition("t0")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("b2"), Transition("t3")): return 1
    case (Place("b2"), Transition("t4")): return 1
    case (Place("b0"), Transition("t4")): return 1
    case (Place("p1"), Transition("t4")): return 1

    case (Place("p0"), Transition("t5")): return 1
    case (Place("p1"), Transition("t5")): return 1
    case (Place("p2"), Transition("t5")): return 1
    case (Place("p3"), Transition("t5")): return 1
    case (Place("p4"), Transition("t5")): return 1

    case (Place("p3"), Transition("t4")): return 1
    case (Place("p3"), Transition("t5")): return 1
    case (Place("p4"), Transition("t5")): return 1

    default: return 0
    }
  }

  return PetriNet(
    places      : [Place("b0"),Place("b1"),Place("b2"),Place("p0"), Place("p1"),Place("p2"),Place("p3"),Place("p4")],
    transitions : [Transition("t0"),Transition("t1"), Transition("t2"),Transition("t3"),Transition("t4"),Transition("t5")],
    pre         : pre,
    post        : post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  return {
   if ($0 == Place("p0") || $0 == Place("p1") || $0 == Place("p2") || $0 == Place("p3") || $0 == Place("p4")){
          return 1
  }else {
        return 0
  }
  } //return { _ in 0 }
}
