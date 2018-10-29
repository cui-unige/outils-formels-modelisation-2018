extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking)
    var created_nodes_list = [root] //List that will contain the created nodes.
    var unprocessed_nodes_list : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] // Remaining nodes.

    while let (node, predecessors) = unprocessed_nodes_list.popLast(){ // If the list is not empty, we take the last one.

      for t in transitions{ //We are going through the transitions.
        guard let nextmarking = t.fire(from : node.marking) //We fire the transition.
        else {continue}//If it is nil we go to the next one.

        if let successor = created_nodes_list.first(where: {other in other.marking == nextmarking}) { //If the next marking has been visited and already exists, take the first item that checks the condition.
          node.successors[t] = successor//The successor of the node after the transition.
        }else if predecessors.contains(where : {other in other.marking < nextmarking}) {
          //The network is not bounded if there is a marking with less than nextmarking.
        }
        else{ //If the marking is not yet explored.
          let successor = MarkingNode(marking: nextmarking) //Create a new node that will be followed by its successors.
          created_nodes_list.append(successor) //Add the successor to the list of nodes.
          unprocessed_nodes_list.append((successor, predecessors + [node])) // It is added to the remaining nodes, the current node becomes the predecessor, and the successor the new current node.
          node.successors[t] = successor //The new nodes is the successor of the current node.
        }
      }
    }
    return root //We return the marking graph.
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
    var created_nodes_list = [root]
    var unprocessed_nodes_list : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])]
    while let (node, predecessors) = unprocessed_nodes_list.popLast(){ //As long as there are still remaining nodes, we take the last element.
      for t in transitions{ //We go through the transition to look at the marking.
        guard var nextmarking = t.fire(from : node.marking) //The next marking after the fire of the transition.
        else {continue}

        if let predecessor = predecessors.first(where: {other in other.marking < nextmarking}) {
          for place in Place.allCases { //We go trought all places.
            if predecessor.marking[place] < nextmarking[place]{ //If the number of token in the predecessor's place is lower than the next mark.
              nextmarking[place] = .omega //There is an omega in this place because unbounded.
            }
          }
        }
        if node.marking < nextmarking{ //If the mark of the current node is smaller than the next one.
        for place in Place.allCases {
          if node.marking[place] < nextmarking[place]{
          nextmarking[place] = .omega
        }
      }
    }
    if let successor = created_nodes_list.first(where: {other in other.marking == nextmarking}) {
      node.successors[t] = successor
    }
    else{
    let successor = CoverabilityNode(marking: nextmarking)
    craeted_nodes_list.append(successor)
    unprocessed_nodes_list.append((successor, predecessors + [node]))
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
