extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.

    let root = MarkingNode(marking: initialMarking) //On initialise root avec le marquage initial, renvoie un marquage et ses successeurs
        var nodes = [root] //liste contenant les noeuds différents créés
        //print(root)
        //print("YOLO-LALA")
        var nodeToProcess : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //dict avec des noeuds qu'on doit regarder, composé d'abord du noeud puis des prédécesseurs
        // dict: a traiter -> noeud, liste des predecesseurs du noeuds

        while let (node, predecessors) = nodeToProcess.popLast(){ //Tant qu'il y a encore des éléments à regarder, on prend le dernier
        //enleve et retourne le dernier element da la liste (.popLast())
        //predecessors liste de predecesseurs
        //node est le noeud courant

          for transition in transitions{ //boucle sur toutes les transitions pour voir les marquages obtenus pour le noeud (node)

            if let nextmarking = transition.fire(from : node.marking){ //si transition tirable, on la tire et on a/obtient le prochain marquage
            //nextmarking = result de fire

            if let successor = nodes.first(where: {other in other.marking == nextmarking})  { //test si on a deja vu le prochain marquage, si on l'a deja vu (s'il existe deja dans liste nodes), le first prend le premier element qui verifie la condition
                //Si on a déjà vu le prochain marquage, s'il existe déjà, le first prends le premier élément qui vérifie la condition
                //stocke ce marquage dans successor

              node.successors[transition] = successor//creation de l'arc du successor
            }
            else if predecessors.contains(where : {other in other.marking < nextmarking}) { //Si sur le chemin il y a un marquage plus petit que nextmarking, c'est non-borné
                //si un predecesseur,sur le chemin, est plus petit que le prochain marquage, on retourne "nil"

              return  nil
            }

            else{ //Si on a pas encore vus le marquage
               let newNode = MarkingNode(marking: nextmarking) //Création du noeud nextmarking et ses successeurs
               //cree nouveau noeud avec comme marquage, le prochain marquge, qui est celui qu'on a pas encore vu
               nodes.append(newNode) //On ajoute le nouveau noeud avec le nouveau marquage a la liste des differents noeuds
               nodeToProcess.append((newNode, predecessors + [node])) //On le met dans nodeToProcess pour le traiter après (le nouveau noeud avec ses prédécesseur (= [ prédécesseurs , noeud_courrant]))
               node.successors[transition] = newNode // creation de l'arc "transition" entre le noeud courrant et le nouveau noeud
            }
        }
          }
        }
          return root //On retourne root, donc le marking graph puisqu'il contient les successeurs
      }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking))//On initialise root avec le marking initial, renvoie un marquage et ses successeurs
    var nodes = [root]  //liste contenant les noeuds différents créés
    var nodesToProcess : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // dict: a traiter -> noeud, liste des predecesseurs du noeuds
    while let (node, predecessors) = nodesToProcess.popLast(){ //Tant qu'il y a encore des éléments à regarder, on prend le dernier
        for transition in transitions{  //boucle sur toutes les transitions pour voir les marquages obtenus
        if var nextmarking = transition.fire(from : node.marking){ //si transition tirable, on la tire et on a le prochain marquage
              if let predecessor = predecessors.first(where: {other in other.marking < nextmarking})  { ////si un predecesseur,sur le chemin, est plus petit que le prochain marquage, on prends le premier comme ceci et on le met dans predecessor
                for place in Place.allCases { //On regarde toutes les places avec une boucle
                  if predecessor.marking[place] < nextmarking[place]{ //Si il y a moins de jetons dans la place du predecesseur que dans celle de nextmarking
                    nextmarking[place] = .omega //alors on met un oméga dans la place de nextmarking à la place de ce qu'il y avait avant, ce n'est pas borné dans cette place
                    }
                  }
              }

              if node.marking < nextmarking{  //Si le marquage du noeud qu'on regarde est plus petit que le prochain marquage qui va suivre (on le test car il n'a pas été testé dans les prédecesseurs)
                for place in Place.allCases { //On regarde toutes les places avec une boucle
                  if node.marking[place] < nextmarking[place]{ //S'il y a moins de jetons dans la place du marquage courant que dans la place de nextmarking
                    nextmarking[place] = .omega //alors on met oméga dans la place de nextmarking car ce n'est pas borné dans cette place
                    }
                  }
              }
              if let successor = nodes.first(where: {other in other.marking == nextmarking})  { //test si on a deja vu le prochain marquage, si on l'a deja vu (s'il existe deja dans liste nodes), le first prend le premier element qui verifie la condition
              //Si on a déjà vu le prochain marquage, s'il existe déjà, le first prends le premier élément qui vérifie la condition
              //stocke ce marquage dans successor

                node.successors[transition] = successor //creation de l'arc du successor
            }
          else{ //Si on a pas encore vus le marquage
             let newNode = CoverabilityNode(marking: nextmarking)//cree nouveau noeud avec comme marquage, le prochain marquge, qui est celui qu'on a pas encore vu
             nodes.append(newNode) //On ajoute le nouveau noeud avec le nouveau marquage a la liste des differents noeuds
             nodesToProcess.append((newNode, predecessors + [node])) //On le met dans nodeToProcess pour le traiter après (le nouveau noeud avec ses prédécesseur (= [ prédécesseurs , noeud_courrant]))
             node.successors[transition] = newNode  // creation de l'arc "transition" entre le noeud courrant et le nouveau noeud
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
