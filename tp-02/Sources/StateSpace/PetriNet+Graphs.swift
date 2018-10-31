extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
          let root = MarkingNode(marking: initialMarking)
          var a_creer = [root]
          var graphe_en_cour : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])]
          while let (node, predecessors) = graphe_en_cour.popLast(){
              for t in transitions{
                  if let prochaine_marquage = t.fire(from : node.marking){
                    if predecessors.contains(where : {other in other.marking < prochaine_marquage}) {
                     return  nil
                    }else if let successor = a_creer.first(where: {other in other.marking == prochaine_marquage})  {
                      node.successors[t] = successor
                    }else{
                       let successor = MarkingNode(marking: prochaine_marquage)
                       a_creer.append(successor)
                       graphe_en_cour.append((successor, predecessors + [node]))
                       node.successors[t] = successor
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
