
/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet>
{
  return InhibitorNet(places: Set(DividerPlaceSet.allCases), // keep the same places
      transitions: [

        InhibitorNet.Transition(
          name: "01", pre: [ .opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),

        InhibitorNet.Transition(
          name: "02", pre: [ .sto: 1, .enb: 1], post: [ .enb: 1, .opb: 1]),

        InhibitorNet.Transition(
          name: "03", pre: [ .opb: .inhibitor, .enb: .inhibitor], post: [ .enb: 1, .res: 1]),

        InhibitorNet.Transition(
          name: "04", pre: [ .enb: 1, .sto : .inhibitor], post: [:]),
    ])
}
/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
    return [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto:0 ]
}
/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  case opa

  case opb

  case res

  case enb

  case sto
}
