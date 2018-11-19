/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
    // Write your code here.
    return InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
        InhibitorNet.Transition(
            name: "subtract", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.buf: 1]),
        InhibitorNet.Transition(
            name: "rfl", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1, .res: 1]),
        InhibitorNet.Transition(
            name: "loop", pre: [.ena: 1, .buf: 1], post: [.ena: 1, .opb: 1]),
        InhibitorNet.Transition(
            name: "stop", pre: [.ena: 1, .buf: .inhibitor], post: [:]),
    ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
    // Write your code here.
    return [.opa: opa, .opb: opb, .res: 0, .buf: 0, .ena: 0,]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
    /// The first operand.
    case opa
    /// The second operand
    case opb
    /// The result of `opa * opb`.
    case res
    /// Enable refill
    case ena
    /// The n buffer
    case buf
}
