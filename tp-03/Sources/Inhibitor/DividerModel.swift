/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  let net = InhibitorNet( // On crée le réseau de Petri inhibiteur qui effectue la divison entière opa/opb
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      // On effectue la soustraction opa - opb dont le résultat est stocké dans opa. Et on remplit sto du nombre de jeton de opb jusqu'à ce que opb > opa.
      InhibitorNet.Transition(
        name: "sub", pre: [.opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),
      // Une fois que opb est vide on incrémente res de 1 et enb de 1.
      InhibitorNet.Transition(
        name: "ch1", pre: [.opb: .inhibitor, .enb: .inhibitor], post: [.enb: 1, .res: 1]),
      // On vide ensuite sto et on remplit à nouveau opb pour effectuer la prochaine soustraction
      InhibitorNet.Transition(
        name: "rfl", pre: [.enb: 1, .sto: 1], post: [.enb: 1, .opb: 1]),
      // On vide également enb.
      InhibitorNet.Transition(
        name: "ch2", pre: [.enb: 1, .sto: .inhibitor], post: [:]),
    ])
    // Le processus va continuer jusqu'à ce que opb > opa, à ce moment ch1 ne pourra pas être tirable
    // et on aura bien le résultat de la division entière dans res.

  return net // On renvoie le réseau de Petri inhibiteur de notre Divider Model
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto: 0] // Le marquage initial de notre Divider Model.
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
  case enb // utilisé pour répéter le processus décrit plus haut en vidant sto et en remplissant opb

  case sto // contient le nombre de jeton de opb, jusqu'à ce que opb > opa

}
