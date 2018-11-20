/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.

  /// The structure of the model. opa/opb   opa--
//here
let net = InhibitorNet(
  places: Set(DividerPlaceSet.allCases),
  transitions: [
    // consume  `opa` and `opb`.1 tant que possible
    InhibitorNet.Transition(
      name: "minus", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
    // Refills the tokens of `opb`.3
    InhibitorNet.Transition(
      name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
    // Activates the refilling of `opb`.2 opb- et incrementer res
    InhibitorNet.Transition(
      name: "ch1", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1, .res:1]),
    // Deactivates the refilling of `opb`.4
    InhibitorNet.Transition(
      name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [:]),
  ])
return net //InhibitorNet(places: [], transitions: [])
}


/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  /// The set of places in the model.

  let initialMarking: [DividerPlaceSet: Int] = [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]
  return initialMarking
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa / opb`.
  case res

  // Add your additional places here, if any.
  case ena
  /// Store the tokens to refill in `opb`.
  case sto

}
