// This model implements integer division.

  // It works as follows:
  // 1. copy n tokens from opb to opb_copy_buffer
  // 2. if opb is empty, add one token to res
  // 3. refill opb from buffer
  // 4. check if m = n = 0. if so, make all transitions unfireable (this is checked with opa and opb_copy_buffer being 0)

public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  let myDivider = InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      InhibitorNet.Transition(
          name: "copy_b", pre: [.opa: 1, .opb: 1, .refill: .inhibitor], post: [.opb_copy_buffer: 1]),
      InhibitorNet.Transition(
          name: "enable_refill", pre: [.opb: .inhibitor, .refill: .inhibitor], post: [.refill: 1, .res: 1]),
      InhibitorNet.Transition(
          name: "refill", pre: [.refill: 1, .opb_copy_buffer: 1], post: [.refill: 1, .opb: 1]),
      InhibitorNet.Transition(
          name: "disable_refill", pre: [.refill: 1, .opb_copy_buffer: .inhibitor], post: [:]),
    ])
  return myDivider
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  let initMarking: [DividerPlaceSet: Int] = [.opa: opa, .opb: opb, .res: 0, .refill: 0, .opb_copy_buffer: 0]

  return initMarking
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res

  // Refilling flag
  case refill
  // A buffer that functions as a copy of opb
  case opb_copy_buffer
}
