/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  return PetriNet(places: [], transitions: [], pre: { _, _ in 0 }, post: { _, _ in 0 })
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking(_ place: Place) -> Nat {
  switch place {
  case Place("b3"): return 1
  case Place("b4"): return 1
  case Place("b5"): return 1
  case Place("b6"): return 1
  default: return 0
  }
}
//Places and transition of the binary counter.
let petrinet = PetriNet(
  places      : [Place("bo"), Place("b1"),Place("b2"),Place("b3"), Place("b4"),Place("b6")],
  transitions : [Transition("t1"), Transition("t2"), Transition("t3")],
  pre         : pre,
  post        : post)

  //the input Matrix
  //   t1  t2  t3
  //b0 1   1   0
  //b1 1   0   0
  //b2 0   0   0
  //b3 1   0   0
  //b4 0   1   0
  //b5 0   1   0
  //b6 1   1   1
  private func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("b0"), Transition("t1")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b3"), Transition("t1")): return 1
    case (Place("b4"), Transition("t2")): return 1
    case (Place("b5"), Transition("t2")): return 1
    case (Place("b6"), Transition("t1")): return 1
    case (Place("b6"), Transition("t2")): return 1
    case (Place("b6"), Transition("t3")): return 1
    default: return 0
    }
  }

//the output matrix
//   t1  t2  t3
//b0 0   0   1
//b1 0   1   0
//b2 1   0   0
//b3 0   0   0
//b4 1   0   0
//b5 1   1   0
//b6 0   0   0
private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("b0"), Transition("t3")): return 1
  case (Place("b1"), Transition("t2")): return 1
  case (Place("b2"), Transition("t1")): return 1
  case (Place("b4"), Transition("t1")): return 1
  case (Place("b5"), Transition("t1")): return 1
  case (Place("b5"), Transition("t2")): return 1
  default: return 0
  }
}
