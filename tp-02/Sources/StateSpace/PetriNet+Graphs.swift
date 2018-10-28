extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root (= marquage initial) of the marking graph. If the model isunbounded, the function returns nil.

  /*
  Principe :
  On ajoute le marking initial à l'array
  On tire la transition
  Si c'est 0 y a pas de successeurs donc continue
  - Si le successeur = root alors on fait rien car sinon on répète le même schéma
  - Si le next marking (marquage suivant) est plus grand qu'un prédécesseurs,
  c'est non borné donc return nil
  - Sinon on ajoute les marquages successeurs à l'array pour pouvoir les comparer après
  (pour comparer les marquages actuels de ceux passés)
  */

  // Fonctions issues de l'exercice 4 du séminaire

  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // initalisation du marquage initial
    let root = MarkingNode(marking: initialMarking)

    // instanciation du graphe de marquage qui va permettre
    // de déterminer les vecteurs parcourus si le graphe est borné
    var created = [root]

    // initialisation de la liste contenant les marquages déjà parcourus,
    // qui va servir à comparer les marquages successeurs aux prédécesseurs
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]

    // boucle qui parcourt les marquages passés en
    // comparant aux éléments de unprocessed
    while let (node, predecessors) = unprocessed.popLast() {
      for transition in transitions {
        // contrôle la tirabilité de la transition sinon la boucle
        // continue d'itérer
        guard let nextMarking = transition.fire(from: node.marking)
          else { continue }
        // si le marquage successeur = un précédent marquage (other) alors on connaît
        // la séquence, donc on connaît le graphe de marquage, on continue à itérer
        // -> first permet de retrouver le premier marquage respectant la condition dans la liste
        if let successor = created.first(where : { other in other.marking == nextMarking }) {
          node.successors[transition] = successor
          // si, dans la liste des marquages précédents, il existe une valeur
          // plus petite que le marquage successeur
          // alors le réseau est non-borné et on renvoie nil
        } else if predecessors.contains(where: { other in other.marking < nextMarking }) {
          return nil
          // dernier cas : si le marquage successeur est plus petit que les marquages précédents
          // alors on l'ajoute aux listes de noeuds created
          // et unprocessed, puis on continue à itérer
        } else {
          let successor = MarkingNode(marking: nextMarking)
          created.append(successor)
          unprocessed.append((successor, predecessors + [node]))
          node.successors[transition] = successor
        }
      }
    }
    // renvoie le graphe de marquage dans le cas d'un graphe borné
    // depuis le marquage initial
    return root
  }


  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // initalisation du marquage initial
    let root = CoverabilityNode(marking: extend(initialMarking))

    // instanciation du graphe de marquage qui va permettre
    // de déterminer les vecteurs parcourus si le graphe est borné
    var created = [root]

    // initialisation de la liste contenant les marquages déjà parcourus,
    // qui va servir à comparer les marquages successeurs aux prédécesseurs
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root, [])]

    // boucle qui parcourt les marquages passés en
    // comparant aux éléments de unprocessed
    while let (node, predecessors) = unprocessed.popLast() {
        for transition in transitions{
            // contrôle la tirabilité de la transition sinon la boucle
            // continue d'itérer
            guard var nextMarking = transition.fire(from: node.marking)
                else { continue }
            // si le premier marquage déjà tiré est plus petit que le marquage successeur
            // on itère dans les places
            if let predecessor = predecessors.first(where : {other in other.marking < nextMarking}) {
                for place in Place.allCases {
                    // si un marquage précédent est < que le successeur (donc non borné)
                    // alors on attribue la valeur omega au marquage de la place et la branche du graphe est terminée
                    if predecessor.marking[place] < nextMarking[place] {
                        nextMarking[place] = .omega
                    }
                }
            }

            // si le marquage actuel est < que le marquage successeur,
            // on attribue omega au marquage de la place qui contient le plus de jetons
            if node.marking < nextMarking {
                for place in Place.allCases {
                    if node.marking[place] < nextMarking[place] {
                      nextMarking[place] = .omega
                    }
                }
            }

            // si le marquage successeur est égal à un marquage précéde
            // on l'ajoute à la liste des successeurs du marquage car on connaît déjà la séquence
            if let successor = created.first(where: {other in other.marking == nextMarking}){
                node.successors[transition] = successor
            }

            // dernier cas : si le marquage successeur est plus petit que les marquages précédents
            // alors on l'ajoute aux listes de noeuds created
            // et unprocessed, puis on continue à itérer dans le graphe
            else {
                let successor = CoverabilityNode(marking: nextMarking)
                created.append(successor)
                unprocessed.append((successor, predecessors + [node]))
                node.successors[transition] = successor
            }
        }
    }
    // renvoie le graphe de marquage depuis le marquage initial
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
