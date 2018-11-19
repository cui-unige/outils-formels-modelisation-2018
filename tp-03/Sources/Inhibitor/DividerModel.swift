/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
//a partir du model dans main.swift
  let net = InhibitorNet(
      places: Set(DividerPlaceSet.allCases),
  transitions: [
      //opb = k*opa + l
      InhibitorNet.Transition(
          //soustraction entre opb et opa, sto représente le nombre de soustraction
          name: "sub", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
      InhibitorNet.Transition(

          name: "rfl", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1, .res: 1]),
      InhibitorNet.Transition(
          name: "ch1", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
      InhibitorNet.Transition(
          //les transitions ne sont plus tirables 
          name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [:]),

  ])
  return net
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  return [.opa: opa, .opb: opb, .ena: 0, .sto: 0, .res: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res

  // Add your additional places here, if any.
  case ena

  case sto
}
