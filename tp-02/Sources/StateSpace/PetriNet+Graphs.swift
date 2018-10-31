extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

    let root = MarkingNode(marking: initialMarking)
    var newone = [root] // newone va stocker tous les noeuds seront crées après chaque transition
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // On stocke ici les marquages qui n'ont pas encore été traités
    //print(type (of:unprocessed))
    while let(node,predecessors) = unprocessed.popLast() // Tant que cette liste n'est pas vide, on travaille chaque élément en partant de la dernière
     {
       for transition in transitions {
         guard let newmark = transition.fire(from: node.marking) // guard assigne une valeur à la varibale si elle est possible
         // Dans ce cas si la transition est tirable
         else {continue} // sinon on continue quand même sans initialiser newmark
       if let succesor = newone.first(where : {rest in rest.marking == newmark}) { // on prend le premier element qui satisfait cette condition à l'aide de .first
         node.successors[transition] = succesor  // On ajoute ceci à la liste des succeseurs
       } else if predecessors.contains(where : {rest in newmark > rest.marking}) {
         return nil // cas où le réseau est non borné
       } else { // cas où le réseau est borné

         let succesor = MarkingNode(marking : newmark)  // on initialise avec le nouveau marquage
         newone.append(succesor)
         unprocessed.append((succesor,predecessors + [node])) // on ajoute succesor ainsi que ses predecessors pour les traiter ensuite
         node.successors[transition]=succesor // on ajoute enfin notre succesor à la liste de successeurs du nouveau marquage
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
    var newone = [root]
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // garder ceux à visiter


    while let (node, predecessors) = unprocessed.popLast() { // tant que c'est pas vide on traite chaque élément en partant du dernier
      for transition in transitions {

        guard var nextmarking = transition.fire(from : node.marking)
        else {continue}
           // On regarde si notre place est borné ou non
          if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking}) { // On commence par regarder si dans ces prédecesseurs
            // possède un marquage plus petit

              for place in Place.allCases {//si oui ,on regarde toutes places d'avant pour voir si elles sont incluses

                  if  greatSuccessor.marking[place] < nextmarking[place] {

                      nextmarking[place] = .omega // cas  où la place n'est pas borné
                    }
                  }
                }
        // On teste la même chose pour nodes car il n'est pas compris dans les successors
        if node.marking < nextmarking  {
          for place in Place.allCases
           {
              if node.marking[place] < nextmarking[place]
              {
              nextmarking[place] = .omega
              }
            }
        }
        if let successor = newone.first(where: {other in other.marking == nextmarking}) {// ON regarde s'il existe un marquage déjà existant

              node.successors[transition] = successor // si c'est le cas on associe le succesor à la transition qui lui correspond
            } else { // cas où le réseau est borné , on fait la même chose que le code précedent

                let successor = CoverabilityNode(marking: nextmarking)
                newone.append(successor)
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
