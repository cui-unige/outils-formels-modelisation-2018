import PetriKit

class Node<Net>: Sequence where Net: PetriNet {

  init(marking: Net.MarkingType) {
    self.marking = marking
  }

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
  var unprocessed: [(Node<Net>, [Node<Net>])] = [(root, [])] // les visités

  while let (node, predecessors) = unprocessed.popLast() { // on sort le visité pour l'analyser
    for transition in petrinet.transitions { // on regarde les transition du visité
      guard let nextMarking = transition.fire(from: node.marking) // on regarde si un maquage depuis le visité existe
        else { continue } // sinon : nil , on continue            // on crée également le nouveau marquage
      if let successor = created.first(where : { other in other.marking == nextMarking }) { // on prend le premier de liste créé on le compare entre le marquage initiale et le nouveau
        node.successors[transition] = successor// si oui on a trouver un successeur  sinon ce n'est pas un successeur , si oui on l'ajoute à la liste des successeurs
      } else if predecessors.contains(where: { other in nextMarking > other.marking }) { // si le nouveou marquage est plus grand que l'encien d'un appartenant à la liste de prédecesseur alors on l'ajoute pas
        return nil // pas plus grand qu'un predecessors alors on l'ajoute pas
      } else { // evaluation terminer pour un état on passe au prochains mais en répertoriant nos découvertes
        let successor = Node<Net>(marking: nextMarking) // on créer un graphe successor pour l'ajouter au graphe le marquage initial devient nextmarking
        created.append(successor)// on ajoute notre nouveau graphe au graphe successor
        unprocessed.append((successor, predecessors + [node])) // on ajoute notre successor au noeud visité pour le prochain pas
        node.successors[transition] = successor // on ajoute à l'index des successor ,associer à notre transition le successeur
      }
    }
  }

  return root // en retournant la racine on retourne tout le graphe procédé itératif implique dfs recherche en profondeur
}
