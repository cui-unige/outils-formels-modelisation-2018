/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  /// The structure of the model.
  let net = InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      // Add tokens in `rem` as long as there are some to consume in `opa` and `opb`.
      InhibitorNet.Transition(
        name: "sub", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.rem: 1]),
      // Refills the tokens of `opb`.
      InhibitorNet.Transition(
        name: "rfl", pre: [.ena: 1, .rem: 1], post: [.ena: 1, .opb: 1]),
      // Activates the refilling of `opb`.
      InhibitorNet.Transition(
        name: "ch1", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),
      // Deactivates the refilling of `opb` and increment the result.
      InhibitorNet.Transition(
        name: "cnt", pre: [.ena: 1, .rem: .inhibitor], post: [.res: 1]),
    ])

  return net //InhibitorNet(places: [], transitions: [])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  /// The initial marking of the model.
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .rem: 0] //[:]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The numerator.
  case opa
  /// The denominator
  case opb
  /// The result of `opa / opb`.
  case res
  /// A flag that enables the refilling of `opb`.
  case ena
  /// Store the tokens to refill in `opb` and stores the remainder at the end of the division.
  case rem

}
