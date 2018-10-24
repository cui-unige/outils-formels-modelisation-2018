import PetriKit

/// Analyzes a bounded Petri net to determine some of its properties.
func analyze<PlaceSet>(
  _ model: PTNet<PlaceSet>,
  withInitialMarking initialMarking: Marking<PlaceSet, UInt>)
{
  guard let states = computeGraph(of: model, from: initialMarking) else {
    print("The model is unbounded")
    return
  }
  print("There are \(states.count) state(s) accessible from the initial marking.")

  // What is the bound of the model?
  // on le fait de manière fonctionnel en ex
  // stat sont des noeuds de graphe
  // marking est un dico // on a une collection dans le marking// on ne veut que les token
// map n'est pas un dico
// on utilise map().max retourn le maximum du tableau. max renvoi un optionnel car map peut être utiliser sur un optionnel
// on sait que notre tableau n'est pas vide on utilise le point "!"
// on obtient un array de UInt
// on réutilise un .max()
  let bound = states.map({state in state.marking.map({ (place, token) in token }).max()! }).max()! // TODO// retourn un tableau de tableau UInt
  print("The model is \(bound)-bounded. (methode fonctionnelle)")
// autre méthode
  var bound2 : UInt = 0
  for state in states {
    for(_ , token) in state.marking {
      bound2 = max(bound2, token)
    }
  }
  print("The model is \(bound2)-bounded. (methode imperatif)")


  // Is the model L3-live (i.e. "vivant")?
  // on vérifie la propriété pour chaque successeur.
  let isL3 = mode.transition.allSatisfy({ transition in state.allSatisfy({ m in m.contains (where :{ transition.isFirable(from: $0.marking)})})
  print("The model is\(!isL3 ? " not" : "") L3-live.")



  // Is the model L1-live (i.e. "quasi-vivant")?
// au moins un état doit satisfaire la proprietet
let isL1 = model.transitions.allSatisfy({ transition in
    states.contains(where: { transition.isFirable((from : $0.marking))})

  print("The model is\(!isL1 ? " not" : "") L1-live.")
  // Is the model dead?

  //est vrai si un état n'a pas de successor// successors est un dico
  let isDead = states.contains(where :  { state in state.successors.isEmpty})// TODO
  // autre méthode mais plus complique on applique l'inverse
  // on regarde qu'il y en a
  //let isDead2 = states.allSatisfy({state in models.transitions.contains(where: { $0.isFirable(from: state.marking) } ) } )
  print("The model is\(!isDead ? " not" : "") dead.")
  //
//print("The model is\(!isDead2 ? " not" : "") dead. autre implementation plus compliquée")

}
