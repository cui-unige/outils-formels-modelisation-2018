/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {

    func pre(p: Place,t: Transition) -> Nat{
        switch(p,t){
        case (Place("B0"),Transition("T2")): return 1
        case (Place("B0"),Transition("T001")): return 1
        case (Place("B0"),Transition("T000")): return 1
        case (Place("B1"),Transition("T001")): return 1
        case (Place("B1"),Transition("T000")): return 1
        case (Place("B2"),Transition("T000")): return 1
        case (Place("CP1"),Transition("T1")): return 1
        case (Place("CP2"),Transition("T2")): return 1

        default : return 0
        }
    }


    func post(p: Place,t: Transition) -> Nat{
        switch(p,t){
        case(Place("B0"),Transition("T1")): return 1
    case(Place("B1"),Transition("T2")): return 1
    case(Place("B2"),Transition("T001")): return 1
    case(Place("CP1"),Transition("T2")): return 1
    case(Place("CP1"),Transition("T001")): return 1
    case(Place("CP1"),Transition("T000")): return 1
    case(Place("CP2"),Transition("T000")): return 1
    case(Place("CP2"),Transition("T001")): return 1

        default : return 0
        }
    }

  return PetriNet(places: [Place("P1"),Place("P2"),Place("P3"),Place("Cp1"),Place("CP2")], transitions: [Transition("T1"), Transition("T2"), Transition("T3"),Transition("T001"), Transition("T000")], pre: pre, post: post)
}

public func createCounterInitialMarking() -> Marking {
    //This is the initial Marking for the 3 bits counter to work
    func initialMarking(_ place: Place) -> Nat {
        switch place {
        case Place("CP1"): return 1
        case Place("CP2"): return 1
        default: return 0
        }
    }
    return initialMarking;

}
