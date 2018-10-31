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
  print(type(of: states))

  // What is the bound of the model?
  // mode fonctionnel :
  // utiliser la fonction map() --> retourne un tableau
  // la fonction max() --> retourne un optionel
  // on pourrait mettre place au lieu de _ // _ permet d'ignorer la variable.
  let bound = states.map({ state in state.marking.map({ (_, token) in token }).max()! })
  // mode iteravtive :
  // var bound: UInt = 0
  // for state in states {
  //   for (_, token) in state.marking {
  //     bound = max(bound, token)
  //   }
  // }
  print(type(of: bound))
  print("The model is \(bound)-bounded.")

  // Is the model L3-live (i.e. "vivant")?
  let isL3 = model.transitions.allSatisfy({ transition in
    states.allSatisfy({ m in
    m.contains(where: { transition.isFireable(from: $0.marking) })
   })
  })
  print("The model is\(!isL3 ? " not" : "") L3-live.")

  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = model.transitions.allSatisfy({ transition in
    states.contains(where: { transition.isFireable(from: $0.marking) })
  })
  print("The model is\(!isL1 ? " not" : "") L1-live.")

  // Is the model dead?
  let isDead = states.contains(where: { state in state.successors.isEmpty })
  // let isDead2 = states.allSatisfy({ state in
  //   model.transitions.contains(where: { $0.isFireable(from: state.marking) })
  // })
  print("The model is\(!isDead ? " not" : "") dead.")

  let deadState = states.first(where: { state in state.successors.isEmpty })!
  print(deadState.marking)
}
