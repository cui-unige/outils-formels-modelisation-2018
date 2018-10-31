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
  var bound: UInt = 0
  for state in states {
    for (_, token) in state.marking {
      bound = max(bound, token)
    }
  }
  print("The model is \(bound)-bounded.")

  let bound_prof = states.map({ state in state.marking.map({ (place, token) in token }).max()! }).max()!
  print("The model is \(bound_prof)-bounded.")

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
  print("The model is\(!isDead ? " not" : "") dead.")
}
