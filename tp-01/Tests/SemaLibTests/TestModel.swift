import SemaLib

func createTestModel() -> PetriNet {
  return PetriNet(
    places      : [Place("p1"), Place("p2")],
    transitions : [Transition("t1"), Transition("t2"), Transition("t3")],
    pre         : pre,
    post        : post)
}

private func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p1"), Transition("t1")): return 2
  case (Place("p1"), Transition("t2")): return 1
  case (Place("p1"), Transition("t3")): return 0
  case (Place("p2"), Transition("t1")): return 0
  case (Place("p2"), Transition("t2")): return 6
  case (Place("p2"), Transition("t3")): return 4
  default: return 0
  }
}

private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p1"), Transition("t1")): return 5
  case (Place("p1"), Transition("t2")): return 0
  case (Place("p1"), Transition("t3")): return 1
  case (Place("p2"), Transition("t1")): return 7
  case (Place("p2"), Transition("t2")): return 3
  case (Place("p2"), Transition("t3")): return 0
  default: return 0
  }
}

