extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

    let root = MarkingNode(marking: initialMarking)

    var  rootTable = [root]     //definition d'un tableau avec les éléments de root
    //de makeIterator()
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])]
    //var processed : [(MarkingNode<Place>,[MarkingNode<Place>])] = []
    //Pas utilisée dans le programme

    while let (node, predecessor) = unprocessed.popLast(){ //tant qu'il y a des noeuds
      for transition in transitions{ //parcours toutes les transitions
          //use guard
        guard let nextnode = transition.fire(from : node.marking) //si le noeud suivant est égale au tirage de la transition
        else {
        continue //si la condition est vrai on continu la boucle
    }
        if let successor = rootTable.first(where: {element in element.marking == nextnode})  { //la fonction first retourne le premier element qui est egale a nextnode
          node.successors[transition] = successor
      }
      else if predecessor.contains(where : {element in element.marking < nextnode}) { //contain retourne la position de l'élément qui est inférieur a nextnode
            //si ce noeud est borné alors envoyer nul
          return  nil
        }else{
           let successor = MarkingNode(marking: nextnode)
           rootTable.append(successor) //remplir le taleau avec les noeuds
           unprocessed.append((successor, predecessor + [node]))
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
    let root = CoverabilityNode(marking: extend(initialMarking)) //extend permet de rajouter initialMarking a la fin de root
        //même principe qu'au dessus
    var rootTable = [root]
var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])]
while let (node, predecessor) = unprocessed.popLast(){
  for transition in transitions{
    guard var nextnode = transition.fire(from : node.marking)
    else {
    continue
}
        if let Unbounded = predecessor.first(where: {element in element.marking < nextnode})  {
          for place in Place.allCases {
            if   Unbounded.marking[place] < nextnode[place]{
              nextnode[place] = .omega
              }
            }
        }
        if node.marking < nextnode{
          for place in Place.allCases {
            if   node.marking[place] < nextnode[place]{
              nextnode[place] = .omega
              }
            }
        }

    if let successor = rootTable.first(where: {element in element.marking == nextnode})  {
      node.successors[transition] = successor
    }else{
       let successor = CoverabilityNode(marking: nextnode)
       rootTable.append(successor)
       unprocessed.append((successor, predecessor + [node]))
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
