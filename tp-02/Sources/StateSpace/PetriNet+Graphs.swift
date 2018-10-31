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

            return nil  //Si le graphe de marquage est non borné

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

    // root est déclarée en tant que marquage initial etendu(extended)
  let root = CoverabilityNode(marking: extend(initialMarking))
  var created = [root] // va stocker tous les noeuds crées
  //  unprocessed va stocker tous les noeuds et leur prédecesseurs attention: la racine n'a pas de prédecesseur
  var unprocessed: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    // Fait une boucle qui agit tant que l'on trouve un marquage dans la dernière valeur de la liste unprocessed
  while let (node, predecessors) = unprocessed.popLast() {

    for transition in transitions {

      //  guard teste si chaque transition est tirable depuis chaque marquage que l'on trouve grâce à l'étape précédente (boucle while)
      // Un nouveau marquage "newMarking" est alors obtenu après avoir tiré la transition
      guard var newMarking = transition.fire(from: node.marking)
        else { continue } // continue de travailler même si la création du nouveau marquage n'est pas possible (transition non tirable)
        /*
           # --------------------------------------------------------------------------
           # TEST ALL PREVIOUS MARKINGS == PREDECESSORS
           # --------------------------------------------------------------------------
           */
       // On teste si "newMarking" représente la borne supérieure de tous les marquages explorés jusque là (nbr de jetons dans chaque place du marquage
      if let predecessor = predecessors.first(where: {other in other.marking < newMarking})  {

        for place in Place.allCases {
          // On vérifie pour chaque place du "newMarking" si il y a un nombre de jetons plus élevé que dans le marquage précédent(predecesseur)
          if predecessor.marking[place] < newMarking[place] {
            newMarking[place] = .omega // On attribue la valeur omega à la place qui contenait le plus de jetons(borne)
          }
        }
      }
      /*
      # --------------------------------------------------------------------------
      # TEST UNPROCESSED CURRENT NODE
      # --------------------------------------------------------------------------
      */
        // On teste si "newMarking" représente la borne supérieure du marquage
      if node.marking < newMarking {

        for place in Place.allCases {
          // On vérifie s'il y a un nbr supérieur de jetons dans chaque place place du "newMarking" par rapport à notre marquage
          if node.marking[place] < newMarking[place] {
            newMarking[place] = .omega // On attribue la valeur omega à la place qui contenait le plus de jetons(borne)
          }
        }
      }

      // Recherche si "newMarking" a déjà été créé au préalable
      if let successor = created.first(where : { other in other.marking == newMarking }) {
        //  On ajoute "newMarking" à la liste des successeurs du marquage
        node.successors[transition] = successor
      } else {
        // On crée "successor" utilisant la valeur de newMarking en tant que successeur du marquage
        let successor = CoverabilityNode(marking: newMarking)
        // On ajoute "successor" à la liste de noeuds crées
        created.append(successor)
         // On ajoute "successor" ainsi que ses predecesseurs à la liste de noeuds(unprocessed)
        unprocessed.append((successor, predecessors + [node]))
         // On ajoute "successor" à la liste de successeurs du marquage
        node.successors[transition] = successor
      }
    }
  }

  return root // Marquage initial avec racine et successeurs

  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
