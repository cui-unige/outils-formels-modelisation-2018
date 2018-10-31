extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
		let root = MarkingNode(marking: initialMarking) // la racine = marquage initial, avec marquage et successeurs
		    var created = [root]
		    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //en attente , le noeud n'a pas de prédécesseur
		    while let (node, predecessors) = unprocessed.popLast(){ // tant qu'on peut récupérer dans unprocessed
		      for transition in transitions{ //on boucle sur les transitions
		        guard let nextmarking = transition.fire(from : node.marking)
		        else {continue}
		        if let successor = created.first(where: {other in other.marking == nextmarking})  { // voir si marquage existe deja -> on ne s'occupera pas de voir le comportement par la suite, déjà fait
		          node.successors[transition] = successor // vérifie qu'on est au stade de la racine , on passe au successeur
		        }else if predecessors.contains(where : {other in other.marking < nextmarking}) { // vérifier si on ne va pas être borné
		          return  nil
		        }else{ // on ajoute le nouveau marquage/noeud en tant que successeur
		           let successor = MarkingNode(marking: nextmarking) // créer le noeud
		           created.append(successor) // on ajoute à la liste des noeuds créés (besoin pour ckeck n'existe pas déjà)
		           unprocessed.append((successor, predecessors + [node])) // il faudra voir la suite -> met dans unprocessed (noeud, prédecesseur)
		           node.successors[transition] = successor // on l'ajoute en tant que successeur du noeud avec la transition
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
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // garder ceux à visiter
    while let (node, predecessors) = unprocessed.popLast(){ // on prend un noeud à visiter
      for transition in transitions{ // s'occupe des transitions tirables
        guard var nextmarking = transition.fire(from : node.marking)
        else {continue}
					// pt1 : on va regarder si la place est bornée
            if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking})  { // on regarde si dans ses prédecesseurs il y a un marquage plus petit
              for place in Place.allCases {// (si oui) on itère sur les places pour voir si plus petite -> non borné
                if   greatSuccessor.marking[place] < nextmarking[place]{
                  nextmarking[place] = .omega // si place plus petit -> non borné !
                  }
                }
            }
						// pt2 : la même q'au dessus mais avec le noeud (car pas compris dans sucesseurs)
            if node.marking < nextmarking{
              for place in Place.allCases {
                if   node.marking[place] < nextmarking[place]{
                  nextmarking[place] = .omega
                  }
                }
            }
						// pt3 : savoir si noeud reste à visiter
        if let successor = created.first(where: {other in other.marking == nextmarking})  { // vérifie si marquage déjà existant : on sort le premier  maraquge égal dans created
          node.successors[transition] = successor // pas besoin d'en faire un CoverabilityNode vu que passé à la ligne au-dessus
        }else{
           let successor = CoverabilityNode(marking: nextmarking) // creer le successeur
           created.append(successor) // ajoute aux existants (permettre comparaison)
           unprocessed.append((successor, predecessors + [node])) // ajoute aux noeuds à visiter
           node.successors[transition] = successor // l'entre en tant que successeur du noeud
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
