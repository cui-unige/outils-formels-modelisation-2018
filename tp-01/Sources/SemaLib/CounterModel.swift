/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.

  // On définit les préconditions (Entrées) de notre réseau de Pétri
  func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("debut"), Transition("t0")): return 1
    case (Place("d0"), Transition("t0")): return 1
    case (Place("b0"), Transition("t1")): return 1
    case (Place("debut"), Transition("t1")): return 1
    case (Place("d1"), Transition("t1")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("d2"), Transition("t2")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("debut"), Transition("t2")): return 1
    case (Place("b0"), Transition("t3")): return 1
    case (Place("b1"), Transition("t3")): return 1
    case (Place("b2"), Transition("t3")): return 1
    default: return 0
    }
  }

  // On définit les postconditions (Sorties) de notre réseau de Pétri
  func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("debut"), Transition("t3")): return 7
    case (Place("b0"), Transition("t0")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b2"), Transition("t2")): return 1
    case (Place("d0"), Transition("t1")): return 1
    case (Place("d0"), Transition("t2")): return 1
    case (Place("d1"), Transition("t2")): return 1
    case (Place("d0"), Transition("t3")): return 1
    case (Place("d1"), Transition("t3")): return 1
    case (Place("d2"), Transition("t3")): return 1
    default: return 0
    }
  }

  // On définit la variable binarymodel qui contient notre réseau de Pétri avec les entrées et sorties définies précédemment
  let binarymodel = PetriNet(
    places      : [Place("b2"), Place("b1"), Place("b0"), Place("d2"), Place("d1"), Place("d0"), Place("debut")],  // Le réseau contient 7 places
    transitions : [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],                        // Il contient 4 transitions
    pre         : pre,     // Il inclut les deux fonction pre et post
    post        : post)


  return binarymodel  // On retourne notre réseau de Pétri
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.

  // On définit le marquage initial de notre réseau de Pétri
  func initialMarkingCounter(_ place: Place) -> Nat { // On définit la fonction initialMarkingCounter qui renvoit le marquage initial de chaque place
    switch place {
    case Place("debut"): return 7
    case Place("b0"): return 0
    case Place("b1"): return 0
    case Place("b2"): return 0
    case Place("d0"): return 1
    case Place("d1"): return 1
    case Place("d2"): return 1
    default: return 0
    }
  }

  return initialMarkingCounter // On retourne la fonction initialMarkingCounter
}
