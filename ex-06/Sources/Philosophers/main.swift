import PhilosophersLib

// Fibonacci :
// idée : 2 positions fn et fn-1 et
// 1 transitions avec :
// pre prend x de fn et y de fn-1
// post envoie x à fn-1 et x+y à fn

// idée 2 : 1 positions avec 01 dedans
// 1 trabnsition avec :
// pre x,y
// post x+y,max(x,y)



// RdPExtIntro.pdf slide 35 :
enum Term {
  case a, b

}

let t1 = PredicateTransition<Term> (
  preconditions: [
    PredicateArc(place: "p1", label: [.variable("x"), .variable("y")])
  ],
  postconditions : [
    PredicateArc(place: "p2", label: [.variable("x"), .variable("y")])
  ]
)

let t2 = PredicateTransition<Term> (
  preconditions: [
    PredicateArc(place: "p2", label: [.variable("x")])
  ],
  postconditions : [
    PredicateArc(place: "p1", label: [.variable("x")])
  ]
)

let m0: PredicateNet<Term>.MarkingType = ["p1": [.a,.b], "p2": []]
if let m1 = t1.fire(from: m0, with: ["x": .a, "y": .b]) {
  if let m2 = t2.fire(from: m1, with: ["x": .a]) {
    print(m2)
  }
}


/*
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

  func g(binding: PredicateTransition<C>.Binding) -> C {
    switch binding["x"]! {
    case .a: return .a
    case .b: return .b
    }
  }

  let t1 = PredicateTransition<C>(
    preconditions: [
      PredicateArc(place: "p1", label: [.variable("x")]),
      PredicateArc(place: "p1", label: [.variable("y")]),
    ],
    postconditions: [
      PredicateArc(place: "p2", label: [.variable("x")]),
      PredicateArc(place: "p2", label: [.variable("y")]),
    ])

  let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
  guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
    fatalError("Failed to fire.")
  }
  print(m1)
  guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
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
*/
