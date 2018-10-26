// README: here, two models are present. One that works 100%, given by Mark (I
// worked with him because groups are allowed), and one that has a bug (mine)


// Define the preconditions of the counter
private func counter_pre(p: Place, t: Transition) -> Nat {
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

  case (Place("b2"), Transition("put0")): return 1
  case (Place("b1"), Transition("put0")): return 1
  case (Place("b0"), Transition("put0")): return 1
  default: return 0
  }
}

// Define the postconditions of the counter
private func counter_post(p: Place, t: Transition) -> Nat {
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

  case (Place("a2"), Transition("put0")): return 1
  case (Place("a1"), Transition("put0")): return 1
  case (Place("a0"), Transition("put0")): return 1
  default: return 0
  }
}

/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // Define the structure of the counter
  // Here we use 6 places. Each step, every token is taken and redistributed.
  // The 'ai' places are the negation of the 'bi' places
  // Each transition 'puti' correspond to a step in counting and only one
  // transition is fireable for each "state"
  let myCounter = PetriNet(
    places      : [Place("a0"), Place("a1"), Place("a2"), Place("b0"), Place("b1"), Place("b2")],
    transitions : [Transition("put1"), Transition("put2"), Transition("put3"), Transition("put4"), Transition("put5"), Transition("put6"), Transition("put7"), Transition("put0")],
    pre         : counter_pre,
    post        : counter_post )
  return myCounter
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  let initMarking: Marking = { place in
    switch place {
      case Place("a2"): return 1
      case Place("a1"): return 1
      case Place("a0"): return 1
      // The b_i places (i.e. the bits of the counter) are set to 0 by default.
      default: return 0
    }
  }

  return initMarking
}

// BUGGED MODEL
// Define the preconditions of the counter
private func counter_pre_bug(p: Place, t: Transition) -> Nat {
  switch (p, t) {
    case (Place("r0"), Transition("t1")): return 1
    case (Place("b0"), Transition("t2_6")): return 1
    case (Place("b1"), Transition("t3_7")): return 1
    case (Place("r0"), Transition("t3_7")): return 1
    case (Place("b0"), Transition("t4")): return 1
    case (Place("b1"), Transition("t4")): return 1
    case (Place("b2"), Transition("t5")): return 1
    case (Place("r0"), Transition("t5")): return 1
    case (Place("b0"), Transition("t8")): return 1
    case (Place("b1"), Transition("t8")): return 1
    case (Place("b2"), Transition("t8")): return 1
    default: return 0
  }
}

// Define the postconditions of the counter
private func counter_post_bug(p: Place, t: Transition) -> Nat {
  switch (p, t) {
    case (Place("b0"), Transition("t1")): return 1
    case (Place("b1"), Transition("t2_6")): return 1
    case (Place("r0"), Transition("t2_6")): return 1
    case (Place("b0"), Transition("t3_7")): return 1
    case (Place("b1"), Transition("t3_7")): return 1
    case (Place("b2"), Transition("t4")): return 1
    case (Place("r0"), Transition("t4")): return 1
    case (Place("b0"), Transition("t5")): return 1
    case (Place("b2"), Transition("t5")): return 1
    case (Place("r0"), Transition("t8")): return 1
    default: return 0
  }
}

/// This function creates the model of a binary counter on three bits.
public func createCounterModel_bug() -> PetriNet {
  // I used a counter with 3 'bits' positions ("b2", "b1", "b0"), a register
  // "r0" (used for loop canceling) and 6 transitions. The counter should behave
  // like this : '000'-t1->'001'-t2_6->'010'-t3_7->'011'-t4->'100'-t5->'101'
  // -t2_6->'110'-t3_7->'111'-t8->'000', while r0 insures that only one transition
  // is ever avaiable for each "state" by making sure 't3_7' and 't5', which
  // would otherwise be able to loop, can't.
  //
  // Note: My model fails at 'testCounterReachability', and after looking at the
  // test code I can't figure out why, or how to correct my model. It might have
  // to do with the absence of a terminal state (where no more transition can be
  // fired), but this would be contrary to the described behaviour in the README.
  // 'computeGraph' seem to be where something goes wrong but I can't see why.
  // By hand on paper, it should work. Also, I'm not sure how to debug in such a
  // situation.
  //
  let counter_PetriNet = PetriNet(
    places      : [Place("b0"), Place("b1"), Place("b2"), Place("r0")],
    transitions : [Transition("t1"), Transition("t2_6"), Transition("t3_7"), Transition("t4"), Transition("t5"), Transition("t8")],
    pre         : counter_pre,
    post        : counter_post )
  return counter_PetriNet
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking_bug() -> Marking {
  // 'b0', 'b1', 'b2' and 'r0' are initialised at 0
  return { _ in
    return 0
  }
}
