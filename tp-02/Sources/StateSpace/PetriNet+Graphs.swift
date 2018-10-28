extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

      let root = MarkingNode(marking: initialMarking)
      var created = [root]
      var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])]
      while let (node, predecessors) = unprocessed.popLast(){
          for transition in transitions{
              guard let nextmarking = transition.fire(from : node.marking)
              else {continue}
              if let successor = created.first(where: {other in other.marking == nextmarking})  {
                  node.successors[transition] = successor
              }else if predecessors.contains(where : {other in other.marking < nextmarking}) {
                  return  nil
              }else{
                  let successor = MarkingNode(marking: nextmarking)
                  created.append(successor)
                  unprocessed.append((successor, predecessors + [node]))
                  node.successors[transition] = successor
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
      while let (node, predecessors) = unprocessed.popLast(){
          for transition in transitions{
              guard var nextmarking = transition.fire(from : node.marking)
              else {continue}
              if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking})  {
                  for place in Place.allCases {
                      if   greatSuccessor.marking[place] < nextmarking[place]{
                          nextmarking[place] = .omega
                      }
                  }
              }
              if node.marking < nextmarking{
                  for place in Place.allCases {
                      if   node.marking[place] < nextmarking[place]{
                          nextmarking[place] = .omega
                      }
                  }
              }
              if let successor = created.first(where: {other in other.marking == nextmarking})  {
                  node.successors[transition] = successor
              }else{
                  let successor = CoverabilityNode(marking: nextmarking)
                  created.append(successor)
                  unprocessed.append((successor, predecessors + [node]))
                  node.successors[transition] = successor
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
