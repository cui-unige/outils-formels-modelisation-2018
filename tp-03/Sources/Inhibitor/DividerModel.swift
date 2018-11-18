/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
    InhibitorNet.Transition(
      name: "add", pre: [.opa: 1, .opb: 1, .info: .inhibitor], post: [.temp: 1] ),
    InhibitorNet.Transition(
      name: "fillb", pre:[.info: 1, .temp: 1], post:[.info: 1, .opb:1] ),
    InhibitorNet.Transition(
      name: "ch1", pre:[.opb: .inhibitor, .info: .inhibitor], post:[.info: 1] ),
    InhibitorNet.Transition(
      name: "ch2", pre:[.info: 1, .temp: .inhibitor], post:[.res: 1] )
  ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  return [.opa: opa, .opb: opb, .temp: 0, .info: 0, .res: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa / opb`.
  case res
  /// Flag initialising the refill of opb
  case temp
  /// Memory to keep the number initialy in opb
  case info

}
