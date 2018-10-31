extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking)

    var toExplore: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]
    var exploredNodes = [root]

    while !toExplore.isEmpty{
        let (currentlyExploring,predecessors) = toExplore.popLast()!

        for t in transitions{
            if let resultingMarking = t.fire(from: currentlyExploring.marking){
                if let successor = exploredNodes.first(where: {exploredNode in
                    exploredNode.marking == resultingMarking
                }){
                    currentlyExploring.successors[t] = successor
                }
                else if(predecessors.contains(where: { predecessor in
                    resultingMarking > predecessor.marking
                })){
                   return nil
                }
                else{
                    let newMarkingNode = MarkingNode(marking: resultingMarking)
                    toExplore.append((newMarkingNode, predecessors + [currentlyExploring]))
                    exploredNodes.append(newMarkingNode)
                    currentlyExploring.successors[t] = newMarkingNode
                }
            }
        }

    }

    return root
  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>) -> CoverabilityNode<Place>? {
    let root = CoverabilityNode(marking: extend(initialMarking))

    var toExplore: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]
    var exploredNodes = [root]

    while !toExplore.isEmpty{
        let (currentlyExploring,predecessors) = toExplore.popLast()!

        for t in transitions{
            if var resultingMarking = t.fire(from: currentlyExploring.marking){

                if let predecessor = predecessors.first(where: { predecessor in
                    resultingMarking > predecessor.marking
                }){
                    for place in Place.allCases{
                        if(resultingMarking[place] > predecessor.marking[place]){
                            resultingMarking[place] = .omega
                        }
                    }
                }
                if(resultingMarking > currentlyExploring.marking) {
                    for place in Place.allCases {
                        if resultingMarking[place] > currentlyExploring.marking[place]{
                            resultingMarking[place] = .omega
                        }
                    }
                }

                if let successor = exploredNodes.first(where: {exploredNode in
                    exploredNode.marking == resultingMarking
                }){
                    currentlyExploring.successors[t] = successor
                }
                else{
                    let newCoverabilityNode = CoverabilityNode(marking: resultingMarking)
                    toExplore.append((newCoverabilityNode, predecessors + [currentlyExploring]))
                    exploredNodes.append(newCoverabilityNode)
                    currentlyExploring.successors[t] = newCoverabilityNode
                }
            }
        }
    }

    return root
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
