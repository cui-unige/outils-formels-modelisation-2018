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
<<<<<<< HEAD
        unprocessed += node.successors.values.filter { successor in
          !processed.contains(where: { $0 === successor })
=======
        let created = processed + unprocessed
        unprocessed += node.successors.values.filter { successor in
          !created.contains(where: { $0 === successor })
>>>>>>> 89498810fe5a46437ad98d5eaff1ec50b0533af4
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
<<<<<<< HEAD
  let root        = Node<Net>(marking: initialMarking)
  var created     = [root]
  var unprocessed = [root]

  while let node = unprocessed.popLast() {
=======
  let root = Node<Net>(marking: initialMarking)
  var created = [root]
  var unprocessed: [(Node<Net>, [Node<Net>])] = [(root, [])]

  while let (node, predecessors) = unprocessed.popLast() {
>>>>>>> 89498810fe5a46437ad98d5eaff1ec50b0533af4
    for transition in petrinet.transitions {
      guard let nextMarking = transition.fire(from: node.marking)
        else { continue }
      if let successor = created.first(where : { other in other.marking == nextMarking }) {
        node.successors[transition] = successor
<<<<<<< HEAD
      } else if created.contains(where: { other in nextMarking > other.marking }) {
=======
      } else if predecessors.contains(where: { other in nextMarking > other.marking }) {
>>>>>>> 89498810fe5a46437ad98d5eaff1ec50b0533af4
        return nil
      } else {
        let successor = Node<Net>(marking: nextMarking)
        created.append(successor)
<<<<<<< HEAD
        unprocessed.append(successor)
=======
        unprocessed.append((successor, predecessors + [node]))
>>>>>>> 89498810fe5a46437ad98d5eaff1ec50b0533af4
        node.successors[transition] = successor
      }
    }
  }

  return root
}
