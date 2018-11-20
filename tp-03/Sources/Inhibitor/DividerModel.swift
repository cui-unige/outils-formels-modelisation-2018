/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(places: Set(DividerPlaceSet.allCases), transitions: [
    //Reprend les mêmes places
    //A chaque fois que l'on peut retirer des jetons dans opa et opb on en
    //rajoute dans res (résultat final)
    InhibitorNet.Transition(name: "sub",
                            pre: [.opa: 1, .opb: 1, .ena: .inhibitor],
                            post: [.sto : 1]),
    //Remplit le deuxipme opérande
    InhibitorNet.Transition(name: "rfl",
                            pre: [.ena: 1, .sto: 1],
                            post: [.ena : 1, .opb: 1]),
    //Active le remplissage de deuxième oprande
    InhibitorNet.Transition(name: "ch",
                            pre: [.ena: .inhibitor, .opb: .inhibitor],
                            post: [.ena : 1]),
    //Désactive le "remplissage" du deuxième opérande
    InhibitorNet.Transition(name: "ch1",
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
  /// The result of opa/opb
  case res
  // Autorise le reremplissage de opb
  case ena
  //Stock les tokens pour reremplir opb
  case sto
}
