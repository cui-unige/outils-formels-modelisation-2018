/*
------------------------------------------------------------------------------
# NAME : PetriNet+Graphs.swift
#
# PURPOSE : Extension of PetriNet structure containing marking graphs for both
#           bounded and unbounded model
#
# AUTHOR : Benjamin Fischer
#
# CREATED : 26.10.2018
-----------------------------------------------------------------------------
*/
extension PetriNet {
  /*
  ------------------------------------------------------------------------------
  METHOD : computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>?

  PURPOSE : Computes the marking graph of a Petri network (assuming it is bounded),
            starting from the given marking, and returns the root of the marking.
            If the model is unbounded, the function returns nil.

  INPUT : from initialMarking: Marking<Place, Int>

  OUTPUT : root: MarkingNode<Place> or NIL
  ------------------------------------------------------------------------------
  */
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    /*
    # --------------------------------------------------------------------------
    # See slide 10 of RdPVerifProp.pdf for the full algorithm's details
    # --------------------------------------------------------------------------
    */

    // root is labelled by the initial marking
    let root = MarkingNode(marking: initialMarking)
    // storing of root == initialMarking
    var created = [root] // will stores all the created nodes
    // unprocessed = (nodes, predecessors) | node and his predecesors
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // root has no predecessor

    // loop while there exists node == marking
    // take the last node of the variable unprocessed
    while let (node, predecessors) = unprocessed.popLast() {

      // loop on every single transition of the Petri network
      for transition in transitions {

        // test if a specified transition is fireable from a a given node == marking
        // the new marking is obtained by the fire of the transition
        guard let newMarking = transition.fire(from: node.marking) // create a new marking
          else { continue } // continue even if the creation of the new marking fails.

        // check if the new marking has already been created
        // first(where:) returns the first element that satifsfies a given predicate
        if let successor = created.first(where : { other in other.marking == newMarking }) {
          // add the corresponding marking to the current node's successors list
          node.successors[transition] = successor

          // test if the new marking is the superior bound of all the previous markings
          // pseudocode : newMarking > allPreviousMarking for every single place of markings
        } else if predecessors.contains(where : { other in newMarking > other.marking }) {

          return nil // marking graph is unbounded

        } else { // marking graph is bounded
          // create new successor node from the new marking
          let successor = MarkingNode(marking: newMarking)
          created.append(successor) // stick the new node to the list of nodes
          // add the new node and his predecessors to the unprocessed variable
          unprocessed.append((successor, predecessors + [node]))
          // add the corresponding marking to the current node's successors list
          node.successors[transition] = successor
        }
      }
    }

    return root // initial marking with successors
  }
  /*
  ------------------------------------------------------------------------------
  METHOD : computeCoverabilityGraph(from initialMarking: Marking<Place, Int>) -> CoverabilityNode<Place>?

  PURPOSE : Computes the coverability graph of a Petri network, starting from
            the given marking, and returns the root of the graph. Note that if
            the model is bounded, the coverability graph is actually equivalent
            to the marking one.

  INPUT : from initialMarking: Marking<Place, Int>

  OUTPUT : root: MarkingNode<Place>
  ------------------------------------------------------------------------------
  */
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    /*
    # --------------------------------------------------------------------------
    # See slide 10 of RdPVerifProp.pdf for the full algortihm's details
    # --------------------------------------------------------------------------
    */

    // Basically the same code than the previous method, except that we handle the case of unbounded graph
    // More precisely, this test : if predecessors.contains(where : { other in newMarking > other.marking })

    // ExtendedInt contains all natural number + omega
    // see slide 8 of RdPVerifProp.pdf or ExtendedInt.swift for operations including omega
    let root = CoverabilityNode(marking: extend(initialMarking)) // root is labelled by the extended initial marking
    // storing of root == initialMarking
    var created = [root] // will stores all the created nodes
    // unprocessed = (node, predecessors) | node and his predecessors
    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])] // root has no predecessor

    // loop while there exists node == marking
    // take the last node of the variable unprocessed
    while let (node, predecessors) = unprocessed.popLast() {

      // loop on every single transition of the Petri network
      for transition in transitions {

        // test if a specified transition is fireable from a a given node == marking
        // the new marking is obtained by the fire of the transition
        guard var newMarking = transition.fire(from: node.marking) // create a new marking
          else { continue } // continue even if the creation of the new marking fails.
        /*
        # --------------------------------------------------------------------------
        # TEST ALL PREVIOUS MARKINGS == PREDECESSORS
        # --------------------------------------------------------------------------
        */
        // test if the new marking is the superior bound of all the previous markings
        // first(where:) returns the first element that satifsfies a given predicate
        if let predecessor = predecessors.first(where: {other in other.marking < newMarking})  {
          // Loop on every single place
          for place in Place.allCases {
            // verify for each place of the new marking if it is superior than the one of the previous marking
            // pseudocode : newMarking > allPreviousMarking for every single place of marking
            if predecessor.marking[place] < newMarking[place] {
              newMarking[place] = .omega // affect omega for this specific place
            }
          }
        }
        /*
        # --------------------------------------------------------------------------
        # TEST UNPROCESSED CURRENT NODE
        # --------------------------------------------------------------------------
        */
        // test if the new marking is the superior bound of the current node (unprocessed)
        if node.marking < newMarking {
          // Loop on every single place
          for place in Place.allCases {
            // verify for each place of the new marking if it is superior than the one of the current node (unprocessed)
            if node.marking[place] < newMarking[place] {
              newMarking[place] = .omega // affect omega for this specific place
            }
          }
        }
        // check if the new marking has already been created
        // first(where:) returns the first element that satifsfies a given predicate
        if let successor = created.first(where : { other in other.marking == newMarking }) {
          // add the corresponding marking to the current node's successors list
          node.successors[transition] = successor
        } else {
          //  create new successor node from the new marking
          let successor = CoverabilityNode(marking: newMarking)
          created.append(successor) // stick the new node to the list of nodes
          // add the new node and his predecessors to the unprocessed variable
          unprocessed.append((successor, predecessors + [node]))
          // add the corresponding marking to the current node's successors list
          node.successors[transition] = successor
        }
      }
    }

    return root // initial marking with successors
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
