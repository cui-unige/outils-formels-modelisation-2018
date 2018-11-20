import PhilosophersLib

do {
  enum term{

    case a, b
    }

  let t1 = PredicateTransition<term>(
    preconditions: [
      PredicateArc(place: "p1", label: [.variable("x"), .variable("y")]),
    ],
    postconditions: [
      PredicateArc(place: "p2", label: [.variable("x"), .variable("y")]),
    ])
    
    let t2 = PredicateTransition<term>(
        preconditions: [
            PredicateArc(place: "p2", label: [.variable("x")]),
            ],
        postconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
            ])

  let m0: PredicateNet<term>.MarkingType = ["p1": [.a, .b], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b,"y": .a]) else {
    fatalError("Failed to fire.")
  }
  print(m1)
  guard let m2 = t2.fire(from: m1, with: ["x": .a]) else {
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
