/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  let net = InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      //On soustrait opb à opa et on envoie les jetons soustraits dans sto
      InhibitorNet.Transition(
        name: "sub", pre: [.opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),
      //On remplit opb depuis sto tant que enb et sto ont des jetons.
      InhibitorNet.Transition(
        name: "rfl", pre: [.enb: 1, .sto: 1], post: [.enb: 1, .opb: 1]),
      //On active le remplissage de opb si opb et enb sont vides.
      //On ajoute un jeton à res et à enb.
      InhibitorNet.Transition(
        name: "ch1", pre: [.opb: .inhibitor, .enb: .inhibitor], post: [.enb: 1, .res:1]),
      //On désactives le remplissage de opb.
      InhibitorNet.Transition(
        name: "ch2", pre: [.enb: 1, .sto: .inhibitor], post: [:]),
    ])

  return net
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  let initialMarking: [DividerPlaceSet: Int] = [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto: 0]
  return initialMarking
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa/opb`.
  case res
  // Place permettant de savoir quand on peut remplir opb.
  case enb
  // Place qui stocke les jetons à replacer dans opb.
  case sto
}
