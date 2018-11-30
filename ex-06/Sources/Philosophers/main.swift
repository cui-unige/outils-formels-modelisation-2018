import PhilosophersLib

// Model from RdPExtIntro.pdf page 35

do {
  enum C: CustomStringConvertible {

    case a, b

    var description: String {
      switch self {
      case .a: return "a"
      case .b: return "b"
      }
    }
  }

  let t1 = PredicateTransition<C>(
    preconditions: [
      PredicateArc(place: "p1", label: [.variable("x"), .variable("y")]),
    ],
    postconditions: [
      PredicateArc(place: "p2", label: [.variable("x"), .variable("y")]),
    ])
  let t2 = PredicateTransition<C>(
    preconditions: [
      PredicateArc(place: "p2", label: [.variable("x")]),
    ],
    postconditions: [
      PredicateArc(place: "p1", label: [.variable("x")]),
    ])

  let m0: PredicateNet<C>.MarkingType = ["p1": [.a, .b], "p2": []]
  guard let m1 = t1.fire(from: m0, with: ["x": .a, "y": .b]) else {
    fatalError("Failed to fire.")
  }
  print(m1)
  guard let m2 = t2.fire(from: m1, with: ["x": .a, "y": .b]) else {
    fatalError("Failed to fire.")
  }
  print(m2)
}

print()

do {
  let philosophers = lockFreePhilosophers(n: 3)
  // let philosophers = lockablePhilosophers(n: 3)
  for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
    print(m)
  }
}

do {
  let philosophers = lockablePhilosophers(n: 5)
  if let g = philosophers.markingGraph(from: philosophers.initialMarking!) {
    print(g.count)
  }
}
