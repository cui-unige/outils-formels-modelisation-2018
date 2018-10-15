    // fait avec l'aide de Mark Tropin et David Rodrigues


// on cree les preconditions pour les differents cas
private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("a2"), Transition("put1")): return 1
  case (Place("a1"), Transition("put1")): return 1
  case (Place("a0"), Transition("put1")): return 1

  case (Place("a2"), Transition("put2")): return 1
  case (Place("a1"), Transition("put2")): return 1
  case (Place("b0"), Transition("put2")): return 1

  case (Place("a2"), Transition("put3")): return 1
  case (Place("b1"), Transition("put3")): return 1
  case (Place("a0"), Transition("put3")): return 1

  case (Place("a2"), Transition("put4")): return 1
  case (Place("b1"), Transition("put4")): return 1
  case (Place("b0"), Transition("put4")): return 1

  case (Place("a1"), Transition("put5")): return 1
  case (Place("a0"), Transition("put5")): return 1
  case (Place("b2"), Transition("put5")): return 1

  case (Place("a1"), Transition("put6")): return 1
  case (Place("b2"), Transition("put6")): return 1
  case (Place("b0"), Transition("put6")): return 1

  case (Place("a0"), Transition("put7")): return 1
  case (Place("b2"), Transition("put7")): return 1
  case (Place("b1"), Transition("put7")): return 1

  case (Place("b2"), Transition("put8")): return 1
  case (Place("b1"), Transition("put8")): return 1
  case (Place("b0"), Transition("put8")): return 1
  default: return 0
  }
}

// on cree les differents cas de postconditions
private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("a2"), Transition("put1")): return 1
  case (Place("a1"), Transition("put1")): return 1
  case (Place("b0"), Transition("put1")): return 1

  case (Place("a2"), Transition("put2")): return 1
  case (Place("a0"), Transition("put2")): return 1
  case (Place("b1"), Transition("put2")): return 1

  case (Place("a2"), Transition("put3")): return 1
  case (Place("b1"), Transition("put3")): return 1
  case (Place("b0"), Transition("put3")): return 1

  case (Place("a1"), Transition("put4")): return 1
  case (Place("a0"), Transition("put4")): return 1
  case (Place("b2"), Transition("put4")): return 1

  case (Place("a1"), Transition("put5")): return 1
  case (Place("b2"), Transition("put5")): return 1
  case (Place("b0"), Transition("put5")): return 1

  case (Place("a0"), Transition("put6")): return 1
  case (Place("b2"), Transition("put6")): return 1
  case (Place("b1"), Transition("put6")): return 1

  case (Place("b2"), Transition("put7")): return 1
  case (Place("b1"), Transition("put7")): return 1
  case (Place("b0"), Transition("put7")): return 1

  case (Place("a2"), Transition("put8")): return 1
  case (Place("a1"), Transition("put8")): return 1
  case (Place("a0"), Transition("put8")): return 1
  default: return 0
  }
}

// on deifini la liste des places et des transitions
let myCounter = PetriNet(
  places      : [Place("a0"), Place("a1"), Place("a2"), Place("b0"), Place("b1"), Place("b2")],
  transitions : [Transition("put1"), Transition("put2"), Transition("put3"), Transition("put4"), Transition("put5"), Transition("put6"), Transition("put7"), Transition("put8")],
  pre         : pre,
post : post)


// cette fonction fait appelle a PetriNet pour utiliser les places et les transition definis et retourne le resultat
public func createCounterModel() -> PetriNet {
  // Write your code here.
  return myCounter
  }




// cette fonction permet la creation des poins initial dans le reseaux de petri
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  let initMarking: Marking = { place in
  switch place {
  case Place("a2"): return 1
  case Place("a1"): return 1
  case Place("a0"): return 1

  default: return 0
  }
  }


  return initMarking
}
