import Inhibitor

// The following defines a Petri net extended with inhibitor arcs that computes the muliplication of
// two arbitrary numbers. These are represented by the marking of the places `opa` and `opb` in the
// initial marking, while the result of their multiplication will be represented by the marking of
// the place `res` once the model is blocked (i.e. no other transition is fireable).

/// The first operand.
let a = 6
/// The second operand.
let b = 3

/// The set of places in the model.
enum PlaceSet: CaseIterable, Hashable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res
  /// A flag that enables the refilling of `opa`.
  case ena
  /// Store the tokens to refill in `opa`.
  case sto

}

/// The structure of the model.
let net = InhibitorNet(
  places: Set(PlaceSet.allCases),
  transitions: [
    // Add tokens in `res` as long as there are some to consume in `opa` and `opb`.
    InhibitorNet.Transition(
      name: "add", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
    // Refills the tokens of `opa`.
    InhibitorNet.Transition(
      name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
    // Activates the refilling of `opa`.
    InhibitorNet.Transition(
      name: "ch1", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),
    // Deactivates the refilling of `opa`.
    InhibitorNet.Transition(
      name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1]),
  ])

/// The initial marking of the model.
let initialMarking: [PlaceSet: Int] = [.opa: a, .opb: b, .res: 0, .ena: 0, .sto: 0]

// ----- Note -------------------------------------------------------------------------------------
// The remainder of this program will not produce the expected result unless you properly implement
// the methods `isFireable(_:from:)` and `fire(_:from:)` of `InhibitorNet.Transition`.

// Asks whether the transition `add' is fireable from the initial marking.
let add = net.transitions.first { $0.name == "add" }!
print("Transition 'add' is \(add.isFireable(from: initialMarking) ? "" : "not ")fireable.")

// Computes the marking obtained after firing 'add' from the initial marking.
if let m1 = add.fire(from: initialMarking) {
  print(m1)
}

// There should be only a single sink state, representing the result of the multiplication.
let states = net.computeMarkingGraph(from: initialMarking)
let sinks = states.filter { $0.successors.isEmpty }
assert(sinks.count == 1)
print("\(a) / \(b) = \(sinks.first!.marking[.res]!) (\(states.count) states)")
