/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  // Similaire à l'exo 2

  // Creation du modele :
  // Places : b0,b1,b2 pour le code binaire
  //          s0,s1,s2 pour les tmp,
  //          d0 pour le debut
  // Transitions : t0,t1,t2,tf

  // Les préconditions :
  func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("d0"), Transition("t0")): return 1
    case (Place("s0"), Transition("t0")): return 1
    case (Place("d0"), Transition("t1")): return 1
    case (Place("s1"), Transition("t1")): return 1
    case (Place("b0"), Transition("t1")): return 1
    case (Place("d0"), Transition("t2")): return 1
    case (Place("s2"), Transition("t2")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("b0"), Transition("tf")): return 1
    case (Place("b1"), Transition("tf")): return 1
    case (Place("b2"), Transition("tf")): return 1
    default: return 0
    }
  }

  // Les postconditions :
  func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("b0"), Transition("t0")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b2"), Transition("t2")): return 1
    case (Place("d0"), Transition("tf")): return 1
    case (Place("s0"), Transition("tf")): return 1
    case (Place("s1"), Transition("tf")): return 1
    case (Place("s2"), Transition("tf")): return 1
    default: return 0
    }
  }

  let model = PetriNet(
    places     : [Place("d0"), Place("b0"), Place("b1"), Place("b2"), Place("s0"), Place("s1"), Place("s2")],
    transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("tf")],
    pre        : pre,
    post       : post)
  

  return model
  //return PetriNet(places: [], transitions: [], pre: { _, _ in 0 }, post: { _, _ in 0 })
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  // Similaire à l'exo 2

  func initialMarking(_ place: Place) -> Nat {
    switch place {
    case Place("d0"): return 7
    case Place("s0"): return 1
    case Place("s1"): return 1
    case Place("s2"): return 1
    default: return 0
    }
  }

  return initialMarking
  //return { _ in 0 }
}
