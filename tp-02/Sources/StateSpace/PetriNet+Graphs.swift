extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // We have to explore all possible states of the model to make
    // the marking graph. We begin with the state at 'initialMarking'
    let root: MarkingNode<Place> = MarkingNode(marking: initialMarking)
    var to_explore: [MarkingNode<Place>] = [root]
    var node_list: [MarkingNode<Place>] = [root]

    while !to_explore.isEmpty // We explore as long as we have to
    {
      let current_node: MarkingNode<Place> = to_explore.popLast()!
      let current_marking: Marking<Place, Int> = current_node.marking
      // We explore every transition fireable at any state
      for transition in self.transitions
      {
        if !transition.isFireable(from: current_marking) { continue }
        let next_marking: Marking<Place, Int> = transition.fire(from: current_marking)!
        // When we find a successor, we test it
        if node_list.contains(where: { other in next_marking > other.marking })
        {
          // If the successor is greater than an already explored state, then
          // the model is unbounded
          return nil
        }
        else if let next_node = node_list.first(where : { other in
          place_list.allSatisfy { other.marking[$0] == next_marking[$0] }
        })
        {
          // If the successor is already an explored state, we add the
          // transition into the marking graph
          current_node.successors[transition] = next_node
        }
        else
        {
          // The successor is new and the model is bounded so far, so we create
          // a node for it ..
          let next_node: MarkingNode<Place> = MarkingNode(marking: next_marking)
          node_list.append(next_node) // add it to the node list ..
          to_explore.append(next_node) // add it to be explored ..
          current_node.successors[transition] = next_node
          // and add the transition to reach it from current_node into the graph
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
