/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(places: Set(DividerPlaceSet.allCases), transitions: [
    // Add tokens in `res` as long as there are some to consume in `opa` and `opb`.
    InhibitorNet.Transition(name: "add",
                            pre: [.opa: 1, .opb: 1, .ena: .inhibitor],
                            post: [.sto : 1]),
    // Refills the tokens of `opa`.
    InhibitorNet.Transition(name: "rfl",
                            pre: [.ena: 1, .sto: 1],
                            post: [.ena : 1, .opb: 1]),
    // Activates the refilling of `opa`.
    InhibitorNet.Transition(name: "aro",
                            pre: [.ena: .inhibitor, .opb: .inhibitor],
                            post: [.ena : 1]),
    // Deactivates the refilling of `opa`.
    InhibitorNet.Transition(name: "d",
                            pre: [.ena: 1, .sto: .inhibitor],
                            post: [.res : 1])
    ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .sto: 0, .ena: 0]
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
case sto

    case ena
}
