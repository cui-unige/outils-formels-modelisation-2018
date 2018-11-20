/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Créer un processus pour faire la division avec opa/opb :

  return InhibitorNet(
    places: Set( DividerPlaceSet.allCases ),
    transitions: [
      InhibitorNet.Transition(
        // soustraire opa-opb et stocker dans opa.
        // stocker nombre de jeton de opb jusqu'à avoir opa < opb
        name: "sub", pre: [.opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]
      ),
      InhibitorNet.Transition(
        // quand opb vide, incrémenter res et enb
        // quand opb > opa alors plus tirable donc resultat de la divison dans res
        name: "1", pre: [.opb: .inhibitor, .enb: .inhibitor], post: [.enb: 1, .res: 1]
      ),
      InhibitorNet.Transition(
        // vider sto et remplir a nouveau opb pour prochaine soustraction
        name: "2", pre: [.enb: 1, .sto: 1], post: [.enb: 1, .opb: 1]
      ),
      InhibitorNet.Transition(
        // enfin on vide enb
        name: "3", pre: [.enb: 1, .sto: .inhibitor], post: [:]
      ),
    ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // marquage initial du Divider Model
  return [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto: 0]
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
  // socker le nombre de jeton jusqu'a opa < opb
  case sto

  // pour la répétition du processus dans division
  case enb

}
