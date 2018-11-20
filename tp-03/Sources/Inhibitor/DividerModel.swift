/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {

  /// on fait grosso modo la même chose que la multiplication,
  /// sauf que le moment de remplissage de res ne se fait pas au même moment
  /// cad : on incrémente res lorsqu'on a pu tirer "disable refill"

  /// idée générale : on veut savoir combien de fois on peut soustraire opb à opa
  /// add            : vide a et b jusqu'à ce que l'un des deux soit vide, et remplit sto
  /// refill         : vide remt sto dans opb, si ena est à 1 (et le garde à 1) (si sto n'atteint pas la valeur originale de opb, c'est pas grave par ce que ça veut dire que de toute façon, opa est vide)
  /// enable refill  : on peut vider sto dans opb
  /// disable refill : on a fini une loop : on a réussi à mettre un opb dans opa, on incrémente res

  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [

      InhibitorNet.Transition(
        name: "add", pre: [ .opa: 1, .opb: 1, .ena: .inhibitor ], post: [ .sto: 1 ]),

      InhibitorNet.Transition(
        name: "refill", pre: [ .ena: 1, .sto: 1 ], post: [ .ena: 1, .opb: 1 ]),

      InhibitorNet.Transition(
        name: "enable refill", pre: [ .opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),

      InhibitorNet.Transition(
        name: "disable refill", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1]),
    ])

}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// input  value : opa
  case opa
  /// input  value : opb
  case opb
  /// output value : floor( opa / opb )
  case res

  // helper
  /// A flag that enables the refilling of `opb`.
  case ena

  /// Store the tokens to refill in `opb`.
  case sto

}
