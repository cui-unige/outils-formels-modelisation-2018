/*
------------------------------------------------------------------------------
# NAME : CounterModel.swift
#
# PURPOSE : Implementation of a binary counter model and its initial marking
#
# AUTHOR : Benjamin Fischer
#
# CREATED : 12.10.2018
-----------------------------------------------------------------------------
*/

/*
------------------------------------------------------------------------------
METHOD : createCounterModel() -> PetriNet

PURPOSE : Creates the model of a binary counter on three bits

INPUT : -

OUTPUT : PetriNet modeling a binary counter on three bits
-----------------------------------------------------------------------------
*/
public func createCounterModel() -> PetriNet {

  // Preconditions of the binary counter model
  func pre(p: Place, t: Transition) -> Nat {

    switch (p, t) {
        case (Place("b0"), Transition("t0")) : return 1

        case (Place("b1"), Transition("t1")) : return 1
        case (Place("a0"), Transition("t1")) : return 1

        case (Place("b2"), Transition("t2")) : return 1
        case (Place("a0"), Transition("t2")) : return 1
        case (Place("a1"), Transition("t2")) : return 1

        case (Place("a0"), Transition("t3")) : return 1
        case (Place("a1"), Transition("t3")) : return 1
        case (Place("a2"), Transition("t3")) : return 1

        default : return 0

    }
  }

  // Postconditions of the binary counter model
  func post(p: Place, t: Transition) -> Nat {

    switch (p, t) {
        case (Place("a0"), Transition("t0")) : return 1

        case (Place("b0"), Transition("t1")) : return 1
        case (Place("a1"), Transition("t1")) : return 1

        case (Place("b0"), Transition("t2")) : return 1
        case (Place("b1"), Transition("t2")) : return 1
        case (Place("a2"), Transition("t2")) : return 1

        case (Place("b0"), Transition("t3")) : return 1
        case (Place("b1"), Transition("t3")) : return 1
        case (Place("b2"), Transition("t3")) : return 1

        default : return 0
    }
  }

  // Petri's network modeling the binary counter
  return PetriNet(
    places      : [Place("b0"), Place("b1"), Place("b2"),
                   Place("a0"), Place("a1"), Place("a2")],
    transitions : [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
    pre         : pre,
    post        : post)
}

/*
------------------------------------------------------------------------------
METHOD : createCounterInitialMarking() -> Marking

PURPOSE : Returns the initial marking corresponding to the model of the binary
          counter

INPUT : -

OUTPUT : initialMarking:Marking of the binary counter starting at 000
-----------------------------------------------------------------------------
*/
public func createCounterInitialMarking() -> Marking {

  func initialMarking(_ place: Place) -> Nat {

    // Set the initial marking of the binary counter
    switch (place) {
        case Place("a0") : return 1
        case Place("a1") : return 1
        case Place("a2") : return 1
        default : return 0
    }
  }

  return initialMarking // Function(Marking) : (Place) -> Nat
}
