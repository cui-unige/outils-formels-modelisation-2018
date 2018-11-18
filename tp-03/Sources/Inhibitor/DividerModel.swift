/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  let net = InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      InhibitorNet.Transition(
        name: "moins", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.stock: 1]),
      InhibitorNet.Transition(
        name: "recharge", pre: [.stock: 1, .ena: 1], post: [.ena: 1, .opb: 1]),
      InhibitorNet.Transition(
        name: "active", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.res: 1, .ena: 1]),
      InhibitorNet.Transition(
        name: "desactive", pre: [.stock: .inhibitor, .ena: 1], post: [:]),
    ])
  return net
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .stock: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res
  /// enable
  case ena
  //stock
  case stock

}
