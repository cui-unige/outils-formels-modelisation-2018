// Places
let p0 = Place("p0")
let p1 = Place("p1")

let b0 = Place("b0")
let b1 = Place("b1")
let b2 = Place("b2")

// Transitions
let t0 = Transition("t0")
let t1 = Transition("t1")
let t2 = Transition("t2")
let t3 = Transition("t3")
let t4 = Transition("t4")

// Define the preconditions of a simple Petri net.
func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {

// 1 : 001
  case (p0, t0): return 1 // tir pour faire 001

// 2 : 010
  case (b0, t1): return 1 // on se débarasse du jeton pour le 010

// 3 : 011
  case (p0, t0): return 1 // replace un jeton en b0 pour faire 011

// 4 : 100
  case (b0, t2): return 1 //
  case (b1, t2): return 1 //

// 5 : 101
  case (p1, t3): return 1 // replace un jeton à b0 (100 -> 101)

// 6 : 110
  case (b0, t1): return 1 // enlève jeton de b0 pour b1 (101 -> 110)

// 7 : 111
  case (p0, t0): return 1 // replace jeton en b0 (110 -> 111)

// Réinitialisation : 000
  case (b0, t4): return 1 //
  case (b1, t4): return 1 //
  case (b2, t4): return 1 //

  default: return 0
  }
}

// Define the postconditions of a simple Petri net.
func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {

// 1 : 001
  case (b0, t0): return 1 // 001

// 2 : 010
  // Arc double qui distribue un jeton par place
  case (b1, t1): return 1 // 010
  case (p0, t1): return 1 // tire un jeton pour p0

// 3 : 011
  case (b0, t0): return 1 // 011

// 4 : 100
  case (b2, t2): return 1 // 100

// 5 : 101
  case (b0, t3): return 1 // 101

// 6 : 110
  case (b1, t1): return 1 // 110
  case (p0, t1): return 1 // contient un jeton pour ensuite faire 111 en b0

// 7 : 111
  case (b0, t0): return 1 // 111

// Réinitialisation : 000
  case (p0, t4): return 1 // Redistribution de l'initial marking
  case (p1, t4): return 1 // Redistribution de l'initial marking

  default: return 0
  }
}

/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  return PetriNet(places: [p0, p1, b0, b1, b2], transitions: [t0, t1, t2, t3, t4], pre: pre, post: post)

}

/// Define the initial marking of a simple Petri net.
private func initialMarking(_ place: Place) -> Nat {
  switch place {

  case p0: return 1
  case p1: return 1

  default: return 0
  }
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  return initialMarking

}
