extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking) // the root = initial marking
    var created = [root]
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] // unprocessed markings
    while let (node, predecessors) = unprocessed.popLast() { // while there are still unprocessed markings
        for transition in transitions { // loop transitions
            guard let nextmarking = transition.fire(from : node.marking) else {continue}
            if let successor = created.first(where: {other in other.marking == nextmarking})  { // if the marking already exists, then no need to look at it
                node.successors[transition] = successor
            } else if predecessors.contains(where : {other in other.marking < nextmarking}) { // check if we have borned
                return  nil
            } else { // add new markings
                let successor = MarkingNode(marking: nextmarking) // create node
                created.append(successor) // add created node to list which is used to see if alredy created
                unprocessed.append((successor, predecessors + [node])) // add to unprocessed
                node.successors[transition] = successor // add successor
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
    var created = [root]
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])]
    while let (node, predecessors) = unprocessed.popLast(){ // loop unprocessed
        for transition in transitions{ // loop transitions
            guard var nextmarking = transition.fire(from : node.marking)
                else {continue}
            // see if borned
            if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking})  { // see if smaller marking in predecessors
                for place in Place.allCases {// loop the places to find smaller -> non borned
                    if   greatSuccessor.marking[place] < nextmarking[place]{
                        nextmarking[place] = .omega // smaller place -> non borned
                    }
                }
            }
            // same as above but with the node (as not in successors)
            if node.marking < nextmarking{
                for place in Place.allCases {
                    if   node.marking[place] < nextmarking[place]{
                        nextmarking[place] = .omega
                    }
                }
            }
            // see if nodes left to visit
            if let successor = created.first(where: {other in other.marking == nextmarking})  { // check if the marking exists that we give the first equal marking
                node.successors[transition] = successor // successor already exists
            } else {
                let successor = CoverabilityNode(marking: nextmarking) // create sucessor
                created.append(successor) // add to created
                unprocessed.append((successor, predecessors + [node])) // add to unprocessed
                node.successors[transition] = successor // add to node
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
