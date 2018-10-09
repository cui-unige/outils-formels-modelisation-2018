/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  let places :Place = [Place("b0"),Place("b1"),Place("b2"),
  Place("p1"),Place("p1"),Place("p2"),Place("p3"),Place("p4")]

  let transitions: Transition = [Transition("t0"), Transition("t1")
  ,Transition("t2"), Transition("t3"),Transition("t4"), Transition("t5")]
  func pre(_ p: Place, _ t: Transition) -> Nat{
      switch (p,t) {
      case (Place("p1"),Transition("t0")): return 1
      case (Place("b0"),Transition("")): return 1

      default: return 0
      }
  }
  func post(_ p: Place, _ t: Transition) -> Nat {
    switch (p,t) {
    case (Place("b0"),Transition("t0")): return 1
    case (Place("p1"),Transition("t0")): return 1
    default: return 0
    }
  }
  return PetriNet(places: [], transitions: [], pre: { _, _ in 0 }, post: { _, _ in 0 })
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  return { _ in 0 }
}
