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
  var unprocessed: [(Node<Net>, [Node<Net>])] = [(root, [])]

  while let (node, predecessors) = unprocessed.popLast() {
    for transition in petrinet.transitions {
      guard let nextMarking = transition.fire(from: node.marking)
        else { continue }
      if let successor = created.first(where : { other in other.marking == nextMarking }) {
        node.successors[transition] = successor
      } else if predecessors.contains(where: { other in nextMarking > other.marking }) {
        return nil
      } else {
        let successor = Node<Net>(marking: nextMarking)
        created.append(successor)
        unprocessed.append((successor, predecessors + [node]))
        node.successors[transition] = successor
      }
    }
  }

  return root
}
