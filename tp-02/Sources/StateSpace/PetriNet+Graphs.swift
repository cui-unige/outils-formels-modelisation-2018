extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking)
    var analysedNodes: [MarkingNode<Place>] = [root] //liste des places analysées
    var toAnalyse: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] //liste du tuple : noeud "en cours" associé aux listes des places à analyser
    while !toAnalyse.isEmpty
    {
      let (currentNode, predecessors) = toAnalyse.popLast()! //prendre - si c'est possible - le dernier élément de "toAnalyse"
      for t in transitions
      {
        if let resultingMarking = t.fire(from: currentNode.marking) //si la transition est tirable alors :
        {
          if let successors = analysedNodes.first(where: {exploredNode in exploredNode.marking == resultingMarking})
          {
            currentNode.successors[t] = successors
          }
          else if (predecessors.contains(where: {predecessor in resultingMarking > predecessor.marking}))
          {
            return nil
          }
          else
          {
            let newMarkingNode = MarkingNode(marking: resultingMarking)
            toAnalyse.append((newMarkingNode, predecessors + [currentNode]))
            analysedNodes.append(newMarkingNode)
            currentNode.successors[t] = newMarkingNode
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
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking))
    var analysedNodes: [CoverabilityNode<Place>] = [root]
    var toAnalyse: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]
    while !toAnalyse.isEmpty
    {
      let (currentNode, predecessors) = toAnalyse.popLast()!
      for t in transitions
      {
        if var resultingMarking = t.fire(from: currentNode.marking)
        {
          if let predecessor = predecessors.first(where: {predecessor in resultingMarking > predecessor.marking})
          {
            for place in Place.allCases
            {
              if(resultingMarking[place] > predecessor.marking[place])
              {
                resultingMarking[place] = .omega
              }
            }
          }
          if resultingMarking > currentNode.marking
          {
            for place in Place.allCases
            {
              if(resultingMarking[place] > currentNode.marking[place])
              {
                resultingMarking[place] = .omega
              }
            }
          }
          if let successors = analysedNodes.first(where: {exploredNode in exploredNode.marking == resultingMarking})
          {
            currentNode.successors[t] = successors
          }
          else
          {
            let newCoverabilityNode = CoverabilityNode(marking: resultingMarking)
            toAnalyse.append((newCoverabilityNode, predecessors + [currentNode]))
            analysedNodes.append(newCoverabilityNode)
            currentNode.successors[t] = newCoverabilityNode
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
