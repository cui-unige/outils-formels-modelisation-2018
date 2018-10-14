/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet
{
    return PetriNet(
        places: [Place("p1"), Place("p0"), Place("b0"), Place("b1"), Place("b2")],
        transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3"), Transition("t4"), Transition("t5")],
        pre: { _, _ in 0 },
        post: { _, _ in 0 })
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {

    return { _ in 0 }
    return
    {
    switch ($0) {
        case Place("p1"): return 2
        case Place("p2"): return 2
        default: return 0
        }
    }
}
