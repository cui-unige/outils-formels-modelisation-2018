/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      // add ajoute des jetons dans res à chaque fois qu'on peut enlever opb de opa
      InhibitorNet.Transition(
        name: "add", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
      // rfl reremplis opb
      InhibitorNet.Transition(
        name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
      // ch1 active le reremplissement de opb
      InhibitorNet.Transition(
        name: "ch1", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),
      // ch2 désactive le reremplissement de opb.
      InhibitorNet.Transition(
        name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1]),
    ])
}
/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]
}
/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  /// opa est la 1ère opérande.
  case opa
  /// opb est la 2ème opérande.
  case opb
  /// res est le résultat de opa / opb`.
  case res
  /// ena est un flag qui permet le reremplissement de `opb` (quand il vaut 1).
  case ena
  /// sto contient les jetons pour remplir `opb`.
  case sto
}
