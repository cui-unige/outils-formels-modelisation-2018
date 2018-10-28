extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking) // initialisation du marquage initial
    var created = [root] //création de la liste de vecteur parcourus
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root, [])]
    while let (node, predecessors) = unprocessed.popLast() { // Prend le dernier élément de la liste et le supprime
        for transition in transitions{ // itération dans les transition
            guard let nextmarking = transition.fire(from: node.marking)// Controle permettant de savoir si la transition est tirable sinon la boucle s'incrémente
                else{continue} // si la transition est tirable on continue
            // Si le marquage est égal déjà calculé -> on connaît alors la séquence il n'est plus nécessaire de continuer -> sinon on itère jusqu'à infini
            if let successor = created.first(where: {other in other.marking == nextmarking}){
                node.successors[transition] = successor
            }
            // Si le marquage est plus grand qu'un marquage déjà calculer nous pouvons déduire d'après le cours que le réseau est non-borné donc on retourne null
            else if predecessors.contains(where : {other in other.marking < nextmarking}){
                return nil
            }
            // Si le marquage est plus petit que les marquages déjà calculer, on ajoute le marquage suivant à la lite created et on l'ajoute aussi à un processed avec avec les marquage précédents comprenant le marquage actuael
            else {
                let successor = MarkingNode(marking: nextmarking)
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
    var created = [root] //création de la liste de vecteur parcourus
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root, [])]
    while let (node, predecessors) = unprocessed.popLast() {
        for transition in transitions{
            guard var nextmarking = transition.fire(from: node.marking)// Controle permettant de savoir si la transition est tirable sinon la boucle s'incrémente
                else{continue} // si la transition est tirable on continue

        
            if  let greatSuccessor = predecessors.first(where : {other in other.marking < nextmarking}){ // récupère le premier marquage déjà tiré plus petit que le marquage après le tire
                for place in Place.allCases{ // Itéreation dans la liste de place
                    if greatSuccessor.marking[place] < nextmarking[place]{ //Vérification de quel place a un marquage non-borné
                        nextmarking[place] = .omega // Ajout de Omega au marquage de la place et on n'ajoute pas le marquage suivant a unprocessed car la branche est finie
                    }
                }
                
            }
            
            if node.marking < nextmarking{ // Vérification si le marquage actuel est plus petit que le marquage suivant dans ce cas omega à la au marquage de la place concernée
                for place in Place.allCases {
                    if   node.marking[place] < nextmarking[place]{
                        nextmarking[place] = .omega
                    }
                }
            }
            
            //Si le marquage est égal la séquence a alors déjà été découverte on insère juste successor et on n'ajoute pas à la liste unprocessed pour ne pas itéré à l'infini
            if let successor = created.first(where: {other in other.marking == nextmarking}){
                node.successors[transition] = successor
            }
                
                // Si le marquage est plus petit que les marquages déjà calculer, on ajoute le marquage suivant à la lite created et on l'ajoute aussi à unprocessed avec avec les marquage précédents comprenant le marquage actuael pour continuer la branche
            else {
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
