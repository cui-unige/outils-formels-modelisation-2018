/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet>
{
  return InhibitorNet(places: Set(DividerPlaceSet.allCases), // keep the same places
      transitions: [
        // store opb in sto
        // substraction : 'opa - opb'
        InhibitorNet.Transition(
          name: "sub", pre: [ .opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),
        // refill opb (from sto) for next substraction
        // empty sto for next substraction
        // enb allows to fire sub
        // once sto is empty, sub is not fireable anymore
        InhibitorNet.Transition(
          name: "rfl", pre: [ .sto: 1, .enb: 1], post: [ .enb: 1, .opb: 1]),
        // ch1 set rfl when enb and opb are empty (inhibitor arcs)
        // active enb
        // ch1 is fireable when opb is empty ===> increment of 1 in res
        // if opb is non-empty, there is no more incrementation and divider model will be blocked by opa
        InhibitorNet.Transition(
          name: "ch1", pre: [ .opb: .inhibitor, .enb: .inhibitor], post: [ .enb: 1, .res: 1]),
        // ch2 restarts a new substraction (fills enb)
        InhibitorNet.Transition(
          name: "ch2", pre: [ .enb: 1, .sto : .inhibitor], post: [:]),
    ])
}
/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
    return [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto:0 ]
}
/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res
  /// A flag that enables the refilling of `opb`.
  case enb
  /// Store the tokens to refill in `opb`.
  case sto
}
