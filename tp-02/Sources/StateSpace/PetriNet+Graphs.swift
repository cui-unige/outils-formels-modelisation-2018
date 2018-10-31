extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let rootNode = MarkingNode(marking: initialMarking)                         // Initializing the root marking node
    var vectors = [rootNode]                                                    // Vectors is an array of processed vector
    var unProcessedNodes : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(rootNode, [])]
    while let (node, predecessors) = unProcessedNodes.popLast() {               // Poping the last element of the list of unproccessed nodes
      for transition in transitions {                                           // for all transitions

        guard let nextMarking = transition.fire(from: node.marking)             // Verifying if the transition is fireable otherwise the for loop will continue with another loop
          else { continue }

        if predecessors.contains(where : { other in other.marking < nextMarking }) {
          // if the current marking is bigger than another marking already processed null will be returned because this pretri net is unborned
          return nil
        }
        else if let successor = vectors.first(where: { other in other.marking == nextMarking }) {
          // if the current marking is egual to another one, in this case it is unnecessary to continue because we already know this sequence, if this verification is not done there will be an infinite loop
          node.successors[transition] = successor
        }
        else {
          // if the current marking is smaller than the other markings already proccessed, the next marking will be stored into the vectors array. this next marking will also be stored into the unProcessedNodes with the ancestors of the current marking
          let successor = MarkingNode(marking: nextMarking)
          vectors.append(successor)
          unProcessedNodes.append((successor, predecessors + [node]))
          node.successors[transition] = successor
        }
      }
    }
    return rootNode
  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>) -> CoverabilityNode<Place>? {
    let rootNode = CoverabilityNode(marking: extend(initialMarking))            // Initializing the root coverability node
    var vectors = [rootNode]                                                    // Vectors is an array of processed vector
    var unProcessedNodes : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(rootNode, [])]
    while let (node, predecessors) = unProcessedNodes.popLast() {               // Poping the last element of the list of unproccessed nodes
      for transition in transitions {                                           // for all transitions
        guard var nextMarking = transition.fire(from: node.marking)             // Verifying if the transition is fireable otherwise the for loop will continue with another loop
          else { continue }

        if  let predecessor = predecessors.first(where : { other in other.marking < nextMarking }) { // getting the first already fired marking  that is smaller than the marking after being fired
          for place in Place.allCases{                                          // for all places
            if predecessor.marking[place] < nextMarking[place] {
              // verifying if the place contains an unborned marking
              nextMarking[place] = .omega                                       // adding omega to the next marking at the index place
            }
          }
        }

        if node.marking < nextMarking {
          // verifying if the current marking is smaller than next one, in that case omega will be set at the index place of the next marking.
          for place in Place.allCases {
            if node.marking[place] < nextMarking[place] {
              nextMarking[place] = .omega
            }
          }
        }

        if let successor = vectors.first(where: { other in other.marking == nextMarking }) {
          // if the marking is set, the sequence is already known so the successor will not added to the unProcessedNodes. it will prevent infinite loop
          node.successors[transition] = successor
        }
        else {
          // if the marking is smaller than the other markings already proccessed, the next marking will be stored into the vectors list. this next marking will also be stored into the unProcessedNodes with the ancestors of the current marking
          let successor = CoverabilityNode(marking: nextMarking)
          vectors.append(successor)
          unProcessedNodes.append((successor, predecessors + [node]))
          node.successors[transition] = successor
        }
      }
    }
    return rootNode
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
