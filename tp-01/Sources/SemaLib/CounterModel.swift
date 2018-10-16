/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {

  // Define the preconditions
 func pre(p: Place, t: Transition) -> Nat {
   switch t {
   case Transition("t0"):
     switch p {
     case Place("b0c"): return 1
     default: return 0
     }
   case Transition("t1"):
     switch p {
     case Place("b1c"), Place("b0"): return 1
     default: return 0
     }
   case Transition("t2"):
     switch p {
     case Place("b2c"), Place("b0"),  Place("b1"): return 1
     default: return 0
     }
   case Transition("tR"):
     switch p {
     case Place("b0"), Place("b1"), Place("b2"): return 1
     default: return 0
     }
   default: return 0
   }
  }

  // Define the postconditions
 func post(p: Place, t: Transition) -> Nat {
   switch t {
   case Transition("t0"):
     switch p {
     case Place("b0"): return 1
     default: return 0
     }
   case Transition("t1"):
     switch p {
     case Place("b1"), Place("b0c"): return 1
     default: return 0
     }
   case Transition("t2"):
     switch p {
     case Place("b2"), Place("b0c"),  Place("b1c"): return 1
     default: return 0
     }
   case Transition("tR"):
     switch p {
     case Place("b0c"), Place("b1c"), Place("b2c"): return 1
     default: return 0
     }
   default: return 0
   }
  }

  // Define the structure
  let petrinet = PetriNet(
    places      : [ Place("b0"), Place("b0c"),
                    Place("b1"), Place("b1c"),
                    Place("b2"), Place("b2c")],
    transitions : [ Transition("t0"), Transition("t1"), Transition("t2"), Transition("tR")],
    pre         : pre,
    post        : post)

  // Return the petrinet
  return petrinet
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {

 func initialMarking(_ place: Place) -> Nat {
    switch place {
    case Place("b0c"), Place("b1c"), Place("b2c"): return 1
    default: return 0
    }
  }

  return initialMarking
}
