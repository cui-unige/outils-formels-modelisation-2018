extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

    let root = MarkingNode(marking: initialMarking) // On définit le noeud racine avec le marquage initial.
		    var created = [root]   // On définit une liste de noeud
		    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //On définit une liste de tuple contenant le noeud courant et une liste de noeuds qui sont les prédecesseurs.
		    while let (node, predecessors) = unprocessed.popLast(){ // Ici on boucle jusqu'a ne plus avoir de predecesseurs afin de vériier quelques propriétés
		      for transition in transitions{
		        guard let nextmarking = transition.fire(from : node.marking)
		        else {continue}
		        if let successor = created.first(where: {element in element.marking == nextmarking})  { // On regarde si le marquage existe deja.
		          node.successors[transition] = successor
		        }
            else if predecessors.contains(where : {element in element.marking < nextmarking}) { // On regarde si il y a divergence
		          return  nil
		        }
            else
            { // Désormais on définit nos successeurs et on les ajoutes à notre liste de noeuds
		           let successor = MarkingNode(marking: nextmarking)
		           created.append(successor)
		           unprocessed.append((successor, predecessors + [node])) // On change de noeud courant et on ajoute notre précédent noeud
		           node.successors[transition] = successor // changement de succeseur.
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
               if let Successor = predecessors.first(where: {element in element.marking < nextmarking})  { // On regarde si il exite un marquage strictement  plus petit parmis les predecesseurs.
                 for place in Place.allCases {
                   if   Successor.marking[place] < nextmarking[place]{
                     nextmarking[place] = .omega // Si c'est le cas on définit le marquage de la place comme étant oméga car non borné.
                     }
                   }
               }

               if node.marking < nextmarking{
                 for place in Place.allCases {
                   if   node.marking[place] < nextmarking[place]{
                     nextmarking[place] = .omega
                   } // ici la même chose mais avec le noeud courant.
                   }
               }

           if let successor = created.first(where: {other in other.marking == nextmarking})  { // On vérifie si le marquage existe déja
             node.successors[transition] = successor
           } // Ici la même démarche que le derniet point de la fonction précèdente: On actualise nos succeseur et le noeud courant.
           else
           {
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
