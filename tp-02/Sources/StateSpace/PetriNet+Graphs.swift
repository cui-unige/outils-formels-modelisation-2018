extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // The root is, by definition, the initial marking
    let root = MarkingNode(marking: initialMarking)
    // We create arrays of vertices of the graph, processed and unprocessed
    var vertices: [MarkingNode<Place>] = [root]
    var toBeProcessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // root doesn't have predecessors

    while let (currentVertex, pred) = toBeProcessed.popLast() // while we still have smth to process
    {
      for transition in transitions
      {
        if let markingAfterFire = transition.fire(from: currentVertex.marking) // if this transition is fireable from this marking
        {
          if let succ = vertices.first(where: {$0.marking == markingAfterFire}) // if this vertex was already processed
          {
            currentVertex.successors[transition] = succ
          }
          else if (pred.contains (where: {markingAfterFire > $0.marking}))
          {
            return nil // if this marking is contained in another marking, and that one is smaller, then the model is unbounded
          }
          else // this is a new vertex, because it wasn't processed and it doesn't cause problems (model is bounded)
          {
            let newVertex = MarkingNode(marking: markingAfterFire)
            toBeProcessed.append((newVertex, pred + [currentVertex]))
            vertices.append(newVertex)
            currentVertex.successors[transition] = newVertex
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
