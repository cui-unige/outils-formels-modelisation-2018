/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  // Preconditions : Place -> Transition
  func pre(p: Place, t: Transition) -> Nat {
    switch t {
    case Transition("t0"):
      switch p {
      case Place("a0"), Place("t0"): return 1
      default: return 0
      }
    case Transition("t1"):
      switch p {
      case Place("a1"), Place("b0"): return 1
      default: return 0
      }
    case Transition("t2"):
      switch p {
      case Place("a2"), Place("b0"), Place("b1"): return 1
      default: return 0
      }
    case Transition("t3"):
      switch p {
      case Place("b0"), Place("b1"), Place("b2"): return 1
      default: return 0
      }
    default: return 0
    }
  }
  // Postconditions : Transition -> Place
  func post(p: Place, t: Transition) -> Nat {
    switch t {
    case Transition("t0"):
      switch p {
      case Place("b0"): return 1
      default: return 0
      }
    case Transition("t1"):
      switch p {
      case Place("b1"), Place("a0"): return 1
      default: return 0
      }
    case Transition("t2"):
      switch p {
      case Place("b2"), Place("a0"), Place("a1"): return 1
      default: return 0
      }
    case Transition("t3"):
      switch p {
      case Place("a0"), Place("a1"), Place("a2"): return 1
      default: return 0
      }
    default: return 0
    }
  }
  return PetriNet(
    places: [Place("a0"), Place("a1"), Place("a2"), Place("b0"), Place("b1"), Place("b2")],
    transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
    pre: pre,
    post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  func initialMarking(_ place: Place) -> Nat {
    switch place {
    case Place("a0"), Place("a1"), Place("a2"): return 1
    default: return 0
    }
  }
  return initialMarking
}
