import PetriKit

// The following declares the Petri net depicted on the slide n°18 of your lecture notes on Petri
// net properties (i.e. "RdPPresProp.pdf").

// Declare the set of places.
enum Place: CaseIterable {
  case p1, p2, p3
}

// Declare the structure of the Petri net.
let a = PTTransition<Place>(
  named         : "a",
  preconditions : [PTArc(place: .p1, label: 1)],
  postconditions: [PTArc(place: .p2, label: 1)])
let b = PTTransition<Place>(
  named         : "b",
  preconditions : [PTArc(place: .p3, label: 1)],
  postconditions: [PTArc(place: .p2, label: 1)])
let c = PTTransition<Place>(
  named         : "c",
  preconditions : [PTArc(place: .p2, label: 1)],
  postconditions: [PTArc(place: .p3, label: 1)])
let d = PTTransition<Place>(
named         : "d",
preconditions : [PTArc(place: .p2, label: 1)],
postconditions: [])
)
let pn = PTNet(transitions: [a, b, c])

// Declare the initial marking.
// en dict
// . car propriete de , enum place.p1, permet d'acceder a tout les cas d'enumération
let m0: Marking<Place, UInt> = [.p1: 1, .p2: 0, .p3: 0]
// fait enseble et compte avec compteur
if let states = computeGraph(of: pn, from: m0) {
print("There are \(Array(states).count) states")
}

// Fire the transition `a` from the initial marking.
//comment in tire une transition
// fire est implementer dans petrikit
guard let m1 = a.fire(from: m0) else {
  fatalError("'a' was not fireable from \(m0)")
}

// Build the state space of the petri net.
//espace detat en fr tout les etat ateniable

if let states = computeGraph(of: pn, from: m0) {
  // Print all the reachable states.
  //state comme ensemble
  print("The following markings are accessible:")
  for state in states {
    print(state.marking)
  }
  print()

  // Now that we collected all states, we can search for those that match a particular criterion.
  // recherche tout ceux qui ont 1 jetons dans p2
  // representation par dictionnaire
  // retourne un ensemble de tt les etats qui ont 1 jetons dans p2
  //let haveOneTokenInP2 = states.filter { state in state.marking[.p2] > 0 && state.marking[.p3] > 0}
  //print("The following markings have 1 token in 'p2':")
  //for state in haveOneTokenInP2 {
    //print(state.marking)
//}
  //print()
//} else {
  //print("The petri net is unbounded")
//}

// avec transition tirable
let hasBlockingState = states.contains { state in
    for transition in pn.transitions {
        if transition.isFireable(from: state.marking) {
            return false
        }
    }
    return true
}
print(hasBlockingState)
}

// avec transition tirable
//let haveOneTokenInP2 = states.filter { state in
//a.isFireable(from:state.marking)
//}
//print("The following markings have 1 token in 'p2':")
//for state in haveOneTokenInP2 {
  //print(state.marking)
//}
//print()
//} else {
//print("The petri net is unbounded")
//}

// Note that if the network is unbounded, then `computeGraph(of:from:)` returns nil. For instance,
// if we change the Petri net so that transition `a` puts a token back into `p1`, the model becomes
// unbounded.


// modifie pour que replace 1 jeton dans p1, ajout d'un arc
// on fait face a reseau non borne
let a2 = PTTransition<Place>(
  named         : "a2",
  preconditions : [PTArc(place: .p1, label: 1)],
  postconditions: [PTArc(place: .p1, label: 1), PTArc(place: .p2, label: 1)])
let pn2 = PTNet(transitions: [a2, b, c])
if computeGraph(of: pn2, from: [.p1: 1, .p2: 0, .p3: 0]) == nil {
  print("The petri net is unbounded")
}
