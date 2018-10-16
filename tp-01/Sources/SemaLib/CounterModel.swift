var p0 = Place("p0")
var p1 = Place("p1")
var p2 = Place("p2")
var b0 = Place("b0")
var b1 = Place("b1")
var b2 = Place("b2")
var t0 = Transition("t0")
var t1 = Transition("t1")
var t2 = Transition("t2")
var t3 = Transition("t3")

func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (b0, t0): return 1
    case (p0, t1): return 1
    case (b1, t1): return 1
    case (b2, t2): return 1
    case (p0, t2): return 1
    case (p1, t2): return 1
    case (p0, t3): return 1
    case (p1, t3): return 1
    case (p2, t3): return 1
    default: return 0
    }
}


func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (p0, t0): return 1
    case (b0, t1): return 1
    case (p1, t1): return 1
    case (b0, t2): return 1
    case (b1, t2): return 1
    case (p2, t2): return 1
    case (b0, t3): return 1
    case (b1, t3): return 1
    case (b2, t3): return 1
    default: return 0
    }
}


func initialMarking(_ place: Place) -> Nat {
    switch place {
    case p0: return 1
    case p1: return 1
    case p2: return 1
    default: return 0
    }
}

public func createCounterInitialMarking() -> Marking {
  return initialMarking
}

public func createCounterModel() -> PetriNet {
return PetriNet(places: [p0,p1,p2,b0,b1,b2], transitions: [t0,t1,t2,t3], pre: pre, post: post)
}
