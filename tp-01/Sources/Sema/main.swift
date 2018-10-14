import SemaLib

// Define the preconditions of a simple Petri net.
private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p1"), Transition("t1")): return 1
  case (Place("p2"), Transition("t2")): return 3
      //pour 001
  case (Place("b0"), Transition("t3")): return 1
      //pour 011
  case (Place("b0"), Transition("t4")): return 1
  case (Place("b1"), Transition("t4")): return 1
      //pour 111
  case (Place("b0"), Transition("t5")): return 1
  case (Place("b1"), Transition("t5")): return 1
  case (Place("b2"), Transition("t5")): return 1
  default: return 0
  }
}

// Define the postconditions of a simple Petri net.
private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p2"), Transition("t1")): return 2
  case (Place("p1"), Transition("t2")): return 4
      //on incrémente de 1
  case (Place("b0"), Transition("t0")): return 1
  case (Place("b1"), Transition("t3")): return 1
  case (Place("b2"), Transition("t4")): return 1
  default: return 0
  }
}

// Define the structure of a simple Petri net.
let petrinet = PetriNet(
  places      : [Place("p1"), Place("p2"), Place("b0"), Place("b1"), Place("b2")],
  transitions : [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3"), Transition("t4"), Transition("t5")],
  pre         : pre,
  post        : post)

// Define the initial marking of a simple Petri net.
private func initialMarking(_ place: Place) -> Nat {
  switch place {
  case Place("p1"): return 2
  case Place("p2"): return 2
  case Place("b0"): return 0
  case Place("b1"): return 0
  case Place("b2"): return 0
  default: return 0
  }
}
let initialMarkingCounter = createCounterInitialMarking()
print(initialMarkingCounter(Place("b2")))  // Prints "0"
print(initialMarkingCounter(Place("b1")))  // Prints "0"
print(initialMarkingCounter(Place("b0")))  // Prints "0"

// Check whether `t1` is fireable from the initial marking.
let fireable = petrinet.isFireable(Transition("t1"), from: initialMarking)
print("Transition t1 is \(fireable ? "" : "not ")fireable from the initial marking.")
print()

// Obtain the marking `m2` by firing `t1` from the initial marking.
if let m2 = petrinet.fire(Transition("t1"), from: initialMarking) {
  // Note the use of a optional binding (`if let ...`), which means `m2` can't be `nil` here.

  // Print the marking `m2`
  print("Firing 't1' from the initial marking produces the following marking:")
  petrinet.print(marking: m2)

  // Print token difference in `p2` between `m2` and the initial marking.
  let Δ = Int(m2(Place("p2"))) - Int(initialMarking(Place("p2")))
  print("Place 'p2' \(Δ < 0 ? "lost" : "got") \(Δ) token(s).")
}

do {
  let model = PetriNet(
    places     : [Place("p1")],       // `P = { p1 }`
    transitions: [Transition("t1")],  // `T = { t1 }`
    pre        : { _, _ in 1 },          // `pre(p1, t1) = 1`
    post       : { _, _ in 0 })          // `post(p1, t1) = 0`.

  // Compute the new marking after firing t1 from [p1 → 1].
  func m0(_ place: Place) -> Nat {
    return place == Place("p1") ? 1 : 0
  }
  let m1 = model.fire(Transition("t1"), from: m0)

  // Prints "0".
  print(m1!(Place("p1")))

  // Try to compute the marking obtained by firing t1 from [p1 → 0].
  let m2 = model.fire(Transition("t1"), from: m1!)
  if m2 == nil {
    print("The transition was not fireable.")
  }
}
