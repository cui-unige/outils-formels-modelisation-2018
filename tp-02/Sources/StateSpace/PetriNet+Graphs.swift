extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // // TODO: Replace or modify this code with your own implementation.
    // let root = MarkingNode(marking: initialMarking)
    // return root

    // inspiration de Graph.swift dans ex-04 :
    // Voir aussi l'algorthme dans la theorie (RdPVerifProp.pdf)

    // initialisation des racines pour marquage initial et
    // des variables created et unprocessed pour travailelr sur les racines :
    let root = MarkingNode(marking: initialMarking)
    var created = [root]
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]

    // Tant qu'il y a des elements "non-travailles" (unprocessed)
    // pour toutes transitions verifier si elle est tirable et mettre dans nextMarking
    while let (node, predecessors) = unprocessed.popLast() {
      for transition in transitions {
        guard let nextMarking = transition.fire(from: node.marking)
        else { continue }
        // si nouveau marquage deja existant, mettre comme successor dans noeud
        if let successor = created.first(where : { other in other.marking == nextMarking }) {
          node.successors[transition] = successor
        }
        // sinon  si nouveau marquage plus grand que les autres, marquage non-borne donc nil
        else if predecessors.contains(where: { other in other.marking < nextMarking }) {
          return nil
        }
        // sinon on creer le noeud suivant avec le nouveau marquage
        else {
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

    // inspiration de Graph.swift dans ex-04 :
    // Voir aussi l'algorthme dans la theorie (RdPVerifProp.pdf)

    // initialisation des racines pour marquage initial et
    // des variables created et unprocessed pour travailelr sur les racines :
    let root = CoverabilityNode(marking: extend(initialMarking))
    var created = [root]
    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    // Tant qu'il y a des elements "non-travailles" (unprocessed)
    // pour toutes transitions verifier si elle est tirable et mettre dans nextMarking
    while let (node, predecessors) = unprocessed.popLast() {
      for transition in transitions {
        guard var nextMarking = transition.fire(from: node.marking) //var et non let sinon marche pas
        else { continue }
        // si un nouveau marquage plus grand que les autres on regarde chaque place de predecessor
        // et si la valeur de place du marquage successor est plus petit que valeur du nouveau
        // alors on modifie la place avec omega
        if let successor = predecessors.first(where: { other in other.marking < nextMarking }) {
          for  place in Place.allCases {
            if successor.marking[place] < nextMarking[place] {
              nextMarking[place] = .omega
            }
          }
        }
        // ici on verifie pour le noeud comme avant
        if node.marking < nextMarking {
          for place in Place.allCases {
            if node.marking[place] < nextMarking[place] {
              nextMarking[place] = .omega
            }
          }
        }
        // si nouveau marquage deja existant, mettre comme successor dans noeud
        if let successor = created.first (where : { other in other.marking == nextMarking }) {
          node.successors[transition] = successor
        }
        // sinon on creer le noeud suivant avec le nouveau marquage
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
