/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
    let net = InhibitorNet(
        places: Set(PlaceSet.allCases),
        transitions: [
            // Add tokens in `res` as long as there are some to consume in `opa` and `opb`.
            InhibitorNet.Transition(
                name: "les", pre: [.opa: 1, .opb: 1], post: [.sto: 1,]),
            // Refills the tokens of `opa`.
            InhibitorNet.Transition(
                name: "rfl", pre: [.ena: .inhibitor, .sto: 1], post: [.res: 1, .opb: 1]),
            // Activates the refilling of `opa`.
            InhibitorNet.Transition(
                name: "ch1", pre: [.sto: 1], post: [.opb: 1]),
            ])
  return InhibitorNet(places: [], transitions: [])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
    let initialMarking: [PlaceSet: Int] = [.opa: a, .opb: b, .res: 0, .sto: 0]
  return [:]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

    /// The first operand.
    case opa
    /// The second operand
    case opb
    /// The result of `opa / opb`.
    case res
    /// Store the tokens to refill in `opb`.
    case sto

  // Add your additional places here, if any.

}
