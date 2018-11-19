/// This function creates the model of a natural divider.

/// Note: le modèle proposé est basé sur le modèle de multiplicateur
/// du 'main.swift'. Il comprend 5 places, 4 transitions et calcule
/// la division euclidienne/entière de 'opa/opb'.
/// Algorithme: on compte le nombre de fois qu'on peut soustraire
/// opb à opa. La soustraction se fait unité par unité, la place sto
/// et les transitions de '*refill' s'occupent de réinitialiser la
/// valeur de opb à chaque cycle de soustraction et de mettre à jour
/// le résultat dans la place 'res'. La place 'ena' est là pour
/// savoir si le modèle est en train de soustraire ou remplir.
/// Ce modèle est borné : lorsque les places 'opa' et 'sto' sont
/// vides, le modèle est bloqué.

public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  /// The structure of the model.
  let net = InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [
      InhibitorNet.Transition(
          name: "substraction", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
      InhibitorNet.Transition(
          name: "enable_divider_refill", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1, .res: 1]),
      InhibitorNet.Transition(
          name: "refill", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]),
      InhibitorNet.Transition(
          name: "disable_divider_refill", pre: [.ena: 1, .sto: .inhibitor], post: [:]),
    ])
  return net
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0,]
}

/// This eopaeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  /// The numerator
  case opa
  /// The denominator
  case opb
  /// The result of `opa / opb`.
  case res
  /// A flag that enables the refilling
  case ena
  /// A buffer, stores the divider
  case sto
}
