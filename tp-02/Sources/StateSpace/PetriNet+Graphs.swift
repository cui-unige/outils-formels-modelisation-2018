extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking) //Racine
    var created = [root] //Array des noeuds créés, parcourus
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] // Array de tuples contenant le noeud à partir duquel on va calculer les marquages suivants, et ses noeuds parents

    while let (node, predecessors) = unprocessed.popLast(){

      for transition in transitions{

        guard let nextMarking = transition.fire(from : node.marking)
        else {
          continue //Si on ne peut pas tirer la transition, on reprend au début du for
        }
        if let successor = created.first(where: {$0.marking == nextMarking})  { //S'il existe un noeud successeur tel que son marquage est égal à celui du marquage calculé (nextMarking)
          node.successors[transition] = successor //Ce noeud est ajouté aux successeurs du noeud node, après le tirage de la transition actuelle
        }
        else if predecessors.contains(where : {$0.marking < nextMarking}) { //Autrement, s'il existe un noeud parent du noeud node tel que le marquage à ce noeud est inférieur à celui calculé (nextMarking)
          return  nil //on arrête
        }
        else {
          let successor = MarkingNode(marking: nextMarking)
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
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)-> CoverabilityNode<Place>? {
    let root = CoverabilityNode(marking: extend(initialMarking))
    var created = [root]
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])]

    while let (node, predecessors) = unprocessed.popLast() {

      for transition in transitions {

        guard var nextmarking = transition.fire(from : node.marking)
        else {
          continue
        }
        if let greatSuccessor = predecessors.first(where: {$0.marking < nextmarking}) {
          for place in Place.allCases {
            if greatSuccessor.marking[place] < nextmarking[place] {
                  nextmarking[place] = .omega
            }
          }
        }
            if node.marking < nextmarking {
              for place in Place.allCases {
                if   node.marking[place] < nextmarking[place]{
                  nextmarking[place] = .omega
                  }
              }
            }
          if let successor = created.first(where: {other in other.marking == nextmarking}) {
          node.successors[transition] = successor
        }
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
