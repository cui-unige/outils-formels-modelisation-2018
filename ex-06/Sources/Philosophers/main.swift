import PhilosophersLib

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

  func g(binding: PredicateTransition<C>.Binding) -> C {
    switch binding["x"]! {
    case .b: return .v
    case .v: return .b
    case .o: return .o
    }
  }
}

do {


  enum Term {
    case  a, b
  }

  let t1 = PredicateTransition<Term>(
    preconditions: [
      PredicateArc(place: "p1", label: [.variable("x"), .variable("y")]),
    ],
    postconditions: [
      PredicateArc(place: "p2", label: [.variable("x"), .variable("y")]),
    ])
  let t2 = PredicateTransition<Term>(
    preconditions: [
      PredicateArc(place: "p2", label: [.variable("x")]),
    ],
    postconditions: [
      PredicateArc(place: "p1", label: [.variable("x")]),
    ])

  let m0: PredicateNet<Term>.MarkingType = ["p1": [.a, .b], "p2": []]
  if let m1 = t1.fire(from: m0, with: ["x": .a, "y": .b]) {
      if let m2 = t2.fire(from: m1, with: ["x": .a]){
          print("HELLO")
          print(m2)
      }
  }

}
do {

  // enum Fibo {
  //   case Int
  // }

  let t1 = PredicateTransition<Int>(
      preconditions: [
          PredicateArc(place: "p1", label: [.variable("x"), .variable("y")])
      ]

  )
  let m0: PredicateNet<Int>.MarkingType = ["p1": [.0, .1]]
  if let m1  = 
}

//     fatalError("Failed to fire.")
//   }
//   print(m1)
//   guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
//     fatalError("Failed to fire.")
//   }
//   print(m2)
// }
//
// print()
//
// do {
//   let philosophers = lockFreePhilosophers(n: 3)
//   // let philosophers = lockablePhilosophers(n: 3)
//   for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
//     print(m)
//   }
// }
//
// do {
//   let philosophers = lockablePhilosophers(n: 5)
//   if let g = philosophers.markingGraph(from: philosophers.initialMarking!) {
//     print(g.count)
//   }
// }
