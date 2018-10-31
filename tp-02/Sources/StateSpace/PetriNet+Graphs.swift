extension PetriNet {


  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking) // Root = marquage initial
    var created = [root] //Vecteur contenant les noeuds différents créés
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] // On crée le vecteur qu'on va utiliser en dessous
    while let (node, predecessors) = unprocessed.popLast(){ // On prend tous les éléments de unprocessed
      for transition in transitions{ // Pour toutes les transitions
        guard let nextmarking = transition.fire(from : node.marking) // nextmarking = le prochain marquage après avoir franchi la prochaine transition
        else {continue}
        if let successor = created.first(where: {other in other.marking == nextmarking})  { //Si on a déjà le prochain marquage
          node.successors[transition] = successor
        }else if predecessors.contains(where : {other in other.marking < nextmarking}) { // Sinon si on trouve un marquage plus petit
          return  nil // On retourne nil car le réseau n'est pas borné
        }else{ // Sinon pour le reste
           let successor = MarkingNode(marking: nextmarking)
           created.append(successor)
           unprocessed.append((successor, predecessors + [node]))
           node.successors[transition] = successor
           // On ajoute le marquage et les successeurs et on crée le noeud
        }
      }
    }
      return root // On retourne le graphe de marquage
  }


  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    let root = CoverabilityNode(marking: extend(initialMarking)) // Root = marquage initial
        var created = [root]
        var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // On crée le vecteur qu'on va utiliser en dessous
        while let (node, predecessors) = unprocessed.popLast(){ // On prend tous les éléments de unprocessed
          for transition in transitions{  // Pour toutes les transitions
            guard var nextmarking = transition.fire(from : node.marking) // nextmarking = le prochain marquage après avoir franchi la prochaine transition
            else {continue}
                if let predecessor = predecessors.first(where: {other in other.marking < nextmarking})  { // On cherche un marquage plus petit
                  for place in Place.allCases { // Pour toutes les places
                    if predecessor.marking[place] < nextmarking[place]{ // Si il y a moins de jetons dans la place que dans la suivante
                      nextmarking[place] = .omega // On remplace par omega pour éviter que le graphe soit infini
                      }
                    }
                }
                if node.marking < nextmarking{  // Si le marquage du noeud est plus petit que le prochain marquage
                  for place in Place.allCases { // Pour toutes les places
                    if node.marking[place] < nextmarking[place]{ // Si il y a moins de jetons dans la place que dans la suivante
                      nextmarking[place] = .omega // On remplace par omega
                      }
                    }
                }
            if let successor = created.first(where: {other in other.marking == nextmarking})  {
              node.successors[transition] = successor
            }
            else{ // Sinon pour le reste
               let successor = CoverabilityNode(marking: nextmarking)
               created.append(successor)
               unprocessed.append((successor, predecessors + [node]))
               node.successors[transition] = successor
              // On ajoute le marquage et les successeurs et on crée le noeud
            }
          }
        }
    return root // On retourne le graphe de couverture
  }


  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }
}
