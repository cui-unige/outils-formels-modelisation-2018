extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>?
  {
    let root = MarkingNode(marking: initialMarking)
    var created = [root]
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]

    while let (node, predecessors) = unprocessed.popLast() // on sort le visité pour l'analyser
    {
      //for all transitions
      for transition in self.transitions
      {
        //if the transition to reach a new marking is fireable
        if let nextMarking = transition.fire(from: node.marking)
        {
          //take the first from the list and compare it to the initial marking and the new marking
          if let successor = created.first(where : {element in element.marking == nextMarking})
          {
            //if yes a successor has been found, and it is added to the lsit
            node.successors[transition] = successor
          }

          //if the marking is greater than one already on the list we don't add it
          else if predecessors.contains(where: {element in nextMarking > element.marking})
          {
            return nil
          }

          else
          {
            //create a new Marking for the successor
            let successor = MarkingNode<Place>(marking: nextMarking)

            //add the successor to the created graph
            created.append(successor)

            //add the new marking to be analysed
            unprocessed.append((successor, predecessors + [node]))

            //add the successor and associate it to the transition that resulted in said successor
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
    let root = CoverabilityNode(marking: extend(initialMarking))
    var created = [root]
    var unprocessed : [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    while let (node, predecessors) = unprocessed.popLast()
    {
      for transition in self.transitions
      {
        //if the transition to reach the next marking is fireable
        if var nextMarking = transition.fire (from: node.marking)
        {
          //check to make sure that the marking is less than the new Marking
          if let F = predecessors.first(where: {element in element.marking < nextMarking})
          {
            for place in Place.allCases
            {
              if F.marking[place] < nextMarking[place]
              {
                //if the place for the new marking is greater than in the marking, it is an Omega
                nextMarking[place] = .omega
              }
            }
          }

          //check to make sure that the previous marking is less than the new marking
          if node.marking < nextMarking
          {
            for place in Place.allCases
            {
              if (node.marking[place] < nextMarking[place])
              {
                //if the place for the new marking is greater than in the previous marking, it is an Omega
                nextMarking[place] = .omega
              }
            }
          }
          
          //same idea as previous method
          if let successor = created.first(where: {element in element.marking == nextMarking})
          {
            node.successors[transition] = successor
          }
          else
          {
            let successor = CoverabilityNode(marking: nextMarking)  //only difference from previous method is CovNode type here
            created.append(successor)
            unprocessed.append((successor, predecessors + [node]))
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
      }))  }
}
