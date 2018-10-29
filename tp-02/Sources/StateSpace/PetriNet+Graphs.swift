extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {


      let root = MarkingNode(marking: initialMarking) // root == initialMarking

      var created = [root] // Stocker les noeuds crées
      // la variable unprocessed = (nodes, predecessors)
      var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // root n'a pas de predecessur


      while let (node, predecessors) = unprocessed.popLast() { //une boucle while pour vérifier s'il existe node == marking
                                                              //Avec la fonction popLast : Prendre le dernier noeud du variable unprocessed


        for transition in transitions { //Parcourir toutes les transitions de notre rdp



          //On test si une transition est tirable d'un noeud donné (node == marking)
          // et créer la variable newMarking  du nouveau marquage
          guard let newMarking = transition.fire(from: node.marking)
            else { continue } // Continuer meme en cas d'echec de creation de nouveau marquage



          //On teste si le nouveau marq est crée
          if let successor = created.first(where : { other in other.marking == newMarking }) { //first(where:) retourne le premier élément qui satifsfie un prédicat donné

            node.successors[transition] = successor //Ajouter le marquage a la liste de successeurs du noeud courant


            // On teste si le nouveau marquage est supérieur à tous les marquages précédents : newMarking > allPreviousMarking
            }

          else if predecessors.contains(where : { other in newMarking > other.marking }) { //contains.where retourne true si la un élément des prédecesseurs vérifie la condition

            return nil //  //Si le graphe de marquage est non borné

          }

          else { // Si le graphe de marquage est borné


            let successor = MarkingNode(marking: newMarking) //Créer un nouveau noeud de successeurs a partir du nouveau marquage
            created.append(successor) //Ajouter le nouveau noeud a la liste

            //Ajouter le nouveau noeud + les prédecesseurs à l'array "unprocessed"

            unprocessed.append((successor, predecessors + [node]))


            //Ajouter ce marquage à la liste des successeurs du noeud
            node.successors[transition] = successor
            }
            }
            }

            return root // retourner le marquage initial avec les successeurs 

  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {


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
