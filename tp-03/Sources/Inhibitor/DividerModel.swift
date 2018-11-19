/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(
  places: Set(DividerPlaceSet.allCases),
  transitions: [
    InhibitorNet.Transition(
      //permet de soustraire opb à opa (une fois).
      //pour pouvoir réitérer la soustraction, on crée un backup de ces derniers (sto)
      name: "str", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
    InhibitorNet.Transition(
      //permet le remplissage de opb, qui a été vidé lors de la soustraction,
      //à partir du nombre de jetons qui se trouve dans sto
      name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
    InhibitorNet.Transition(
      //permet de démarrer le processus de remplissage de opb via sto
      name: "ini rfl", pre: [ .opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),
    InhibitorNet.Transition(
      //permet de stop le remplissage de opb (lorsqu'il n'y a plus de jetons dans sto)
      //pour passer à la prochaine soustraction (on consomme ena sans le "recréer")
      //+ incrémente le nombre de jetons dans res (car une soustraction)
      name: "post rfl", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1]),
  ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.

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

  // Add your additional places here, if any.

  //backup des jetons d'opb
  case sto
  //active le remplissage de opb pour pouvoir procéder à une nouvelle soustraction
  case ena
}
