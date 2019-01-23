import PhilosophersLib
/*
do {
  enum C: CustomStringConvertible {

    case b, v, o

    var description: String {
      switch self {
      case .b: return "b"
      case .v: return "v"
      case .o: return "o"
      }
    }
  }

  func g(binding: PredicateTransition<C>.Binding) -> C { // bind x
    switch binding["x"]! {
    case .b: return .v
    case .v: return .b
    case .o: return .o
    }
  }

  let t1 = PredicateTransition<C>(
    preconditions: [
      PredicateArc(place: "p1", label: [.variable("x")]),
    ],
    postconditions: [
      PredicateArc(place: "p2", label: [.function(g)]),
    ])

    // marquage initial
  let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    // on tire le marquage initial , en bindant x à b
  guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
    fatalError("Failed to fire.")
  }
  print(m1) // b devient v qui se retrouve dans p2
  guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
    fatalError("Failed to fire.")
  }
  print(m2)
}

*/

// FAIRE SWIFT RUN

//-----------------------------------------------------

do {
    enum Exemplep35ExIntro: CustomStringConvertible {
        
        case b, a
        
        var description: String {
            switch self {
            case .b: return "b"
            case .a: return "a"
            }
        }
    }
    
    func g(binding: PredicateTransition<C>.Binding) -> C { // bind x
        switch binding["x,y"]! {
        case .a: return .a
        case .b: return .b
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
    
    // marquage initial
    let m0: PredicateNet<C>.MarkingType = ["p1": [.a, .b], "p2": []]
    // on tire le marquage initial , en bindant x à b
    guard let m1 = t1.fire(from: m0, with: ["x": .a, "y": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1) // b devient v qui se retrouve dans p2
    guard let m2 = t2.fire(from: m1, with: ["x": .a]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

// -----------------------------------------------------

print()
// construction rdp pour 3 philosophes
do {
  let philosophers = lockFreePhilosophers(n: 3)
    // let philosophers = lockablePhilosophers(n: 3),   simulation : simule les étapes
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
