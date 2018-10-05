private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("s0"), Transition("t0")): return 1
  case (Place("s4"), Transition("t0")): return 1
  case (Place("c"), Transition("t0")): return 1
  case (Place("s1"), Transition("t1")): return 1
  case (Place("b"), Transition("t2")): return 1
  case (Place("s2"), Transition("t2")): return 1
  case (Place("s4"), Transition("t2")): return 1
  case (Place("s3"), Transition("t3")): return 1
  case (Place("s3"), Transition("t3")): return 1
  default: return 0
  }
}

private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("b"), Transition("t0")): return 1
  case (Place("s1"), Transition("t0")): return 1
  case (Place("s0"), Transition("t1")): return 1
  case (Place("s4"), Transition("t1")): return 1
  case (Place("s3"), Transition("t2")): return 1
  case (Place("c"), Transition("t2")): return 1
  case (Place("s4"), Transition("t3")): return 1
  case (Place("s2"), Transition("t3")): return 1
  default: return 0
  }
}

// Avec Assistant :
//
// private func pre(p: Place, t: Transition) -> Nat {
//   switch t {
//   case Transition("t0"):
//     switch p {
//     case Place("s0"), Place("s4"), Place("c"): return 1
//     default: return 0
//     }
//   case Transition("t1"):
//     switch p {
//     case Place("s1"): return 1
//     default: return 0
//     }
//   }
// }
//
// a finir



func initialMarking(_ place: Place) -> Nat {
  switch place {
  case Place("s0"): return 1
  case Place("s2"): return 1
  case Place("s4"): return 1
  case Place("c"): return 3
  default: return 0
  }
}

let model = PetriNet(
  places     : [Place("s0"), Place("s1"), Place("s2"), Place("s3"), Place("s4"), Place("c"), Place("b")],
  transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
  pre        : pre,
  post       : post)


let c  = model.incidenceMatrix
let s  = model.characteristicVector(of: [Transition("t0"), Transition("t1"), Transition("t0")])
let m0 = model.markingVector(initialMarking)
let m1 = m0 + c * s

//print(c)
print(m0, m1)




// help pour fire dans TP 1
func next(_ marking: @escaping (Place) -> Nat) -> (Place) -> Nat {
  return {
    return marking($0) + 1
  }
}

let mk = next(initialMarking)
print(initialMarking(Place("b")), mk(Place("b")))
