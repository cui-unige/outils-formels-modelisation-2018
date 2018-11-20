
/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
    return InhibitorNet(places: Set(DividerPlaceSet.allCases), transitions: [
        InhibitorNet.Transition(name: "A",
                                pre: [.opa: 1, .opb: 1, .inter: .inhibitor],
                                post: [.sto : 1]),
        InhibitorNet.Transition(name: "B",
                                pre: [.inter: 1, .sto: 1],
                                post: [.inter : 1, .opb: 1]),
        InhibitorNet.Transition(name: "C",
                                pre: [.inter: .inhibitor, .opb: .inhibitor],
                                post: [.inter : 1]),
        InhibitorNet.Transition(name: "D",
                                pre: [.inter: 1, .sto: .inhibitor],
                                post: [.res : 1])
        ])
}
/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
    // Write your code here.
    return [.opa: opa, .opb: opb, .res: 0, .sto: 0, .inter: 0]
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

    case inter
}
