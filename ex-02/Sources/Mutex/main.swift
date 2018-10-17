private func pre(p: Place, t: Transition) -> Nat {
  switch t {
case Transition("t0"):
  switch p {
  case (Place("s0"), Transition("s4"),Transition("c")): return 1 //commentaire
  default:return 0
  }
case Transition("t1"):
  switch p {
  case (Place("s0"), Transition("s4"),Transition("c")): return 1
  default:return 0
  }
case Transition("t2"):
  switch p {
  case (Place("s0"), Transition("s4"),Transition("c")): return 1
  default:return 0
  }
case Transition("t3"):
  switch p {
  case (Place("s0"), Transition("s4"),Transition("c")): return 1
  default:return 0
  }

  }


private func post(p: Place, t: Transition) -> Nat {
  switch t {
  case Transition("t0"):
    switch p {
    case (Place("s1"), Place("b")): return 1
    default:return 0
    }
  case Transition("t1"):
    switch p {
    case (Place("s0"), Place("s4")): return 1
    default:return 0
    }
  case Transition("t2"):
    switch p {
    case (Place("s3"), Place("c")): return 1
    default:return 0
    }
  }
}

func initialMarking(_ place: Place) -> Nat {
  switch place {
  case Place("s0"): return 1
  case Place("s2"): return 1
  case Place("s4"): return 1 //ceux qui retournent 0 pas besoin de les mettre
  case Place("c"): return 3
  default: return 0
  }
}


let model = PetriNet(
  places     : [Place("s0"),Place("s1"),Place("s2"),Place("s3"),Place("s4"), Place("b"),Place("c")],
  transitions: [Transition("t0"),Transition("t1"), Transition("t2"), Transition("t3")],
  pre        : pre,
  post       : post)


let c  = model.incidenceMatrix
let s  = model.characteristicVector(of: [Transition("t1"), Transition("t2"), Transition("t1")])
let m0 = model.markingVector(initialMarking)
let m1 = m0 + c * s

print(m0, m1)
