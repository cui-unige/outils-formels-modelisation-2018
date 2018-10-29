import PetriKit

// Write a petri net that ...

// ... is bound to 42:
do {
  // Define the set of places.
  enum Place: CaseIterable { // réseau à une place
    case p1
  }

  // Define the model and its initial marking.
  let model = PTNet<Place>(transitions: [])
  let m0: PTNet<Place>.MarkingType = [.p1: 42] //réseau avec 42 jeton et borné à 42

  // Check the properties we'd like to guarantee.
  assert(model.bound(withInitialMarking: m0) == 42)
}

// ... is alive, reversible and deadlock free:
do {
   enum Place: CaseIterable {
     pulpFiction, reservoirDogs
   }

  /*********************** Essay perso
  let t1 = PTTransition<Place>(
    named         : "t1",
    preconditions : [PTArc(place: .p1, label: 1)],
    postconditions: [PTArc(place: .p2, label: 1)])
  let t2 = PTTransition<Place>(
    named         : "t2",
    preconditions : [PTArc(place: .p3, label: 1)],
    postconditions: [PTArc(place: .p2, label: 1)])
  let t3 = PTTransition<Place>(
    named         : "t3",
    preconditions : [PTArc(place: .p2, label: 1)],
    postconditions: [PTArc(place: .p3, label: 1)])
  let pn = PTNet(transitions: [t1, t2, t3])
  */
 let model = PTNet<Place>(transitions:[
   PTTransition(
     named: "t1",
     preconditions: [PTArc(place: .pulpFiction)],
     postconditions: [PTArc(place: .reservoirDogs)]),
     PTTransition(
       named: "t2",
       preconditions: [PTArc(place: .pulpFiction)],
       postconditions: [PTArc(place: .reservoirDogs)]),
     )

 ])
  let m0: PTNet<Place>.MarkingType = [
  .pulpFiction: 1, .reservoirDogs:, 0
]

   assert(model.isAlive(withInitialMarking: m01))
   assert(model.isReversible(withInitialMarking: m01))
   assert(model.isDeadlockFree(withInitialMarking: m01))
}

// ... is alive, reversible and NOT deadlock free:
do {
  // enum Place: CaseIterable { ...
//***************Essay perso **********
/*//***********************************
enum Place : CaseIterable {
philo1, philo2, philo3
}
let model = PTNet<Place>[transitions: ]
*/
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
