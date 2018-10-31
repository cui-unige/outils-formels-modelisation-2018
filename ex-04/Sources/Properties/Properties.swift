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
  let bound = states.map({state in state.marking.map({(place, token) in token}).max()! }).max()! //retourne un array de UInt, le "!" sert à dire qu'on sait ce qu'on va avoir. La fonction max() retourne un Optional UInt car elle peut accepter en entrée de fonction un array vide.

  //Vérifier pour toutes les places si le nombre de jetons de chacune des places, pour tout marquage est inférieur ou égal à la borne.
  //Si le marquage est supérieur, on augmente la valeur de bound.
  //states correspond à A(R,M0)
  // MarkingType est une sorte de map
  //Forme itérative
  /*var bound = 0
  for state in states{
    for (_, token) in state.marking{ //Le "_" sert à ne pas bind le place car on n'en a ps besoin.
      bound = max(bound,token)
    }
  }*/

  print("The model is \(bound)-bounded.")

  // Is the model L3-live (i.e. "vivant")?
  let isL3 = false = model.transitions.allSatisfy({transition in states.allSatisfy({m in m.contains(where: {transition.isFireable(from: $0.marking) }) }) })
  print("The model is\(!isL3 ? " not" : "") L3-live.")

  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = model.transitions.allSatisfy({transition in states.contains(where: {transition.isFireable(from: $0.marking)})})
  print("The model is\(!isL1 ? " not" : "") L1-live.")

  // Is the model dead?
  let isDead = states.contains(where: {state.successors.isEmpty()})
  print("The model is\(!isDead ? " not" : "") dead.")
}
