import PetriKit

/// Analyzes a bounded Petri net to determine some of its properties.
func analyze<PlaceSet>(
  _ model: PTNet<PlaceSet>,
  withInitialMarking initialMarking: Marking<PlaceSet, UInt>)
{ //calcul le graph de marquage (TP2)
  guard let states = computeGraph(of: model, from: initialMarking) else {
    print("The model is unbounded")
    return
  } //nombre d'états accessibles depuisle maquqage initial.
  print("There are \(states.count) state(s) accessible from the initial marking.")
// //modele itératif
//   var bound : UInt = 0
//   for state in states {
//     for (_, token) in state.marking {
//       bound = max(bound, token)
//     }
//   }
// //"The model is 1-bounded."
//   print("The model is \(bound)-bounded.")

  print("There are \(states.count) state(s) accessible from the initial marking.")
  //slide 11 prés des propriétés
  // What is the bound of the model?
  //let bound = 0 // TODO utiliser func map genre
                //extraire le maximum de jeton de chaque place.

                //chercher le plus grand nombre de marquage --> states = A(R, M0)
                //state = noeud de graphe
                //marking = clé de dictionnaire, clé de valeurs.
                //type de "bound" = Arra<Array<UInt>> car map retourne toujours un tableau.
                //avec max=> type = Array<Optional<UInt>> Optional pcq max peut être lancé sur un Array vide.
                //avec ! => type= Array<UInt>
  let bound = states.map({ state in state.marking.map({ (/*place*/ _, token) in token }).max()!/*on sait que le tableau ne sera pas vide, donc plus de "Optional"*/ }).max()!
  //"The model is 1-bounded."
  print("The model is \(bound)-bounded.")

  // Is the model L3-live (i.e. "vivant")?      l3 liveness(vivacité) WIKIPEDIA
  let isL3 = model.transitions.allSatisfy({ transition in states.allSatisfy({ m in
    m.contains(where: { transition.isFireable(from: $0.marking) })
  })
})


  print("The model is\(!isL3 ? " not" : "") L3-live.")

  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = model.transitions.allSatisfy({ transition in states.contains(where: { transition.isFireable(from: $0.marking) }) })
  print("The model is\(!isL1 ? " not" : "") L1-live.")

  // Is the model dead?
  //le contre exemple
  //chercher si le réseau est blocable.
  let isDead =  states.contains(where: { state in state.successors.isEmpty})
  //la preuve pour tout, s'assure qu'il n'y en a pas.
  //let isDead2 = states.allSatisfy({ stat in models.transitions.contains(where: { $0.isFireable(from:state.marking) }) })

  print("The model is\(!isDead ? " not" : "") dead.")

  let deadState = states.first(where: { state in state.successors.isEmpty })!
  print(deadState.marking)
}
