/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(
  places: Set(DividerPlaceSet.allCases), // keep the same places
      transitions: [
        InhibitorNet.Transition(
          name: "sub", pre: [ .opa: 1, .opb: 1, .fsb: .inhibitor], post: [.sacTokes: 1]),

        InhibitorNet.Transition(
          name: "rfl", pre: [ .sacTokes: 1, .fsb: 1], post: [ .fsb: 1, .opb: 1]),

        InhibitorNet.Transition(
          name: "ch1", pre: [ .opb: .inhibitor, .fsb: .inhibitor], post: [ .fsb: 1, .res: 1]),

        InhibitorNet.Transition(
          name: "ch2", pre: [ .fsb: 1, .sacTokes : .inhibitor], post: [:]),
    ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  //sacTokes et fsb (vide)
  return [.opa: opa, .opb: opb, .res: 0, .fsb: 0, .sacTokes:0 ]// poite..-> res 1
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
  case fsb
  case sacTokes

}
