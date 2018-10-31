extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.

    // Initial marking node (will also be the link to all other markings)
    let root = MarkingNode(marking: initialMarking)

    // All already explored markings (useful to check if already explored or not)
    var explored = [root]

    // Markings "waiting" for being explored
    // Structure of "toExplore" : (next marking, precedent markings)
    var toExplore : [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]


    // Stop when "toExplore" is empty, i.e. when all possible markings have been explored
    while !toExplore.isEmpty {

      // Take the next marking to explore and remove it from "toExplore"
      let (currentNode, predecessors) = toExplore.removeLast()

      // Go through all transitions from the model
      for transition in transitions {

        // If it can't fire this transition, jump to the next one
        // Otherwise, continue with this one and find the next marking (after firing the current transition)
        if let nextMarking = transition.fire(from : currentNode.marking) {

          if let nextNode = explored.first(where: {exploredNode in exploredNode.marking == nextMarking}) {
            // If this marking has already been explored, create a reference to this marking
            currentNode.successors[transition] = nextNode
          } else if predecessors.contains(where : {precedentNode in precedentNode.marking < nextMarking}) {
            // If the model is unbounded, stop
            return  nil
          } else {
            // If this is an unexplored and bounded marking
            // Create the node for the current marking
            let nextNode = MarkingNode(marking: nextMarking)
            // Add it to "explored" and "toExplore"
            explored.append(nextNode)
            toExplore.append((nextNode, predecessors + [currentNode]))
            // Add it to the node's successors (according to the current transition)
            currentNode.successors[transition] = nextNode
          }

        } // if

      } // for

    } // while

    return root
  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.

    // Initial marking node (will also be the link to all other markings)
    let root = CoverabilityNode(marking: extend(initialMarking))

    // All already explored markings (useful to check if already explored or not)
    var explored = [root]

    // Markings "waiting" for being explored
    // Structure of "toExplore" : (next marking, precedent markings)
    var toExplore : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])]

    // Stop when "toExplore" is empty, i.e. when all possible markings have been explored
    while !toExplore.isEmpty {

      // Take the next marking to explore and remove it from "toExplore"
      let (currentNode, predecessors) = toExplore.removeLast()

      // Go through all transitions from the model
      for transition in transitions {

        // If it can't fire this transition, jump to the next one
        // Otherwise, continue with this one and find the next marking (after firing the current transition)
        if var nextMarking = transition.fire(from : currentNode.marking) {

          // If at least one marking from predecessors is smaller than the next one (so at least one place is unbounded)
          if let predecessor = predecessors.first(where: {precedentNode in precedentNode.marking < nextMarking}) {
            // Go through all places from the model
            for place in Place.allCases {
              // Add omega if the place is unbounded, i.e. the previous place has a smaller marking than the next one
              if predecessor.marking[place] < nextMarking[place] {
                nextMarking[place] = .omega
              }
            }
          }

          // If the current node's marking is smaller than the next one (so at least one place is unbounded)
          if currentNode.marking < nextMarking {
            // Go through all places from the model
            for place in Place.allCases {
              // Add omega if the place is unbounded, i.e. the previous place has a smaller marking than the next one
              if currentNode.marking[place] < nextMarking[place] {
                nextMarking[place] = .omega
              }
            }
          }

          if let nextNode = explored.first(where: {exploredNode in exploredNode.marking == nextMarking}) {
            // If this marking has already been explored, create a referece to this marking
            currentNode.successors[transition] = nextNode
          } else {
            // If this is an unexplored and bounded marking
            // Create the node for the current marking
            let nextNode = CoverabilityNode(marking: nextMarking)
            // Add it to "explored" and "toExplore"
            explored.append(nextNode)
            toExplore.append((nextNode, predecessors + [currentNode]))
            // Add it to the node's successors (according to the current transition)
            currentNode.successors[transition] = nextNode
          }

        } // if

      } // for

    } // while

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
