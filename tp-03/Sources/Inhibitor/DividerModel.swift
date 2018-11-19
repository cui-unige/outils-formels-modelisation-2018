/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  //TODO
  // Meme principe que pour la multiplication
  // Principe: on veut savoir combien de fois on a opb dans opa, pour ca, on retire le nb de jetons de opb de opb
  // et de opa. on rerempli opb et on recommence jusqu'a ce qu'il n'y a plus de jetons dans opa
  // Le remplissage du resultat ne se fait pas au meme moment, on l'incrémente a chaque fois apres vider opb

  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases),
    transitions: [

      InhibitorNet.Transition(
          //retire jetons de opa et opb jusqu'a ce que l'un des deux soit vide et remplit le stock (pour reremplir opb plus tard)
          name: "retirer", pre: [ .opa: 1, .opb: 1, .ena: .inhibitor ], post: [ .stock: 1 ]),

      InhibitorNet.Transition(
          // remplis opb (meme nb de jetons que avant car dans stock), vide jetons du stock, prend et remet un jeton dans ena, pour que transition soit tirable
          name: "remplit", pre: [ .ena: 1, .stock: 1 ], post: [ .ena: 1, .opb: 1 ]),

      InhibitorNet.Transition(
          // fait en sorte que remplit soit tirable, met un jeton dans ena
          name: "enable remplit", pre: [ .opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]),

      InhibitorNet.Transition(
          // remplit le resultat, fait en sort que retirer soit tirable, enlève un jeton de ena
          // nb de jetons dans res represente le nb de fois qu'on a opb dans opa
          name: "remplit res", pre: [.ena: 1, .stock: .inhibitor], post: [.res: 1]),
    ]
)
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  //TODO
  //retourne le nb de jetons dans chaque place
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .stock: 0]
  //return [:]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res

  /// Add your additional places here, if any.
  //TODO
  // place qui permet de séquencer la division. si vide on soustrait/retire jetons, si plein on remplit jetons
  case ena

  // nb de jetons dans res represente le nb de fois qu'on a opb dans opa
  // place qui permet de reremplir opb avec le bon nb de jetons (on divise tjs par le meme nb), place de stockage temporaire
  case stock

}
