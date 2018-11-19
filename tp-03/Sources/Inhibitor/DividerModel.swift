/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet (places: Set(DividerPlaceSet.allCases), transitions: [

    /*Etape "sub" : tant qu'il y a des jetons dans "opb", "opa" mais pas dans "enb",
    * un jeton est supprime de "opa" et "opb" et un jeton est ajouté dans "sto".*/
    InhibitorNet.Transition(
        name: "sub", pre: [ .opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),

    /*Etape "rfl" : tant que'il y a des jetons dans "enb" et "sto",
    * un jeton est supprimé de "sto" et ajouté dans "opb".*/
    InhibitorNet.Transition(
        name: "rfl", pre: [ .sto: 1, .enb: 1], post: [ .enb: 1, .opb: 1]),

    /*Etape "ch1" : s'il n'y a pas de jetons dans "opb" et "enb",
    * un jeton est ajouté dans "enb" et "res".*/
    InhibitorNet.Transition(
        name: "ch1", pre: [ .opb: .inhibitor, .enb: .inhibitor], post: [ .enb: 1, .res: 1]),

    /*Etape "ch2" : s'il n'y a pas de jeton dans "sto" et au moins un jeton est dans "enb",
    * tous les jetons de "enb" sont supprimé dans l'optique de relancer l'étape "sub".*/
    InhibitorNet.Transition(
        name: "ch2", pre: [ .enb: 1, .sto : .inhibitor], post: [:]),
  ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
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

  // Add your additional places here, if any.
  case enb
  /// Store the tokens to refill in `opb`.
  case sto
}
