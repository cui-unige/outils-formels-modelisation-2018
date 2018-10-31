extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking) // On initialise root comme le noeud du marquage initiale

    var created = [root]                            // On crée la variable created qui contient root
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // On crée la variable unprocessed qui contient root et ses prédecesseurs (c.a.d. aucun)

    while let (node, predecessors) = unprocessed.popLast() { // Tant qu'on peut peut prendre un élément de unprocessed
      for transition in transitions {                        // Pour chaque transition dans transitions
        guard let nextMarking = transition.fire(from: node.marking)  // Si la transition n'est pas tirable
          else { continue }                                          // On passe à la transition suivante
        if let successor = created.first(where : { other in other.marking == nextMarking }) { // Sinon si le nouveau marquage existe déjà
          node.successors[transition] = successor                                             // On le considère simplement comme un successor de notre noeud
        } else if predecessors.contains(where: { other in nextMarking > other.marking }) {    // Sinon si le nouveau marquage est > à nos autres marquages
          return nil                                                                          // Alors notre graphe de marquage est non borné et retourne nil
        } else {                                                                              // Sinon
          let successor = MarkingNode(marking: nextMarking)                                   // On crée le noeud successor à partir du nouveau marquage
          created.append(successor)                                                           // On ajoute successor à created
          unprocessed.append((successor, predecessors + [node]))                              // On ajoute successor et ses prédecesseurs à unprocessed
          node.successors[transition] = successor                                             // On pose successor comme le successeur de node à partir de transition
        }
      }
    }

    return root                                     // On retourne la racine de notre graphe de marquage

  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking)) // On initialise root comme le noeud du marquage initiale

    var created = [root]                                         // On crée la variable created qui contient root
    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])] // On crée la variable unprocessed qui contient root et ses prédecesseurs (c.a.d. aucun)

    while let (node, predecessors) = unprocessed.popLast() {     // Tant qu'on peut peut prendre un élément de unprocessed
      for transition in transitions {                            // Pour chaque transition dans transitions
        guard var nextMarking = transition.fire(from: node.marking)  // Si la transition n'est pas tirable
          else { continue }                                          // On passe à la transition suivante
        if let successor = predecessors.first(where: { other in nextMarking > other.marking }) { // Sinon on regarde dans chaque prédecesseurs si on a un marquage < à nextMarking
          for place in Place.allCases {                              // Si c'est le cas, pour chaque place dans Place.allCases
            if nextMarking[place] > successor.marking[place] {       // Si la valeur à la place "place" de nextMarking est > à la valeur à la place "place" de successor.marking
              nextMarking[place] = .omega                            // Alors on modifie la valeur à la place "place" de nextMarking par omega
            }
          }
        }
        if nextMarking > node.marking {                              // On vérifie la même chose que précédemment avec le node
          for place in Place.allCases {
            if nextMarking[place] > node.marking[place]{
              nextMarking[place] = .omega
            }
          }
        }
        if let successor = created.first(where : { other in other.marking == nextMarking }) { // Sinon si le nouveau marquage existe déjà
          node.successors[transition] = successor                                             // On le considère simplement comme un successor de notre noeud
        }
        else {                                                       // Sinon
          let successor = CoverabilityNode(marking: nextMarking)     // On crée le noeud successor à partir du nouveau marquage
          created.append(successor)                                  // On ajoute successor à created
          unprocessed.append((successor, predecessors + [node]))     // On ajoute successor et ses prédecesseurs à unprocessed
          node.successors[transition] = successor                    // On pose successor comme le successeur de node à partir de transition
        }
      }
    }

    return root                                     // On retourne la racine de notre graphe de couverture

  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
