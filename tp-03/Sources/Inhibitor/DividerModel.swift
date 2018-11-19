/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      // Store opb in sto and substract 'opa - opb'
      InhibitorNet.Transition(
        name: "sub",
        pre: [ .opa: 1, .opb: 1, .enb: .inhibitor],
        post: [ .sto: 1]),
      // Refill opb with sto (value of opb), empty sto, enb allow to fire sub and sub is not fireable when sto is empty
      InhibitorNet.Transition(
        name: "rf1",
        pre: [ .sto: 1, .enb: 1],
        post: [ .enb: 1, .opb: 1]),
      // Set rf1 when enb and opb are empty, active enb, ch1 is fireable when opb is empty => increment of 1 in res
      InhibitorNet.Transition(
        name: "ch1",
        pre: [ .opb: .inhibitor, .enb: .inhibitor],
        post: [ .enb: 1, .res: 1]),
      // Restart a new substraction
      InhibitorNet.Transition(
        name: "ch2",
        pre: [ .sto: .inhibitor, .enb: 1],
        post: [:]),
    ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  return [ .opa: opa, .opb: opb, .res: 0, .enb: 0, .sto: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa / opb`.
  case res
  /// Flag to refill opb
  case enb
  /// Store the token of opb
  case sto
}
