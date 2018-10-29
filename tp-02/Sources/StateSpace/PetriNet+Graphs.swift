extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking) //racine avec marquage initial
    var created:  [MarkingNode<Place>] = [root] //tableau des noeuds
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] //noeuds pas encore explorés

    while let (node, predecessors) = unprocessed.popLast() {//boucle pour voir tous les noeuds depuis la racine
      for transition in transitions { //en parcourant toutes les transitions
        guard let nextMarking = transition.fire(from: node.marking)
          else {continue}
        if let successor = created.first(where : { other in other.marking == nextMarking }) { //vérifie si marquage existe déjà
          node.successors[transition] = successor
        } else if predecessors.contains(where: { other in nextMarking > other.marking }) { //vérifier si ne sera pas borné
          return nil
        } else {
          //actualise le noeud courant
          let successor = MarkingNode(marking: nextMarking)
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
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking))
    var created: [CoverabilityNode<Place>] = [root]
    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    while let (node, predecessors) = unprocessed.popLast() {
      for transition in transitions {
        guard var nextMarking = transition.fire(from: node.marking)
        else {continue}
          if let successor = predecessors.first(where: { other in other.marking < nextMarking}) { //vérifier s'il existe un marquage strictement plus petit parmi les prédecesseurs
            for place in Place.allCases {
              if successor.marking[place] < nextMarking[place] {
                nextMarking[place] = .omega // si effectivement place est est plus petit alors, non borné
              }
            }
          }//ici, même chose mais avec noeud courant
          if node.marking < nextMarking {
            for place in Place.allCases {
              if node.marking[place] < nextMarking[place] {
                nextMarking[place] = .omega
              }
            }
          }
          if let successor = created.first(where: { other in other.marking == nextMarking}) {
            node.successors[transition] = successor
          }
          else {
            let successor = CoverabilityNode(marking: nextMarking)
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
