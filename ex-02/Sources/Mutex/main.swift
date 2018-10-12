private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p0"), Transition("t0")): return 1 ///l'arc entre la place p1 et la transition t1 donne ?
  case (Place("p1"), Transition("t1")): return 1 /// entre place et transition
  case (Place("p2"), Transition("t2")): return 1
  case (Place("p3"), Transition("t3")): return 1
  case (Place("p4"), Transition("t0")): return 1
  case (Place("p4"), Transition("t2")): return 1
  case (Place("pc"), Transition("t0")): return 1
  case (Place("pb"), Transition("t2")): return 1
  default: return 0
  }
}

private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p0"), Transition("t1")): return 1  /// enttre transition et place
  case (Place("p1"), Transition("t0")): return 1
  case (Place("p2"), Transition("t3")): return 1
  case (Place("p3"), Transition("t2")): return 1
  case (Place("p4"), Transition("t1")): return 1
  case (Place("p4"), Transition("t3")): return 1
  case (Place("pb"), Transition("t0")): return 1
  case (Place("pc"), Transition("t2")): return 1
  default: return 0
  }
}

func initialMarking(_ place: Place) -> Nat {
  switch place {
  case Place("p0"): return 1  /// pas besoin de déclarer celles qui donnent 0
  case Place("p1"): return 0
  case Place("p2"): return 1
  case Place("p3"): return 0
  case Place("p4"): return 1
  case Place("pb"): return 0
  case Place("pc"): return 3
  default: return 0
  }
}

let model = PetriNet(
  places     : [Place("p1"), Place("p2"), Place("p3"), Place("p4"), Place("pb"), Place("pc")],
  transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")], // suite de transitions qui va etre opérée
  pre        : pre,
  post       : post)


let c  = model.incidenceMatrix
let s  = model.characteristicVector(of: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")])
let m0 = model.markingVector(initialMarking)
let m1 = m0 + c * s

print(m0, m1)
