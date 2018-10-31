extension PetriNet {
  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    // repris de la methode dans l'exercice 4
    let root = MarkingNode(marking: initialMarking) // initialisation du marquage initial: root
    var created = [root] // stockage des noeuds crées en tirant les transitions. Ce graphe determine les vecteurs parcourus si c'est un graphe borne.
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // Contient les marquages déjà parcourus et stocke tous les noeuds et leur prédecesseurs.
     while let (node, predecessors) = unprocessed.popLast() { // parcourt les marquages passés en comparant a la dernière valeur de unprocessed
      for transition in transitions {
        guard let nextMarking = transition.fire(from: node.marking) // teste si chaque transition est tirable, nextMarking est obtenu après un tir
        else { 
          continue 
        }
        if let successor = created.first(where : { other in other.marking == nextMarking }) { // retourne le premier élément respectant la condition dans la liste
          node.successors[transition] = successor
        } 
        else if predecessors.contains(where: { other in other.marking < nextMarking }) { // si c'est borné ou pas au niveau de nextMarking
          return nil // le réseau est non borné
        } 
        else 
        {
          let successor = MarkingNode(marking: nextMarking) // creer le nouveau marquage successeur
          created.append(successor) // ajoute à la liste des noeuds
          unprocessed.append((successor, predecessors + [node])) // ajoute successor et les predecesseurs à la liste de noeuds: unprocessed
          node.successors[transition] = successor // ajoute successor à la liste de successeurs du marquage
        }
      }
    }
     return root // return le graphe depuis le marquage initial un graphe borne
  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking)) // marquage initial root
    var created = [root] // stocke les noeuds crees. 
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // liste de marquages déjà parcourus, stocke tous les noeuds et leur prédecesseurs
    while let (node, predecessors) = unprocessed.popLast(){ // parcourt les marquages visités et compare aux éléments de unprocessed (trouve un marquage dans la dernière valeur de la liste unprocessed)
      for transition in transitions{ // transitions tirables
        guard var nextMarking = transition.fire(from : node.marking) // guard teste la tirabilite de chaque transition, nextMarking est obtenu apres un tir
        else {
          continue // continue l'iteration
        } 
            if let predecessor = predecessors.first(where: {other in other.marking < nextMarking})  { // si c'est borné ou pas au niveau de nextMarking
              for place in Place.allCases { // oui -> on itère sur les places
                if predecessor.marking[place] < nextMarking[place] { // si un marquage précédent est < que le successeur (non borné) 
                  nextMarking[place] = .omega // on attribue la valeur omega au marquage de la place (avec plus de jetons donc borne)
                }
              }
            }
            if node.marking < nextMarking { // si nextMarking représente la borne supérieure du marquage
              for place in Place.allCases {
                if node.marking[place] < nextMarking[place] { 
                  nextMarking[place] = .omega // attribue omega au marquage de la place qui contient le plus de jetons (donc borne)
                }
              }
            }
        if let successor = created.first(where: {other in other.marking == nextMarking})  { // vérifie si nextMarking est déjà existant
          node.successors[transition] = successor // ajoute à la liste des successeurs du marquage
        }
        else { // si le marquage successeur < marquages précédents
           let successor = CoverabilityNode(marking: nextMarking) // creer le successeur, avec nextMarking comme successeur du marquage
           created.append(successor) // compare en ajoutant successor aux listes de noeuds created
           unprocessed.append((successor, predecessors + [node])) // ajoute successor et ces predeccesseurs aux noeuds unprocessed
           node.successors[transition] = successor // ajoute successor aux successeur du marquage
        }
      }
    }
    return root // return le graph depuis le marquage initial
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
