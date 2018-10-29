extension PetriNet {
  // README:
  // I implemented 'computeMarkingGraph' by myself and worked with
  // Mark Tropin for 'computeCoverabilityGraph'

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
    var place_list: [Place] = []
    // We need a list of all places for later
    for (place, _) in initialMarking
    {
      place_list.append(place)
    }

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
    // The root is, by definition, the initial marking
    let root = CoverabilityNode(marking: extend(initialMarking))

    // We create arrays of vertices of the graph, processed and unprocessed
    var vertices: [CoverabilityNode<Place>] = [root]
    var toBeProcessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])] // root doesn't have predecessors
    while let (currentVertex, preds) = toBeProcessed.popLast() // while we still have smth to process
    {
      for transition in transitions
      {
        if var markingAfterFire = transition.fire(from: currentVertex.marking) // if this transition is fireable from this marking
        {
          if let pred = preds.first(where: {markingAfterFire > $0.marking})
          {
            for place in Place.allCases
            {
              if (markingAfterFire[place] > pred.marking[place]) // if this marking is contained in another marking, and that one is smaller, then the model is unbounded, and we put omegas
              {
                markingAfterFire[place] = .omega
              }
            }
          }

          if (markingAfterFire > currentVertex.marking)
          {
            for place in Place.allCases
            {
              if (markingAfterFire[place] > currentVertex.marking[place]) // same thing here, but with the current vertex
              {
                markingAfterFire[place] = .omega
              }
            }
          }

          if let succ = vertices.first(where: {$0.marking == markingAfterFire})
          {
            currentVertex.successors[transition] = succ // same as for marking graph
          }

          else // again, same as for marking graph
          {
            let newVertex = CoverabilityNode(marking: markingAfterFire)
            toBeProcessed.append((newVertex, preds + [currentVertex]))
            vertices.append(newVertex)
            currentVertex.successors[transition] = newVertex
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
