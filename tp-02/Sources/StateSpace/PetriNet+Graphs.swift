extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    //let root = MarkingNode(marking: initialMarking)
    let root = MarkingNode(marking: initialMarking)
    //Extended int is for Coverability Graph, to be able to represent the Omega

    //Marking is defined in MarkingNode
      //a Marking is a dictionary of the current # of Tokens in each Place in the Petri Net
      //

    //Transition is defined in PetriNet
      //pre and post conditions are held in Set<Arc<Place>>,
      //where Arc stores the value of each arc to each position

    // MarkingNode is defined in GraphNodes
      //is a Node in a Graph, where each branch represents a transition firing

    var rootGraph = [root]
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // les visités

    while let (node, predecessors) = unprocessed.popLast() // on sort le visité pour l'analyser
    {
      for transition in self.transitions // on regarde les transitions du visité
      {
        if let nextMarking = transition.fire(from: node.marking) // on regarde si un maquage depuis le visité existe
        {
          // on prend le premier de liste créé on le compare entre le marquage initiale et le nouveau
          if let successor = rootGraph.first(where : { other in other.marking == nextMarking })
          {
            // si oui on a trouver un successeur  sinon ce n'est pas un successeur,
            // si oui on l'ajoute à la liste des successeurs
            node.successors[transition] = successor
          }

          // si le nouveou marquage est plus grand que l'encien d'un appartenant
          //à la liste de prédecesseur alors on l'ajoute pas
          else if predecessors.contains(where: { other in nextMarking > other.marking })
          {
            return nil // pas plus grand qu'un predecessors alors on l'ajoute pas
          }

          // evaluation terminer pour un état on passe au prochains mais en répertoriant nos découvertes
          else
          {
            // on créer un graphe successor pour l'ajouter au graphe le marquage initial devient nextmarking
            let successor = MarkingNode<Place>(marking: nextMarking)

            // on ajoute notre nouveau graphe au graphe successor
            rootGraph.append(successor)

            // on ajoute notre successor au noeud visité pour le prochain pas
            unprocessed.append((successor, predecessors + [node]))

            // on ajoute à l'index des successor ,associer à notre transition le successeur
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
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>) -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking))
    var rootGraph = [root]

    var unprocessed : [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    while let (node, predecessor) = unprocessed.popLast()
    {
      for transition in transitions
      {
        if var nextnode = transition.fire (from: node.marking)
        {
          if let undounded = predecessor.first(where: {element in element.marking < nextnode})
          {
            for place in Place.allCases
            {
              if undounded.marking[place] < nextnode[place]
              {
                nextnode[place] = .omega
              }
            }
          }

          if node.marking < nextnode
          {
            for place in Place.allCases
            {
              if (node.marking[place] < nextnode[place])
              {
                nextnode[place] = .omega
              }
            }
          }

          if let successor = rootGraph.first(where: {element in element.marking == nextnode})
          {
            node.successors[transition] = successor
          }
          else
          {
            let successor = CoverabilityNode(marking: nextnode)
            rootGraph.append(successor)
            unprocessed.append((successor, predecessor + [node]))
            node.successors[transition] = successor
          }
        }
      }
    }
    return root
    //original
    /*
    let root = CoverabilityNode(marking: extend(initialMarking))

    var rootGraph = [root]
    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    while let (node, predecessors) = unprocessed.popLast()
    {
      for transition in transitions
      {
        if var nextmarking = transition.fire(from: node.marking)
        {
          if let omegaSuccessor = predecessors.first(where: {other in other.marking < nextmarking})
          {
            for place in Place.allCases
            {
              if (omegaSuccessor.marking[place] < nextmarking[place])
              {
                nextmarking[place] = .omega
              }
            }
          }

          if let successor = rootGraph.first(where: {other in other.marking == nextmarking})
          {
            node.successors[transition] = successor
          }

          else
          {
            let successor = CoverabilityNode(marking: nextmarking)
            rootGraph.append(successor)
            unprocessed.append((successor, predecessors + [node]))
            node.successors[transition] = successor
          }
        }
      }
    }
    return root
    */
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))  }
}
