/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  // Define the preconditions of a simple Petri net.
 func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("p0"), Transition("t0")): return 1
    case (Place("b0"), Transition("t1")): return 1
    case (Place("p1"), Transition("t1")): return 1
    case (Place("b0"), Transition("t2")): return 1
    case (Place("b1"), Transition("t2")): return 1
    case (Place("p2"), Transition("t2")): return 2
    case (Place("b0"), Transition("t3")): return 1
    case (Place("b1"), Transition("t3")): return 1
    case (Place("b2"), Transition("t3")): return 1
    default: return 0
      //précision, on a enlever tous les transitions qui retournaient 0 elle sont données par default
    }
  }

  // Define the postconditions of a simple Petri net.
   func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
    case (Place("b0"), Transition("t0")): return 1
    case (Place("p0"), Transition("t1")): return 1
    case (Place("b1"), Transition("t1")): return 1
    case (Place("b2"), Transition("t2")): return 1
    case (Place("p0"), Transition("t2")): return 1
    case (Place("p1"), Transition("t2")): return 1
    case (Place("p0"), Transition("t3")): return 1
    case (Place("p1"), Transition("t3")): return 1
    case (Place("p2"), Transition("t3")): return 1
      // précistion pour les tous les sortie inexistantes on retourne 0 par default
    default: return 0
    }
  }

  // Define the structure of a simple Petri net.
  // on ajoute les place et les transitions de notre réseau de petri avec les entrée sortie données par post et pre
  let petrinet = PetriNet(
    places      : [Place("p0"), Place("p1"), Place("p2"), Place("b0"), Place("b1"), Place("b2")],
    transitions : [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
    pre         : pre,
    post        : post)

  return petrinet



}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  return // Define the initial marking of a simple Petri net.
    { switch ($0) {  // on était pas obliger de toutes les écrire car le default retour 0 au pire
                    // mais j'ai commencer de cette manière donc j'ai continué on fait donc une closure pour récupérer la place de marking
    case Place("p0"): return 4 // on ajoute 4 pour que le réseau fasse circuler toujours 4 jetons
    case Place("p1"): return 0
    case Place("p2"): return 0
    case Place("b0"): return 0
    case Place("b1"): return 0
    case Place("b2"): return 0
    default: return 0
    }
}
}
