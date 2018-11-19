import PetriKit

class Node<Net>: Sequence where Net: PetriNet {

  init(marking: Net.MarkingType) {
    self.marking = marking
  } // initialise un noeud avec un marking

  let marking: Net.MarkingType
  var successors: [Net.Transition: Node] = [:]

  func makeIterator() -> AnyIterator<Node> {
    var unprocessed: [Node] = [self]
    var processed  : [Node] = []

    return AnyIterator {
      while let node = unprocessed.popLast() {
        processed.append(node)
        let created = processed + unprocessed
        unprocessed += node.successors.values.filter { successor in
          !created.contains(where: { $0 === successor })
        }
        return node
      }
      return nil
    }
  }

  var count: Int {
    var counter = 0
    for _ in self {
      counter += 1
    }
    return counter
  }

}

func computeGraph<Net>(of petrinet: Net, from initialMarking: Net.MarkingType) -> Node<Net>?
  where Net: PetriNet, Net.Transition.PlaceContent: Comparable
{
  let root = Node<Net>(marking: initialMarking)
  var created = [root]
  var unprocessed: [(Node<Net>, [Node<Net>])] = [(root, [])]
  //Unprocessed: La liste contient, un noeud et une liste de noeuds = donc ses prédecesseurs

  while let (node, predecessors) = unprocessed.popLast() { //prend le dernier unprocessed de la liste
  // Donc le dernier noeud qui n'a pas été étudié

    for transition in petrinet.transitions { // pour toutes les transitions qui existent dans le réseau
      guard let nextMarking = transition.fire(from: node.marking)
      // Regarde si la transition est tiré depuis le dernier marquage
       // si M->M1 si la transition t est tirée depuis le dernier marquage (contient après qu'il soit tiré)
       // SINON --> Nil, on va directement au else

        else { continue // continue--> va directement à l'itération d'après
                        // si on a un nil on va à l'itération suivante
        }
      if let successor = created.first(where : { other in other.marking == nextMarking }) {
        node.successors[transition] = successor
        // Map deux marquages ensembles
        // successor = pour un noeud on map une transition à un état
        // prend un successeur, qui est le premier noeud de la liste
        // created: pour tous les elements de created (other)


      } else if predecessors.contains(where: { other in nextMarking > other.marking }) {
        return nil
        // Regarde si il est borné
         // si dans prédécesseurs, état other contient moins de jeton que le nouveau état
        // Borné: nbr jeton ne doit pas dépasser k, on ne doit pas dépasser celui le plus borné



      } else {
        let successor = Node<Net>(marking: nextMarking)
        // creer un noeud successeur
        // cree un noeud avec ce marking  = qu'on appel successor
        created.append(successor)
        unprocessed.append((successor, predecessors + [node]))
        node.successors[transition] = successor
         // si effectue transtion on arrive à l'état successors
        // Depuis node, en prenant transition, on arrive à successor


        //  Prendre un marking initialMarking// voir tous les marking qu'on peut atteindre en faisant des transitions
        //  On prend 1 noeud, ayant accès a ces predecesseurs
        //  Tester toutes les transitions possibles
        //  On prend une transition, on regarde si on peut la tirer, sinon transition on continue
        //  Si peut tirer, on peut calculer le successeur, on doit regarder
        //  Si pas encore calculé, on appelle la methode first qui cherche un état qui à le même marqui que celui calculé
        //  On rajouter un lien entre le node et ce successeur
      }
    }
  }

  return root
}
