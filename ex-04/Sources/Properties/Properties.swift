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

  // On cherche le plus grand nombre de jeton dans le marquage et trouver le maximum, correspond au A(R,M0)
  // paires de places, token                                                         // pas nul on sait qu'il y en a 1
      // k                                             // _  ,                     // ! tableau pas vide   // ! minimum 1 élément
  let bound = states.map({ state in state.marking.map({ (_, token) in token }).max()! }).max()!
  //print(type(of:bound)) //le type de bound = array de array(int)
  // state.marking.map({place, token} in token) retourne un tableu de ExtendedInt
  // states.map(...) tableau de tableau de ExtendedInt
  // map pas un dictionnaire

/*
  print(bound): UInt = 0
  for state in states{
  for (_,token) in state.marking{
    bound = max(bound,token) // itère sur chaque paires de places token --> 1 bounded
  } }

*/
  print("The model is \(bound)-bounded.")


  // Is the model L3-live (i.e. "vivant")?
  // propriété transition, il faut qu'elle soit vrai pour chaque transition (verify)
  // Quasi-vivante pour chaque etat = pour chaque état, contient une transition franchi au mois une fois
  let isL3 =  model.transitions.allSatisfy({ transition in
  states.allSatisfy({ m in
  m.contains(where: { transition.isFireable(from:$0.marking)})
}) })
  print("The model is\(!isL3 ? " not" : "") L3-live.")



  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = model.transitions.allSatisfy({ transition in
  states.contains(where:{ transition.isFireable(from:$0.marking) })
})
  print("The model is\(!isL1 ? " not" : "") L1-live.")
  // Pour toutes transition, toutes satisfait pour tout état transition satisfait cet état



  // Is the model dead? // Déterminer qu'un réseau est mort
  // exemple/contre exemple
  // Réseau bloqué avec jeton = une place une transitions
  // Un réseau vivant, semi-vivant
  // Marquage puit, qui n'a pas de successeurs

      let isDead = states.contains(where: { state in state.successors.isEmpty })
       // vrai si un état qui n'a pas de successeurs // contre exemple // cherche si il en a un
       //  let isDead2 = states.allSatisfy({state in model.transition.contains(where $0.isFireable(from:state.marking):{})
      // chaque etat, cherché la transition pour laquelle elle est tirable // preuve //montre qu'il y en a pas

  print("The model is\(!isDead ? " not" : "") dead.")

  let deadState = states.first(where: {state in state.successors.isEmpty})!
  // premier pour lequel il n'y a pas de successeurs
  //t1 attend pour le log 1 et t2 attend pour le log 2
  // Bloquage
  print(deadState.marking)
}
