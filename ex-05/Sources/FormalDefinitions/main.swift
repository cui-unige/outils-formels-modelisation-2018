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
   enum Place: CaseIterable {
   case p0
   case p1

   }

   let model = PTNet<Place>(transitions: [
     PTTransition(
       named: "t1",
     preconditions:[PTArc(place: .p0)],
     postconditions:[PTArc(place: .p1)]),

   PTTransition(
     named :"t2",
   preconditions:[PTArc(place: .p1)],
   postconditions:[PTArc(place: .p0)]),
   ])


   let m0: PTNet<Place>.MarkingType = [.p0: 1, .p1:0]

   assert(model.isAlive(withInitialMarking: m0))
   assert(model.isReversible(withInitialMarking: m0))
   assert(model.isDeadlockFree(withInitialMarking: m0))
}

// ... is alive, reversible and NOT deadlock free:
do {
  enum Place: CaseIterable {
  case p0
  case p1
  case p2

  }

  let model = PTNet<Place>(transitions: [
    PTTransition(
      named: "t1",
    preconditions:[PTArc(place: .p0)],
    postconditions:[PTArc(place: .p1)]),

  PTTransition(
    named :"t2",
  preconditions:[PTArc(place: .p1)],
  postconditions:[PTArc(place: .p0)]),
  ])


   assert(model.isAlive(withInitialMarking: m0))
   assert(model.isReversible(withInitialMarking: m0))
   assert(!model.isDeadlockFree(withInitialMarking: m0))
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
