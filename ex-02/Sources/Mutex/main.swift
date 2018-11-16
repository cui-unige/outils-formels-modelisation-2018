private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {

  case(Place("s0"), Transition("t0")),
      (Place("c"), Transition("t0")),
      (Place("s4"), Transition("t0")),
      (Place("s1"), Transition("t1")),
      (Place("s2"), Transition("t2")),
      (Place("b"), Transition("t2")),
      (Place("s4"), Transition("t2")),
      (Place("s3"), Transition("t3")): return 1
  default: return 0
  }
}

private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("s1"), Transition("t0")),
       (Place("b"), Transition("t0")),
       (Place("s0"), Transition("t1")),
       (Place("s4"), Transition("t1")),
       (Place("c"), Transition("t2")),
       (Place("s3"), Transition("t2")),
       (Place("s2"), Transition("t3")),
       (Place("s4"), Transition("t3")): return 1
  default: return 0
  }
}

func initialMarking(_ place: Place) -> Nat {
  switch place {
  case Place("s0"),
       Place("s2"),
       Place("s4"): return 1
  case Place("c"): return 3
  default: return 0
  }
}

let model = PetriNet(
  places     : [Place("p1"), Place("p2")],
  transitions: [Transition("t1"), Transition("t2"), Transition("t3")],
  pre        : pre,
  post       : post)


let c  = model.incidenceMatrix
let s  = model.characteristicVector(of: [Transition("t1"), Transition("t2"), Transition("t1")])
let m0 = model.markingVector(initialMarking)
let m1 = m0 + c * s

print(m0, m1)
