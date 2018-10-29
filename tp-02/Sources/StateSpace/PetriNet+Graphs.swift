extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>?
  {
    let root = MarkingNode(marking: initialMarking) // la racine = marquage initial, avec marquage et successeurs
		    var created = [root]
		    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //Ce sont les noeuds qui n'ont pas encore été traité
		    while let (node, predecessors) = unprocessed.popLast() // On va procéder sur tous les noeuds, c'est à dire tant qu'il y en a dans unprocessed
        {
		      for transition in transitions//Pour chaque noeuds on regarde les transitions
          {
		        guard let nextmarking = transition.fire(from : node.marking) //S'il existe on défnit le marquage suivant
		        else {continue}
		        if let successor = created.first(where: {other in other.marking == nextmarking}) // Si le marquage existe déjà on ne le traite pas
            {
		          node.successors[transition] = successor // On définit un nouveau successeur
		        }
            else if predecessors.contains(where : {other in other.marking < nextmarking}) // On vérifie qu'il n'est pas borné
            {
		          return  nil
		        }
            else// on ajoute le nouveau marquage/noeud en tant que successeur
            {
		           let successor = MarkingNode(marking: nextmarking) // On a nouveau noneud
		           created.append(successor) // on ajoute à la liste des noeuds créés
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

  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)-> CoverabilityNode<Place>?
  {
    let root = CoverabilityNode(marking: extend(initialMarking))
    var created = [root]
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // garder ceux à visiter
    while let (node, predecessors) = unprocessed.popLast() // Pour chaque noeud
    {
      for transition in transitions // On vérifie chaque transitions
      {
        guard var nextmarking = transition.fire(from : node.marking)
        else {continue}
					// On regarde si notre place est bornée ou pas:...
            if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking}) //... On commence par regarder si dans ces prédecesseurs il y a un marquage plus petit
            {
              for place in Place.allCases // Si c'est le cas on regarde toutes places d'avant pour pour voir si elles sont incluses
              {
                if  greatSuccessor.marking[place] < nextmarking[place]
                {
                  nextmarking[place] = .omega // Si c'est la place la plus petite alors ce n'est pas borné
                  }
                }
            }
						// On vérifie la même chose qu'au dessus mais avec noeud ca il n'est pas compris dans les successeurs
            if node.marking < nextmarking
            {
              for place in Place.allCases
               {
                  if node.marking[place] < nextmarking[place]
                  {
                  nextmarking[place] = .omega
                  }
                }
            }
				// On vérifie qu'il un noeud à visiter
        if let successor = created.first(where: {other in other.marking == nextmarking})// ON regarde s'il existe un marquage déjà existant
        {
          node.successors[transition] = successor // si c'est le cas alors  pas besoin d'en faire un CoverabilityNode
        }
        else
        {
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
