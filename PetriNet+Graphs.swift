extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
      let root = MarkingNode(marking: initialMarking) //root contient le marquage initial
      var created = [root] //vecteur avec les différents marquages
      var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //vecteur de noeud et predecesseur (nul pour le moment)
      while let (node, predecessors) = unprocessed.popLast(){ //prendre le dernier element
          for transition in transitions{ //boucle sur les transitions
              guard let nextmarking = transition.fire(from : node.marking) //nextmarking vaut le tirage de la transition
              else {continue}
              if let successor = created.first(where: {other in other.marking == nextmarking})  { //first renvoie le premier element qui respect la condition
                  node.successors[transition] = successor
              }else if predecessors.contains(where : {other in other.marking < nextmarking}) { //s'il y a un marquage inferieur à nextmarking, alors c'est pas borné et renvoyer nul
                  return  nil
              }else{ //pour tout les autres marquages
                  let successor = MarkingNode(marking: nextmarking) //creer les noeuds
                  created.append(successor)
                  unprocessed.append((successor, predecessors + [node]))
                  node.successors[transition] = successor
              }
          }
      }
  return root //renvoie le marquage
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
              if let predecessors = predecessors.first(where: {other in other.marking < nextmarking})  {
                  for place in Place.allCases { //pour toutes les places
                      if   predecessors.marking[place] < nextmarking[place]{ //si le marquage de predecesseur est inferieur a celui de nextmarking
                          nextmarking[place] = .omega //alors définir cette place comme omega
                      }
                  }
              }
              //recommencer avec tous les predecesseur qui n'ont pas ete fait
              if node.marking < nextmarking{
                  for place in Place.allCases {
                      if   node.marking[place] < nextmarking[place]{
                          nextmarking[place] = .omega
                      }
                  }
              }
              if let successor = created.first(where: {other in other.marking == nextmarking})  { //prendre le premier marquage qui est egal a nextmarking
                  node.successors[transition] = successor
              }else{
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
