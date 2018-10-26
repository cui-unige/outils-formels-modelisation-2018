import PetriKit

// Write a petri net that ...

// ... is bound to 42:
do {
  // Define the set of places.
  enum Place: CaseIterable {
    case p1
  }

  // Define the model and its initial marking.
  let model = PTNet<Place>(transitions: [])
  let m0: PTNet<Place>.MarkingType = [.p1: 42]

  // Check the properties we'd like to guarantee.
  assert(model.bound(withInitialMarking: m0) == 42)
}

// ... is alive, reversible and deadlock free:
do {
  // p1 <-> p2 avec p1 -t1-> p2 et p2 -t2-> p1
  enum Place: CaseIterable {
    case p1, p2
  }

  let model = PTNet<Place>(transitions: [
    PTTransition(
      named: "t1",
      preconditions: [PTArc(place: .p1)],
      postconditions: [PTArc(place: .p2)]
    ),
    PTTransition(
      named: "t2",
      preconditions: [PTArc(place: .p2)],
      postconditions: [PTArc(place: .p1)]
    )
  ])
  let m0: PTNet<Place>.MarkingType = [
    .p1: 1,
    .p2: 0
  ]

  assert(model.isAlive(withInitialMarking: m0))
  assert(model.isReversible(withInitialMarking: m0))
  assert(model.isDeadlockFree(withInitialMarking: m0))
}

// ... is alive, reversible and NOT deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(model.isAlive(withInitialMarking: m0))
  // assert(model.isReversible(withInitialMarking: m0))
  // assert(!model.isDeadlockFree(withInitialMarking: m0))
}

// ... is alive, NOT reversible and deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(model.isAlive(withInitialMarking: m0))
  // assert(!model.isReversible(withInitialMarking: m0))
  // assert(model.isDeadlockFree(withInitialMarking: m0))
}

// ... is alive, NOT reversible and NOT deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(model.isAlive(withInitialMarking: m0))
  // assert(!model.isReversible(withInitialMarking: m0))
  // assert(!model.isDeadlockFree(withInitialMarking: m0))
}

// ... is NOT alive, reversible and deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(!model.isAlive(withInitialMarking: m0))
  // assert(model.isReversible(withInitialMarking: m0))
  // assert(model.isDeadlockFree(withInitialMarking: m0))
}

// ... is NOT alive, reversible and NOT deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(!model.isAlive(withInitialMarking: m0))
  // assert(model.isReversible(withInitialMarking: m0))
  // assert(!model.isDeadlockFree(withInitialMarking: m0))
}

// ... is NOT alive, NOT reversible and deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(!model.isAlive(withInitialMarking: m0))
  // assert(!model.isReversible(withInitialMarking: m0))
  // assert(model.isDeadlockFree(withInitialMarking: m0))
}

// ... is NOT alive, NOT reversible and NOT deadlock free:
do {
  // enum Place: CaseIterable { ...

  // let model = ...
  // let m0: PTNet<Place>.MarkingType = [ ...

  // assert(!model.isAlive(withInitialMarking: m0))
  // assert(!model.isReversible(withInitialMarking: m0))
  // assert(!model.isDeadlockFree(withInitialMarking: m0))
}
