/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  var preCond = {
    p : Place, t : Transition ->
    Nat in
      var value = 0
      if ((p == b0 && t != t0) || (p == b1 && (t == t2 || t == t3)) || (p == b2 && t == t3)) {
        value = 1
      }
      return value
  }                                                                             /// function pre of the generated PetriNet model

  var postCond = {
    p : Place, t : Transition ->
    Nat in
      var value = 0
      if ((p == b0 && t == t0) || (p == b1 && t == t1) || (p == b2 && t == t2)) {
        value = 1
      }
      return value                                                              /// function post of the generated PetriNet model
  }

  return PetriNet(places: [p0, p1, p2], transitions: [t0, t1, t2, t3], pre: preCond, post: postCond)     /// generating and returning the generated PetriNet model
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  return { place : Place -> Nat in return 0  }
}
