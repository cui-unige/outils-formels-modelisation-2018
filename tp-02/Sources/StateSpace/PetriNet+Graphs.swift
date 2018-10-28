extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

    let root = MarkingNode(marking: initialMarking)
    // visited (and kept with no ducplication)
    var created = [root]

    // to be visited
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]

    // while there are unprocessed things
    while let ( node, predecessors ) = unprocessed.popLast() {
      // explore every transitions
      for transition in self.transitions {
        // if transition firable, then fire it and get next mark (or else skip it)
        guard let next_marking = transition.fire(from: node.marking) else { continue }

        // chercher la première occurence de next_marking dans created
        if let successor = created.first( where : { other in other.marking == next_marking } ) {
          // si on l'a déjà visitée, on ajoute l'edge "transition" qui pointe vers ce sommet
          node.successors[transition] = successor
        } else if predecessors.contains( where: { other in next_marking > other.marking } ) {
          // si on l'a pas encore visité, mais qu'il est "plus grand" qu'un précédent déjà visité
          // ça veut dire qu'on est pas bounded (∃s infini tirable, qui augmente indéfiniment les jetons)
          return nil
        } else {
          // si on l'a pas encore visité, et en plus, il ne fait pas diverger le graphe
          let successor = MarkingNode( marking: next_marking )

          // on l'ajoute dans les noeuds créés
          created.append( successor )

          // les autres cas à traîter :
          // le nouveau noeud avec ses prédécesseur (= [ prédécesseurs , noeud_courrant])
          unprocessed.append( ( successor, predecessors + [node] ) )

          // on crée l'arc "transition" entre le noeud courrant et le nouveau noeud
          node.successors[transition] = successor
        }
      }
    }

    return root
    // PS : largement inspiré de l'exo-5 en voulant chercher la syntaxe pour créer un arbre avec cette lib...
  }


  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {

    let root = CoverabilityNode(marking: extend(initialMarking))

    // visited (and kept with no ducplication)
    var created = [root]

    // to be visited
    var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    // while there are unprocessed things
    while let ( node, predecessors ) = unprocessed.popLast() {
      // explore every transitions
      for transition in self.transitions {
        // if transition firable, then fire it and get next mark (or else skip it)
        guard var next_marking = transition.fire( from: node.marking ) else { continue }


        // if we find a growing loop
        // for a_smaller_predecessor in predecessors.filter( { other in other.marking < next_marking } ) {
          // only one suffice
        if let a_smaller_predecessor = predecessors.first( where: { other in other.marking < next_marking } ) {
          // for each place where the potential loop happens, put some ω
          for place in Place.allCases {
            if a_smaller_predecessor.marking[place] < next_marking[place] {
              next_marking[place] = ExtendedInt.omega
            }
          }
        }

        // oh and btw, is next_marking bigger than the present node ? do the same thing as before
        if node.marking < next_marking {
          for place in Place.allCases {
            if node.marking[place] < next_marking[place] {
              next_marking[place] = .omega
            }
          }
        }

        // does next_marking already exist ?
        if let successor = created.first( where: { other in other.marking == next_marking } ) {
          // it already is there ! yay ! let's add that edge
          node.successors[transition] = successor
        } else {
          // it's now there... fine. let's add it
          let successor = CoverabilityNode( marking: next_marking )
          created.append( successor )
          unprocessed.append( ( successor, predecessors + [node] ) )
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
