/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
    return InhibitorNet(
        places: Set(DividerPlaceSet.allCases),
        transitions: [
            // Effectue opa-opb, n'est pas tirable si on effectue une recharge
            InhibitorNet.Transition(
                name: "les", pre: [.opa: 1, .opb: 1, .arf: .inhibitor], post: [.sto: 1,]),
            // Recharge les jetons dans opb
            InhibitorNet.Transition(
                name: "rfl", pre: [.arf: 1, .sto: 1], post: [.arf: 1, .opb: 1]),
            // ajoute 1 au résultas, et prépare la recharge de opb
            InhibitorNet.Transition(
                name: "atr", pre: [.opb: .inhibitor, .arf: .inhibitor], post: [.res: 1, .arf: 1]),
            //Finis la recharge
            InhibitorNet.Transition(
                name: "eof", pre: [.sto: .inhibitor, .arf: 1], post: [:]),
            ])
    
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
    return [.opa: opa, .opb: opb, .res: 0, .sto: 0, .arf:0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

    // Premier operand.
    case opa
    // Second operand
    case opb
    // Résultat de `opa / opb`.
    case res
    // Stock les jetos de opb pour le recharger
    case sto
    // arf est une place qui à un token quand on recharge opb
    case arf

  // Add your additional places here, if any.

}
