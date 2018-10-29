import PetriKit

/// Analyzes a bounded Petri net to determine some of its properties.
// il faut que les reseu soit borne
func analyze<PlaceSet>(
  _ model: PTNet<PlaceSet>,
  withInitialMarking initialMarking: Marking<PlaceSet, UInt>)
{
  guard let states = computeGraph(of: model, from: initialMarking) else {
    print("The model is unbounded")
    return
  }
  print("There are \(states.count) state(s) accessible from the initial marking.")
  // calcul de proprietes
  // What is the bound of the model?
  // ce quon va probablement utiliser: states; model.transitions
  // utilisation combinée intelligente de allsatisfiede et contains et prediicats
  // fonction ifFireable
  //utiliser la fonction map
  //extraire le nb max d tout jeton dans touts marquage

  // State = noeud de graohe, itération collection de noeuds
  // Marking dicitonnaire de clé et de valeur, pour avoir que token réitere sur state
  // Fabrique un tableau d'un tableau de uInt
  // Méthode Max retourne le maximum d'une séquence
  // code de manière fonctionnel
  let bound = states.map({ state in state.marking.map({ (place,token) in token}).max()! }).max()! // TODO
  // Trouver algorithme qui respecte la propriété
  // Chercher la borne. Plusieurs solutions.
  // Itérer dans chaque marquage et prendre le plus grand nombre de jetons chaque foi

  // Version impérative du code
  //var bound: UInt = 0
  //for state in states {
  //     for(_, token) in state.marking{
  //         bound = max(bound, token)
  //     }
  // }

  print("The model is \(bound)-bounded.")
  print(bound)

  // Is the model L3-live (i.e. "vivant")?
  let isL3 = false // TODO
  print("The model is\(!isL3 ? " not" : "") L3-live.")

  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = false // TODO
  print("The model is\(!isL1 ? " not" : "") L1-live.")

  // Is the model dead? blocage/ etat puis
  // Pas de transition tirable
  let isDead = states.contains(where : { state in state.successors.isEmpty})
  // let isDead2 = states.allSatisfy({ state in models.transitions.contains(where: {$0.isFireable(from: state.marking)})})
  print("The model is\(!isDead ? " not" : "") dead.")
}
