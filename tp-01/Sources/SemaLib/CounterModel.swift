/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  // Define the preconditions of a simple Petri net.
  func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
      // pour les p
    case (Place("p1"), Transition("t1")): return 1
    case (Place("p2"), Transition("t2")): return 1
    case (Place("p3"), Transition("t3")): return 1
    case (Place("p4"), Transition("t4")): return 1
    case (Place("p5"), Transition("t5")): return 1
    case (Place("p6"), Transition("t6")): return 1
    case (Place("p7"), Transition("t7")): return 1
    // pour les b
    // pour  001
    case (Place("b0"), Transition("t2")): return 1
    // pour 010
    case (Place("b1"), Transition("t3")): return 1
    // pour 011
    case (Place("b0"), Transition("t4")): return 1
    case (Place("b1"), Transition("t4")): return 1
    // pour 100
    case (Place("b2"), Transition("t5")): return 1
    // pour 101
    case (Place("b0"), Transition("t6")): return 1
    case (Place("b3"), Transition("t6")): return 1
    // pour 111
    case (Place("b0"), Transition("t7")): return 1
    case (Place("b1"), Transition("t7")): return 1
    case (Place("b2"), Transition("t7")): return 1
    default: return 0
      //prcision on a enlever tous les transition qui retournaient 0 elle sont donnée par default
    }
  }

  // Define the postconditions of a simple Petri net.
   func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {
      // pour les p
    case (Place("p1"), Transition("t7")): return 1
    case (Place("p2"), Transition("t1")): return 1
    case (Place("p3"), Transition("t2")): return 1
    case (Place("p4"), Transition("t3")): return 1
    case (Place("p5"), Transition("t4")): return 1
    case (Place("p6"), Transition("t5")): return 1
    case (Place("p7"), Transition("t6")): return 1
      // pour les b
      //pour 001
    case (Place("b0"), Transition("t1")): return 1
      // pour 010
    case (Place("b1"), Transition("t2")): return 1
      // pour 011
    case (Place("b0"), Transition("t3")): return 1
    case (Place("b1"), Transition("t3")): return 1
      // pour 100
    case (Place("b2"), Transition("t4")): return 1
      // pour 101
    case (Place("b0"), Transition("t5")): return 1
    case (Place("b2"), Transition("t5")): return 1
      // pour 111
    case (Place("b0"), Transition("t6")): return 1
    case (Place("b1"), Transition("t6")): return 1
    case (Place("b2"), Transition("t6")): return 1
      // précistion pour les tous les sortie inexistantes on retourne 0 par default
    default: return 0
    }
  }

  // Define the structure of a simple Petri net.
  let petrinet = PetriNet(
    places      : [Place("p1"), Place("p2"), Place("p3"), Place("p4"), Place("p5"), Place("p6"), Place("p7"), Place("b0"), Place("b1"), Place("b2")],
    transitions : [Transition("t1"), Transition("t2"), Transition("t3"), Transition("t4"), Transition("t5"), Transition("t6"), Transition("t7")],
    pre         : pre,
    post        : post)

  return PetriNet(places: [], transitions: [], pre: { _, _ in 0 }, post: { _, _ in 0 })




}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.

  // Define the initial marking of a simple Petri net.
   func initialMarking(_ place: Place) -> Nat {
    switch place {  // on était pas obliger de toutes les écrire car le default retour 0 au pire
                    // mais j'ai commencer de cette manière donc j'ai continué
    case Place("p1"): return 1
    case Place("p2"): return 0
    case Place("p3"): return 0
    case Place("p4"): return 0
    case Place("p5"): return 0
    case Place("p6"): return 0
    case Place("p7"): return 0
    case Place("b0"): return 0
    case Place("b1"): return 0
    case Place("b2"): return 0
    default: return 0
    }
}

  return { _ in 0 }
}
