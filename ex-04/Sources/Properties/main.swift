import PetriKit

// Declare a Petri net with two concurrent threads competing for memory locks.

enum Place: String, CaseIterable, CustomStringConvertible {

  // Thread states
case th1Idle // en attente
  case th1WaitForLk1
  case th1WaitForLk2
  case th1Write

  case th2Idle
  case th2WaitForLk1
  case th2WaitForLk2
  case th2Write

  // Synchronization locks
  case lk1
  case lk2

  var description: String {
    return rawValue
  }

}
// expliication des transitions
let model = PTNet<Place>(
  transitions: [
    // Thread 1 gets the first lock first.
    PTTransition<Place>(named: "th1GetLk1First" , pre: [.th1Idle, .lk1], post: [.th1WaitForLk2]),
    // Thread 1 gets the second lock after the first one.
    PTTransition<Place>(named: "th1GetLk2Second", pre: [.th1WaitForLk2, .lk2], post: [.th1Write]),
    // Thread 1 gets the second lock first.
    PTTransition<Place>(named: "th1GetLk2First" , pre: [.th1Idle, .lk2], post: [.th1WaitForLk1]),
    // Thread 1 gets the first lock after the second one.
    PTTransition<Place>(named: "th1GetLk1Second", pre: [.th1WaitForLk1, .lk1], post: [.th1Write]),
    // Thread 1 releases both locks.
    PTTransition<Place>(named: "th1Release"     , pre: [.th1Write], post: [.th1Idle, .lk1, .lk2]),
    // Thread 2 gets the first lock first.
    PTTransition<Place>(named: "th2GetLk1First" , pre: [.th2Idle, .lk1], post: [.th2WaitForLk2]),
    // Thread 2 gets the second lock after the first one.
    PTTransition<Place>(named: "th2GetLk2Second", pre: [.th2WaitForLk2, .lk2], post: [.th2Write]),
    // Thread 2 gets the second lock first.
    PTTransition<Place>(named: "th2GetLk2First" , pre: [.th2Idle, .lk2], post: [.th2WaitForLk1]),
    // Thread 2 gets the first lock after the second one.
    PTTransition<Place>(named: "th2GetLk1Second", pre: [.th2WaitForLk1, .lk1], post: [.th2Write]),
    // Thread 2 releases both locks.
    PTTransition<Place>(named: "th2Release"     , pre: [.th2Write], post: [.th2Idle, .lk1, .lk2])
  ])

let initialMarking: Marking<Place, UInt> = [
  .th1Idle      : 1,
  .th1WaitForLk1: 0,
  .th1WaitForLk2: 0,
  .th1Write     : 0,
  .th2Idle      : 1,
  .th2WaitForLk1: 0,
  .th2WaitForLk2: 0,
  .th2Write     : 0,
  // 2 verroux dispo
  .lk1          : 1,
  .lk2          : 1,
]
//analysa le modele
// il y a bp ds ce reseau interblocafe
analyze(model, withInitialMarking: initialMarking)
