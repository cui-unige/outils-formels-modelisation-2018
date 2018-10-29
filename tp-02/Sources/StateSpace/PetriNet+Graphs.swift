extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
    public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
        let root = MarkingNode(marking: initialMarking)
        var created = [root]
        var currentgraph : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])]
        while let (node, predecessors) = currentgraph.popLast(){
            for t in transitions{
                if let nextmarking = t.fire(from : node.marking){ //pour chaque transition nextmarking correspond au tirage de cette transition
                    if predecessors.contains(where : {other in other.marking < nextmarking}) {
                        return  nil // envoie nil si c'est pas bornée
                    }else if let successor = created.first(where: {other in other.marking == nextmarking})  {
                        node.successors[t] = successor
                    }else{ //les autres marquages
                        let successor = MarkingNode(marking: nextmarking)
                        created.append(successor)
                        currentgraph.append((successor, predecessors + [node]))
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
        var created = [root]
        var notvisited : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // pas encore visiter
        while let (node, predecessors) = notvisited.popLast(){ // on regarde les transitions tirables d'un noeud à visiter
            for transition in transitions{
                guard var nextmarking = transition.fire(from : node.marking)
                    else {continue}
                
                // on regarde si la place est bornée
                if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking})  { // on regarde si il y a un marquage plus petit, dans ses prédecesseurs
                    for place in Place.allCases {// on regarde si le plus petit est non bornée
                        if   greatSuccessor.marking[place] < nextmarking[place]{
                            nextmarking[place] = .omega
                        }
                    }
                }
                // on regarde avec le noeud
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
                    let successor = CoverabilityNode(marking: nextmarking) //successeur
                    created.append(successor) // complete la liste des existants
                    notvisited.append((successor, predecessors + [node])) // on ajoute les noeuds à visiter
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
