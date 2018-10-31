extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking)
    var explored = [root] // Tableau des noeuds (places) explorées
    var inProcess: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // Contient des places et leurs prédécesseurs

    while let (node, predecessors) = inProcess.popLast() // On réupère le dernier noeud et ses prédécesseurs
   {
     for transition in self.transitions // On parcourt chacune de ses transitions
     {
       if let nextMarking = transition.fire(from: node.marking) // Pour chaque transition, on vérifie si elle est tirable et si oui, on récupère le nouveau marquage
       {
         // On compare le nouveau marquage avec le premier
         if let successor = explored.first(where : {element in element.marking == nextMarking})
         {
           // Si il est égal, on ajoute les nouvelles transitions à la liste des successeurs
           node.successors[transition] = successor
         }
         else if predecessors.contains(where: {element in nextMarking > element.marking})
         {
           // Si le nouveau marquage est plus grand on retourne nil
           return nil
         }
         else
         {
           // Sinon, on considère notre successeur comme un nouveau graph
           let successor = MarkingNode<Place>(marking: nextMarking)
           // on ajoute notre nouveau graphe au tableau des explorés
           explored.append(successor)
           // on ajoute notre successor aux noeuds "inProcess" pour qu'il soit exploré
           inProcess.append((successor, predecessors + [node]))
           // on l'ajoute à l'index des successors du noeud en cours d'exploration
           node.successors[transition] = successor
         }
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
    // Même principe que plus haut
    var created = [root]
    var unprocessed : [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    while let (node, predecessor) = unprocessed.popLast()
    {
      for transition in self.transitions
      {
        if var nextMarking = transition.fire (from: node.marking)
        {
          if let unbounded = predecessor.first(where: {element in element.marking < nextMarking})
          {
            for place in Place.allCases
            {
              if unbounded.marking[place] < nextMarking[place]
              {
                nextMarking[place] = .omega
              }
            }
          }
          if node.marking < nextMarking
          {
            for place in Place.allCases
            {
              if (node.marking[place] < nextMarking[place])
              {
                nextMarking[place] = .omega
              }
            }
          }
          if let successor = created.first(where: {element in element.marking == nextMarking})
          {
            node.successors[transition] = successor
          }
          else
          {
            let successor = CoverabilityNode(marking: nextMarking)
            created.append(successor)
            unprocessed.append((successor, predecessor + [node]))
            node.successors[transition] = successor
          }
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
