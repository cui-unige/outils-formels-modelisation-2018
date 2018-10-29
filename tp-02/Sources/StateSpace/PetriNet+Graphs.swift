extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root: MarkingNode<Place> = MarkingNode(marking: initialMarking)
    var to_explore: [MarkingNode<Place>] = [root]
    var node_list: [MarkingNode<Place>] = [root]
    var place_list: [Place] = []

    for (place, _) in initialMarking
    {
      place_list.append(place)
    }

    while !to_explore.isEmpty
    {
      let current_node: MarkingNode<Place> = to_explore.popLast()!
      let current_marking: Marking<Place, Int> = current_node.marking

      for transition in self.transitions
      {
        if !transition.isFireable(from: current_marking) { continue }
        let next_marking: Marking<Place, Int> = transition.fire(from: current_marking)!

        if node_list.contains(where: { other in
          //greater(next_marking, than: other.marking, places: place_list)
          next_marking > other.marking
        })
        {
          return nil
        }
        else if let next_node = node_list.first(where : { other in
          place_list.allSatisfy { other.marking[$0] == next_marking[$0] }
        })
        {
          current_node.successors[transition] = next_node
        }
        else
        {
          let next_node: MarkingNode<Place> = MarkingNode(marking: next_marking)
          node_list.append(next_node)
          to_explore.append(next_node)
          current_node.successors[transition] = next_node
        }
      }
    }

    return root
  }

  func greater(_ lhs: Marking<Place, Int>, than rhs: Marking<Place, Int>, places: [Place]) -> Bool {
    var hasGreater = false
    for place in places {
      guard lhs[place] >= rhs[place]
        else { return false }
      hasGreater = hasGreater || lhs[place] > rhs[place]
    }
    return hasGreater
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
