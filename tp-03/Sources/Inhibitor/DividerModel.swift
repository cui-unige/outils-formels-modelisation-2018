/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  let naturalDivider = InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      // Remove tokens  in `opa` as long as there are some to consume in `opb`.
      InhibitorNet.Transition(
        name: "rmv", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
      // Refills the tokens of `opb`.
      InhibitorNet.Transition(
        name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
      // Activates the refilling of `opb`
      InhibitorNet.Transition(
        name: "ch1", pre: [.opa: 1, .opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1,.res: 1]),
      // Deactivates the refilling of `opb`.
      InhibitorNet.Transition(
        name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [:]),
      // End
      InhibitorNet.Transition(
        name: "ch3", pre: [.opa: .inhibitor, .end: .inhibitor], post: [.res: 1,.end: 1]),


    ])
  return naturalDivider
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  let initialMarking: [DividerPlaceSet: Int] = [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0,.end: 0]

  return initialMarking
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

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
  /// end
  case end


  // Add your additional places here, if any.

}
