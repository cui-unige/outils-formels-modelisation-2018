/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {

  // note, pour un compteur plus gros, on pourrait calculer
  // la transition en parsant le nom de la transition.
  // mais vu le nombre de noeud, on ne va pas faire ça.

  // on doit toujours être à l'integer d'avant
  let pre = { ( p: Place, t: Transition ) -> Nat in 
    switch (p,t) {
      case (Place("!b0"), Transition("0→1")): return 1
      case (Place("!b1"), Transition("0→1")): return 1
      case (Place("!b2"), Transition("0→1")): return 1

      case (Place( "b0"), Transition("1→2")): return 1
      case (Place("!b1"), Transition("1→2")): return 1
      case (Place("!b2"), Transition("1→2")): return 1

      case (Place("!b0"), Transition("2→3")): return 1
      case (Place( "b1"), Transition("2→3")): return 1
      case (Place("!b2"), Transition("2→3")): return 1

      case (Place( "b0"), Transition("3→4")): return 1
      case (Place( "b1"), Transition("3→4")): return 1
      case (Place("!b2"), Transition("3→4")): return 1

      case (Place("!b0"), Transition("4→5")): return 1
      case (Place("!b1"), Transition("4→5")): return 1
      case (Place( "b2"), Transition("4→5")): return 1

      case (Place( "b0"), Transition("5→6")): return 1
      case (Place("!b1"), Transition("5→6")): return 1
      case (Place( "b2"), Transition("5→6")): return 1

      case (Place("!b0"), Transition("6→7")): return 1
      case (Place( "b1"), Transition("6→7")): return 1
      case (Place( "b2"), Transition("6→7")): return 1

      case (Place( "b0"), Transition("7→0")): return 1
      case (Place( "b1"), Transition("7→0")): return 1
      case (Place( "b2"), Transition("7→0")): return 1
      default: return 0
    }
  }

  // la valeur de l'integer après
  let post = { ( p: Place, t: Transition ) -> Nat in 
    switch (p,t) {
      case (Place( "b0"), Transition("0→1")): return 1
      case (Place("!b1"), Transition("0→1")): return 1
      case (Place("!b2"), Transition("0→1")): return 1

      case (Place("!b0"), Transition("1→2")): return 1
      case (Place( "b1"), Transition("1→2")): return 1
      case (Place("!b2"), Transition("1→2")): return 1

      case (Place( "b0"), Transition("2→3")): return 1
      case (Place( "b1"), Transition("2→3")): return 1
      case (Place("!b2"), Transition("2→3")): return 1

      case (Place("!b0"), Transition("3→4")): return 1
      case (Place("!b1"), Transition("3→4")): return 1
      case (Place( "b2"), Transition("3→4")): return 1

      case (Place( "b0"), Transition("4→5")): return 1
      case (Place("!b1"), Transition("4→5")): return 1
      case (Place( "b2"), Transition("4→5")): return 1

      case (Place("!b0"), Transition("5→6")): return 1
      case (Place( "b1"), Transition("5→6")): return 1
      case (Place( "b2"), Transition("5→6")): return 1

      case (Place( "b0"), Transition("6→7")): return 1
      case (Place( "b1"), Transition("6→7")): return 1
      case (Place( "b2"), Transition("6→7")): return 1

      case (Place( "!b0"), Transition("7→0")): return 1
      case (Place( "!b1"), Transition("7→0")): return 1
      case (Place( "!b2"), Transition("7→0")): return 1
      default: return 0
    }
  }

  // le réseau à retourner.
  return PetriNet(
    places: [
      Place( "b0"),Place( "b1"),Place( "b2"),
      Place("!b0"),Place("!b1"),Place("!b2"),
    ],
    transitions: [
      Transition("0→1"),
      Transition("1→2"),
      Transition("2→3"),
      Transition("3→4"),
      Transition("4→5"),
      Transition("5→6"),
      Transition("6→7"),
      Transition("7→0"),
    ],
    pre: pre,
    post: post
  )
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  return { (place: Place) in 
  switch place {
    case Place("!b0"): return 1
    case Place("!b1"): return 1
    case Place("!b2"): return 1
    default: return 0
  }
  }
}
