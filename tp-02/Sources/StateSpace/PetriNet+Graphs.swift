extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking)

    var nodes: [MarkingNode<Place>] = [root]
    var toProcess: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // a node and its predecessors, that is all the nodes from where the node can be reached

    while let (currentNode,predecessors) = toProcess.popLast() // while there are still nodes to process
    {
      for transition in transitions // iterate over transitions
      {
        if let firedMarking = transition.fire(from: currentNode.marking) // if transition is fireable, obtain firedMarking
        {
          if let successors = nodes.first(where: {$0.marking == firedMarking}) //  https://docs.swift.org/swift-book/LanguageGuide/Closures.html // if successor belongs to list of already processed nodes
          {
            currentNode.successors[transition] = successors
          }

          else if (predecessors.contains(where: {firedMarking > $0.marking})) // model is unbounded. One of firedMarking predecessor is smaller thab firedMarking. https://cs.stackexchange.com/questions/49240/petri-nets-boundedness
          // A place in a Petri net is called k-bounded if it does not contain more than k tokens in all reachable markings, including the initial marking;
          {
            return nil
          }

          else
          {
            let newNode = MarkingNode(marking: firedMarking)
            toProcess.append((newNode, predecessors + [currentNode]))
            nodes.append(newNode)
            currentNode.successors[transition] = newNode
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
    var nodes: [CoverabilityNode<Place>] = [root]
    var toProcess: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])] // a node and its predecessors, that is all the nodes from where the node can be reached

    while let (currentNode,predecessors) = toProcess.popLast() // while there are still nodes to process
    {

      for transition in transitions
      {
        if var firedMarking = transition.fire(from: currentNode.marking)
        {
          if let predecessor = predecessors.first(where: {firedMarking > $0.marking})
          {
            for place in Place.allCases
            {
              if(firedMarking[place] > predecessor.marking[place])
              {
                firedMarking[place] = .omega
              }
            }
          }

          if firedMarking > currentNode.marking
          {
            for place in Place.allCases
            {
              if(firedMarking[place] > currentNode.marking[place])
              {
                firedMarking[place] = .omega
              }
            }
          }

          if let successors = nodes.first(where: {$0.marking == firedMarking})
          {
            currentNode.successors[transition] = successors
          }

          else
          {
            let newNode = CoverabilityNode(marking: firedMarking)
            toProcess.append((newNode, predecessors + [currentNode]))
            nodes.append(newNode)
            currentNode.successors[transition] = newNode
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
