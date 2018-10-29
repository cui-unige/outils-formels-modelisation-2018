extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.

       let root = MarkingNode(marking: initialMarking) //declartion de root avec le markage intial
       var created = [root] //variable danslaquelle on mit les noeuds
       var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //(variable unprocessed avec les élement que on que on doit parcourir
       while let (node, predecessors) = unprocessed.popLast(){ //on choisi le dernier élément tant qu il existe encore des element à regarder
         for transition in transitions{ //on parcoure toutes les transition pour voir les marquages qui sont franchissable
           guard let nextmarking = transition.fire(from : node.marking) //on prends le marquage successor apres le tirage de transition
           else {continue} //sinon on prends le prochain
           if let successor = created.first(where: {other in other.marking == nextmarking})  { //sinon il prends le premeier qu il n'est pas était traiter
              node.successors[transition] = successor//on gard le successeur
           }else if predecessors.contains(where : {other in other.marking < nextmarking}) { //Si sur le chemin il y a un marquage plus petit que nextmarking, c'est pas borné
             return  nil
           }else{ //(sinon on condiere que c'est un nouveau node
             //on va garder ces noueds et ses markages
              let successor = MarkingNode(marking: nextmarking)
              created.append(successor)
              unprocessed.append((successor, predecessors + [node]))
              node.successors[transition] = successor
           }
         }
       }
         return root //on renvoie les racines
  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.

     let root = CoverabilityNode(marking: extend(initialMarking)) //declartion de root avec le markage intial

     var created = [root]  //variable danslaquelle on mit les noeuds
         var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] //variable unprocessed avec les élement que on que on doit parcourir
         while let (node, predecessors) = unprocessed.popLast(){ //on choisi le dernier élément tant qu il existe encore des element à regarder
           for transition in transitions{  //on parcoure toutes les transition
             guard var nextmarking = transition.fire(from : node.marking) //on garde le marcage après le tirage de la transition
             else {continue}
                 if let predecessor = predecessors.first(where: {other in other.marking < nextmarking})  { //Si on trouve un ancien marquage plus petit, on prends le premier comme ceci et on le met dans predecessor
                   for place in Place.allCases { //On regarde toutes les places
                     if predecessor.marking[place] < nextmarking[place]{ //Si il y a moins de jetons dans la place de predecessor que dans celle de nextmarking
                       nextmarking[place] = .omega //On met un oméga dans la place de nextmarking à la place de ce qu'il y avait avant, ce n'est pas borné dans cette place
                       }
                     }
                 }
                 if node.marking < nextmarking{  //Si le marquage du noeud qu'on regarde est plus petit que le prochain marquage qui va suivre "on le test car il n'a pas été testé dans les prédecesseurs"
                   for place in Place.allCases { //parcourir de toutes les places
                     if nextmarking[place] > node.marking[place]{ //on test s'il y a plus de jetons dans la place du prochaine markage que dans le courant
                       nextmarking[place] = .omega //On met oméga dans la place
                       }
                     }
                 }
             if let successor = created.first(where: {other in other.marking == nextmarking})  { //Si on a déjà vu le prochain marquage, s'il existe déjà, on prend le premier tel marquage
               node.successors[transition] = successor //le successeur dans le graph du noeud après la transition est le noeud créé, on ne le touche plus par la suite, on l'a déjà visité
             }
             else{ //(sinon on condiere que c'est un nouveau node
               //on va garder ces noueds et ses markages
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
