/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(
  places: Set (DividerPlaceSet.allCases),
  transitions: [
    InhibitorNet.Transition( //enlève n de m.
      name: "add", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]), //sto crée sauvegarde
    InhibitorNet.Transition(
      name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
    InhibitorNet.Transition(
      name: "ch1", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),
    InhibitorNet.Transition(
      name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1])
  ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]
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
  //place permettant de remplir opb
  case ena
  //place stockant les jetons à placer dans opb
  case sto
}
