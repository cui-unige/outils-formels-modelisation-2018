extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

    let root = MarkingNode(marking: initialMarking) // initial marking M0

    var created = [root] // list containing root

    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // list which will contains the elements to process

    while let (node, predecessors) = unprocessed.popLast() { // loop until the last element of unprocessed is nil
      for t in transitions { // loop on every transitions
        guard let nextMarking = t.fire(from: node.marking) // skip the iteration if the firing from the marking is nil (not fireable)
          else { continue } // go to next transition
        if let successor = created.first(where : { other in other.marking == nextMarking }) { // if created.first(where...) is not nil, then node.successor[t] is the successor
          node.successors[t] = successor
        } else if predecessors.contains(where: { other in nextMarking > other.marking }) { // if any predecessors satisfies the given predicate, which is that the next marking is bigger than the curent one
          return nil // the model is unbounded
        } else {
          let successor = MarkingNode<Place>(marking: nextMarking) // successor is the marking node
          created.append(successor) // add to created the successor
          unprocessed.append((successor, predecessors + [node])) // add to unprocessed the successor and the predecessors + [node]
          node.successors[t] = successor
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
    let root = CoverabilityNode(marking: extend(initialMarking))

    var created = [root] // list with root

    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])] // list with the elements to process

  while let (node, predecessors) = unprocessed.popLast() { // loop until the last element of unprocessed is nil
    for t in transitions { // loop on every transitions
      guard var nextMarking = t.fire(from: node.marking) // skip the iteration if the firing from the marking is nil (not fireable)
        else { continue }
      if let predecessor = predecessors.first(where: { other in other.marking < nextMarking }) {
        for place in Place.allCases { // loop in every place
          if predecessor.marking[place] < nextMarking[place] { // if the next marking is bigger than the last, it's unbounded
            nextMarking[place] = .omega // we put the symbol omega in the place thus unbounded
          }
        }
      }
      if node.marking < nextMarking { // check the current marking
        for place in Place.allCases { // loop in every place
          if node.marking[place] < nextMarking[place] { // if the next marking is bigger than the last, it's unbounded
            nextMarking[place] = .omega // we put the symbol omega in the place thus unbounded
          }
        }
      }
      if let successor = created.first(where: { other in other.marking == nextMarking }) {
        node.successors[t] = successor
      } else {
        let successor = CoverabilityNode<Place>(marking: nextMarking)
        created.append(successor)
        unprocessed.append((successor, predecessors + [node]))
        node.successors[t] = successor
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
