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
        unprocessed += node.successors.values.filter { successor in
          !processed.contains(where: { $0 === successor })
        }
        return node
      }
      return nil
    }
  }

}

func computeGraph<Net>(of petrinet: Net, from initialMarking: Net.MarkingType) -> Node<Net>?
  where Net: PetriNet, Net.Transition.PlaceContent: Comparable
{
  let root        = Node<Net>(marking: initialMarking)
  var created     = [root]
  var unprocessed = [root]

  while let node = unprocessed.popLast() {
    for transition in petrinet.transitions {
      guard let nextMarking = transition.fire(from: node.marking)
        else { continue }
      if let successor = created.first(where : { other in
        Net.Place.allCases.allSatisfy { place in other.marking[place] == nextMarking[place] }
      }) {
        node.successors[transition] = successor
      } else if created.contains(where: { other in nextMarking > other.marking }) {
        return nil
      } else {
        let successor = Node<Net>(marking: nextMarking)
        created.append(successor)
        unprocessed.append(successor)
        node.successors[transition] = successor
      }
    }
  }

  return root
}
