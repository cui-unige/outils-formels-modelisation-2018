/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
    //This is a PetriNet wich is a counter on 3 bits and it's bounded because of the t3 transition
    func pre(p: Place,t: Transition) -> Nat{
        switch(p,t){
        case(Place("b0"), Transition("t0")): return 1

        case(Place("b1"), Transition("t1")): return 1
        case(Place("p0"), Transition("t1")): return 1

        case(Place("b2"), Transition("t2")): return 1
        case(Place("p1"), Transition("t2")): return 1
        case(Place("p0"), Transition("t2")): return 1

        case(Place("p0"), Transition("t3")): return 1
        case(Place("p1"), Transition("t3")): return 1
        case(Place("p2"), Transition("t3")): return 1

        default : return 0
        }
    }


    func post(p: Place,t: Transition) -> Nat{
        switch(p,t){
        case(Place("p0"), Transition("t0")): return 1

        case(Place("p1"), Transition("t1")): return 1
        case(Place("b0"), Transition("t1")): return 1

        case(Place("p2"), Transition("t2")): return 1
        case(Place("b1"), Transition("t2")): return 1
        case(Place("b0"), Transition("t2")): return 1

        case(Place("b0"), Transition("t3")): return 1
        case(Place("b1"), Transition("t3")): return 1
        case(Place("b2"), Transition("t3")): return 1

        default : return 0
        }
    }

  return PetriNet(places: [Place("b0"),Place("b1"),Place("b2"),Place("p0"),Place("p1"),Place("p2")], transitions: [Transition("t0"),Transition("t1"),Transition("t2"), Transition("t3")], pre: pre, post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
    //This is the initial Marking for the 3 bits counter to work
    func initialMarking(_ place: Place) -> Nat {
        switch place {
        case Place("p0"): return 1
        case Place("p1"): return 1
        case Place("p2"): return 1
        default: return 0
        }
    }
    return initialMarking;
}
