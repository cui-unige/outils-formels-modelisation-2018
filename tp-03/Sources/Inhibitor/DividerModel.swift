/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
    return InhibitorNet(
        places: Set(DividerPlaceSet.allCases),
        transitions: [
            InhibitorNet.Transition(
                name: "ajout", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
            InhibitorNet.Transition(
                name: "recharge", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]), // (ne change pas)
            InhibitorNet.Transition(
                name: "active", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]), // (ne change pas)
            InhibitorNet.Transition(
                name: "desactive", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1]),
            ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
    return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
    
    /// The first operand.
    case opa
    /// The second operand
    case opb
    /// The result of `opa * opb`.
    case res
    case ena
    case sto
}
