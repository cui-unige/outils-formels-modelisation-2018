extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {

    let root = MarkingNode(marking: initialMarking) //On initialise root avec le marking initial, renvoie un marquage et ses successeurs

    var created = [root] //Vecteur contenant les noeuds différents créés
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])] //Vecteur avec les éléments qu'on doit regarder, composé d'abord du noeud puis du prédécesseur
    while let (node, predecessors) = unprocessed.popLast(){ //Tant qu'il y a encore des éléments à regarder, on prend le dernier
      for transition in transitions{ //On boucle sur toutes les transitions pour voir les marquages obtenus
        guard let nextmarking = transition.fire(from : node.marking) //Le prochain marquage est celui obtenu après le tirage de la transition
        else {continue}
        if let successor = created.first(where: {other in other.marking == nextmarking})  { //Si on a déjà vu le prochain marquage, s'il existe déjà, le first prends le premier élément qui vérifie la condition

          node.successors[transition] = successor//le successeur dans le graph du noeud après la transition est successor, le noeud créé qui existe déjà, on ne le touche plus par la suite
        }else if predecessors.contains(where : {other in other.marking < nextmarking}) { //Si sur le chemin il y a un marquage plus petit que nextmarking, c'est pas borné
          return  nil
        }else{ //Si on a pas encore vus le marquage
           let successor = MarkingNode(marking: nextmarking) //Création du noeud nextmarking et ses successeurs
           created.append(successor) //On ajoute le marking dans les marking créés
           unprocessed.append((successor, predecessors + [node])) //On le met dans unprocessed pour le faire après, le noeud devient le prédessesseur et successor est le noeud
           node.successors[transition] = successor //le successeur dans le graph du noeud après la transition est le noeud créé
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
    let root = CoverabilityNode(marking: extend(initialMarking)) //On initialise root avec le marking initial, renvoie un marquage et ses successeurs
        var created = [root]  //Vecteur contenant les noeuds différents créés
        var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] //Vecteur avec les éléments qu'on doit regarder, composé d'abord du noeud puis du prédécesseur
        while let (node, predecessors) = unprocessed.popLast(){ //Tant qu'il y a encore des éléments à regarder, on prend le dernier
          for transition in transitions{  //On boucle sur toutes les transitions pour voir les marquages obtenus
            guard var nextmarking = transition.fire(from : node.marking) //Le prochain marquage est celui obtenu après le tirage de la transition
            else {continue}
                if let predecessor = predecessors.first(where: {other in other.marking < nextmarking})  { //Si on trouve un ancien marquage plus petit, on prends le premier comme ceci et on le met dans predecessor
                  for place in Place.allCases { //On regarde toutes les places
                    if predecessor.marking[place] < nextmarking[place]{ //Si il y a moins de jetons dans la place de predecessor que dans celle de nextmarking
                      nextmarking[place] = .omega //On met un oméga dans la place de nextmarking à la place de ce qu'il y avait avant, ce n'est pas borné dans cette place
                      }
                    }
                }
                if node.marking < nextmarking{  //Si le marquage du noeud qu'on regarde est plus petit que le prochain marquage qui va suivre (on le test car il n'a pas été testé dans les prédecesseurs)
                  for place in Place.allCases { //On regarde toutes les places
                    if node.marking[place] < nextmarking[place]{ //S'il y a moins de jetons dans la place du marquage courant que dans la place de nextmarking
                      nextmarking[place] = .omega //On met oméga dans la place de nextmarking car ce n'est pas borné dans cette place
                      }
                    }
                }
            if let successor = created.first(where: {other in other.marking == nextmarking})  { //Si on a déjà vu le prochain marquage, s'il existe déjà, on prend le premier tel marquage
              node.successors[transition] = successor //le successeur dans le graph du noeud après la transition est le noeud créé, on ne le touche plus par la suite, on l'a déjà visité
            }
            else{ //Si il n'y a pas d'ancien marquage égal à celui-ci
               let successor = CoverabilityNode(marking: nextmarking)  //Création du noeud nextmarking et ses successeurs
               created.append(successor)  //On ajoute le marking dans les marking créés
               unprocessed.append((successor, predecessors + [node])) //On le met dans unprocessed pour le faire après, le noeud devient le prédessesseur et successor est le noeud
               node.successors[transition] = successor  //le successeur dans le graph du noeud après la transition est le noeud créé
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
