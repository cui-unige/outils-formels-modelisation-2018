/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.



    return InhibitorNet(places: Set(DividerPlaceSet.allCases),  transitions: [
        // on effectue la soustraction de opb sur opa, on stock les jetons d'opb dans sto
        InhibitorNet.Transition(
          name: "str", pre: [ .opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),
        // Une fois passer le ch1 on recommence à reremplir opb pour la prochaine soustraction
        //on vide sto, pour la prochaine soustraction, on redonne un jeton à enb pour recommencer la transition
        //une fois sto vide la transition ne pourra plus être tirable
        InhibitorNet.Transition(
          name: "rfl", pre: [ .sto: 1, .enb: 1], post: [ .enb: 1, .opb: 1]),
        // la transition ch1 permet d'enclencher la transition rfl, elle s'active que quand enb est vide et opb l'est aussi
        // elle donne le jeton activateur de la prochaine transition à enb
        // ch1 est activé après avoir vidé totalement opb donc le résultat s'incrémente de 1 seulement quand on passe sur cette transition
        // si il restera des jeton à la fin dans opb alors le résultat ne s'incrémentera plus et opa bloquera le Rdp
        InhibitorNet.Transition(
          name: "ch1", pre: [ .opb: .inhibitor, .enb: .inhibitor], post: [ .enb: 1, .res: 1]),
          // la transition ch2 permet de recommencer la soustraction, car elle prend enb et permet ainsi de débloquer
          // la transition pour les soustractions,
          // la transition ne renvoie aucun autre jeton, elle ne fait qu'enlever celui existant dans enb
        InhibitorNet.Transition(
          name: "ch2", pre: [ .enb: 1, .sto : .inhibitor], post: [:]),
        ] )
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  // on associe les paramètre de la fonction à .opa et .opb les autre place contienne au début aucun jeton pour le bon fonctionnement du processus
  let initialMarking: [DividerPlaceSet: Int] = [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto:0 ]
  return  initialMarking // on retourne le marquage initial

}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb // opb active également ch1 avec enb
  /// The result of `opa * opb`.
  case res

  // Add your additional places here, if any.
case enb // place pour activer les transitions (chemins) ch1 et ch2 est permet le boucle sur rfl
case sto // place pour également activer les transition ch1 et rfl
        // elle permet surtout de stocker les jetons de opb
}
