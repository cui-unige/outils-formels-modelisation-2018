extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking) // creer un node avec le marking initial
    var created = [root] // ajoute la racine
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //ajoute la racine qui na pas de predecessors
    // extrait le node et les predecessors et le retire des unprocessed
    while let (node, predecessors) = unprocessed.popLast(){ //tant qu il y a des node a parcourir
      //check pour toutes transitions
      for transition in transitions{
        guard let nextmarking = transition.fire(from : node.marking) //si la transition est tirable
        else {continue}// sinon recomence la boucle en incrementant

        if let successor = created.first(where: {other in other.marking == nextmarking})  { // si on a deja trouver ce marking
          node.successors[transition] = successor // rajoute seulement ce node au node actuelle comme sucessor
        }else if predecessors.contains(where : {other in other.marking < nextmarking}) { // si il existe un marking plus petit
          return  nil
        }else{ // si on a jamais trouver ce marking et qu il na pas de plus petit marking
          let successor = MarkingNode(marking: nextmarking) // cree un nouveau node avec le marking trouvé
          created.append(successor) // ajoute le node au la liste des node cree
          unprocessed.append((successor, predecessors + [node])) // ajoute le node pour le process plus tard
          node.successors[transition] = successor // rajoute ce node au node actuelle comme sucessor
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
    let root = CoverabilityNode(marking: extend(initialMarking)) // creer un node avec le marking initial
    var created = [root] // ajoute la racine
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] //ajoute la racine qui na pas de predecessors
    // extrait le node et les predecessors et le retire des unprocessed
    while let (node, predecessors) = unprocessed.popLast(){ //tant qu il y a des node a parcourir
      //check pour toutes transitions
      for transition in transitions{//si la transition est tirable

        guard var nextmarking = transition.fire(from : node.marking)//si la transition est tirable
        else {continue}// sinon recomence la boucle en incrementant

        if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking})  {  // si on a deja trouver un marking plus petit dans les predecessor
          // pour toutes les places
          for place in Place.allCases {
            if   greatSuccessor.marking[place] < nextmarking[place]{ // si cette place est plus petite
              nextmarking[place] = .omega // place est egal a omega
            }
          }
        }
        if node.marking < nextmarking{ // si le nouveau marking est plus grand que celui actuel
          // pour toutes les places
          for place in Place.allCases {
            if   node.marking[place] < nextmarking[place]{ // si cette place est plus petite
              nextmarking[place] = .omega // place est egal a omega
            }
          }
        }
        if let successor = created.first(where: {other in other.marking == nextmarking})  {// si on a deja trouver ce marking
          node.successors[transition] = successor // rajoute seulement ce node au node actuelle comme sucessor
        }else{
          let successor = CoverabilityNode(marking: nextmarking) // cree un nouveau node avec le marking trouvé
          created.append(successor) // ajoute le node au la liste des node cree
          unprocessed.append((successor, predecessors + [node])) // ajoute le node pour le process plus tard
          node.successors[transition] = successor // rajoute ce node au node actuelle comme sucessor
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
