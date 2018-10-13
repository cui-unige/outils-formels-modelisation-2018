/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Write your code here.
  func pre(p: Place, t: Transition) -> Nat {
    switch (p, t) {
        case (Place("zero"), Transition("t0")): return 1

        case (Place("b0"), Transition("t1")): return 1
        case (Place("b0"), Transition("t2")): return 1
        case (Place("b0"), Transition("t4")): return 1

        case (Place("b1"), Transition("t4")): return 1
        case (Place("b1"), Transition("t2")): return 1

        case (Place("b2"), Transition("t4")): return 1

        case (Place("lim1"), Transition("t1")): return 1

        case (Place("lim2"), Transition("t3")): return 1

        case (Place("lim3"), Transition("t3")): return 1

        case (Place("lim4"), Transition("t5")): return 1

        case (Place("lim5"), Transition("t2")): return 1

        case (Place("zero"), Transition("t0")): return 1



    default: return 0
    }
  }
func post(p: Place, t: Transition) -> Nat {
    switch (p, t) {


        case (Place("b0"), Transition("t0")): return 1
        case (Place("b0"), Transition("t5")): return 1
        case (Place("b0"), Transition("t3")): return 1

        case (Place("b1"), Transition("t1")): return 1

        case (Place("b2"), Transition("t2")): return 1

        case (Place("lim1"), Transition("t5")): return 1
        case (Place("lim1"), Transition("t0")): return 1

        case (Place("lim2"), Transition("t1")): return 1

        case (Place("lim3"), Transition("t5")): return 1
        case (Place("lim3"), Transition("t4")): return 1

        case (Place("lim4"), Transition("t2")): return 1

        case (Place("lim5"), Transition("t4")): return 1

        case (Place("zero"), Transition("t4")): return 1

    default: return 0
    }
  }

  return PetriNet(
    places: [Place("b0"),Place("b1"),Place("b2"),Place("lim1"),Place("lim2"),Place("lim3"),Place("lim4"),
    Place("lim5"),Place("zero")],
    transitions: [Transition("t0"),Transition("t1"),Transition("t2"),Transition("t3"),Transition("t4"),Transition("t5")],
    pre: pre,
  post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking{
  // Write your code here.
  return{

              switch ($0) {

                  case (Place("lim3") ): return 1
                  case (Place("lim5")): return 1
                  case (Place("zero")): return 1


              default: return 0
          }
}
}
