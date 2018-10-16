
//  On définir les places (binares & celle qui contient des jetons)
let b0 = Place("b0")
let b1 = Place("b1")
let b2 = Place("b2")
let p0 = Place("p0")
let p1 = Place("p1")
let p2 = Place("p2")

// On définit les transitions

let t0 = Transition("t0")
let t1 = Transition("t1")
let t2 = Transition("t2")
let t3 = Transition("t3")



func pre1(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    // On attribue 1 à tous les preconditions possibles de tous les transition
    case (p0, t0): return 1
    case (p1, t1): return 1
    case (p2, t2): return 1

    case (b0, t1): return 1
    case (b0, t2): return 1
    case (b0, t3): return 1
    case (b1, t2): return 1
    case (b1, t3): return 1
    case (b2, t3): return 1

    // et le reste égal à zero
    default: return 0
    }
}

func post1(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    // On attribue 1 à tous les postconditions possibles de tous les transition
    case (b0, t0): return 1
    case (b1, t1): return 1
    case (b2, t2): return 1

    case (p0, t1): return 1
    case (p0, t2): return 1
    case (p0, t3): return 1
    case (p1, t2): return 1
    case (p1, t3): return 1
    case (p2, t3): return 1

    // et le reste égal à zero
    default: return 0
    }
}

public func createCounterModel() -> PetriNet {
    return PetriNet(places: [p0,p1,p2,b0,b1,b2], transitions: [t0,t1,t2,t3], pre: pre1, post: post1)
}



func initialMarking(_ place: Place) -> Nat {
    switch place {
    // On initialise le compteur, c'est à dire b0 = 0 , b1 = 1 , b2 = 0 et le reste égal à un.
    case p0: return 1
    case p1: return 1
    case p2: return 1

    default: return 0
    }
}

/// This function returns the initial marking corresponding to the model of your binary counter
public func createCounterInitialMarking() -> Marking {
    return initialMarking
}
