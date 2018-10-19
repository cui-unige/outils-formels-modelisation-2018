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
  // affiche le nb d'états accessibles

  // What is the bound of the model? - borne du réseau de pétrie

  /// Version fonctionnelle de bound ///
  // On va boucler sur states, tous les états possibles, pour voir si c'est borné et de combien
  // state donne un noeud
  // type de bound est array[array[unsigned Int]]
  // map renvoit un tableau; token = unsigned int;
  // max retourne un optionnel, on met ! car on sait qu'il y une valeur (donc pas optionnel)
  // on retourne le max d'un tableau puis on prend le max de tous les max

  /*let bound = states.map({state in state.marking.map({(_,token) in token}).max()!}).max()! // retourne un tab de unsigned int
  print(type(of:bound))*/

  /// Version impérative de bound ///
  var bound : UInt = 0
  for state in states {
    for (_,token) in state.marking {
      bound = max(bound,token)
    }
  }
  print("The model is \(bound)-bounded.")

  // Is the model L3-live (i.e. "vivant")?
  let isL3 = false // TODO
  print("The model is\(!isL3 ? " not" : "") L3-live.")

  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = false // TODO
  print("The model is\(!isL1 ? " not" : "") L1-live.")

  // Is the model dead?
  // successors est un dictionnaire donc on peut mettre .isEmpty
  let isDead = states.contains(where: { state in state.successors.isEmpty })
  let isDead2 = states.allSatisfy({ state in
    model.transitions.contains(where: { $0.isFireable(from: state.marking) }) })
  print("The model is\(!isDead ? " not" : "") dead.")
}
