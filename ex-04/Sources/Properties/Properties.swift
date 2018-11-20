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
  let bound = 0 // TODO
  print("The model is \(bound)-bounded.")

  // Is the model L3-live (i.e. "vivant")?
  let isL3 = false // TODO
  print("The model is\(!isL3 ? " not" : "") L3-live.")

  // Is the model L1-live (i.e. "quasi-vivant")?
  let isL1 = false // TODO
  print("The model is\(!isL1 ? " not" : "") L1-live.")

  // Is the model dead?
  let isDead = false // TODO
  print("The model is\(!isDead ? " not" : "") dead.")
}
