/// This function creates the model of a binary counter on three bits.
private func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("p0"), Transition("t0")): return 1
    case (Place("p1"), Transition("t3")): return 1
    case (Place("b0"), Transition("t1")): return 1
    case (Place("b0"), Transition("t3")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("b1"), Transition("t3")): return 1
    case (Place("b2"), Transition("t4")): return 1
    case (Place("b2"), Transition("t5")): return 1
    case (Place("b1"), Transition("t5")): return 1
    case (Place("b0"), Transition("t5")): return 1
    default: return 0
    }
}

private func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("p0"), Transition("t5")): return 1
    case (Place("p1"), Transition("t5")): return 1
    case (Place("b0"), Transition("t0")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b0"), Transition("t4")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("b2"), Transition("t3")): return 1
    case (Place("b2"), Transition("t4")): return 1
    default: return 0
    }
}

public func createCounterModel() -> PetriNet {
  return PetriNet(places: [Place("b2"), Place("b1"), Place("b0"), Place("p0"), Place("p1")], transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3"), Transition("t4"), Transition("t5")], pre: pre, post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
     func initialMarking(_ place: Place) -> Nat {
        switch place {
        case Place("p0"): return 1
        case Place("p1"): return 1
        default: return 0
        }
    }
    return initialMarking
}
