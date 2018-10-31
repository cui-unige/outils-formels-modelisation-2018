import SemaLib

class Node: Sequence {

  init(marking: @escaping Marking) {
    self.marking = marking
  }

  let marking: Marking
  var successors: [Transition: Node] = [:]

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

func computeGraph(of petrinet: PetriNet, from initialMarking: @escaping Marking) -> Node? {
  let root        = Node(marking: initialMarking)
  var created     = [root]
  var unprocessed = [root]

  while let node = unprocessed.popLast() {
    for transition in petrinet.transitions {
      guard let nextMarking = petrinet.fire(transition, from: node.marking)
        else { continue }
      if let successor = created.first(where : { other in
        petrinet.places.allSatisfy { other.marking($0) == nextMarking($0) }
      }) {
        node.successors[transition] = successor
      } else if created.contains(where: { other in
        greater(nextMarking, than: other.marking, places: petrinet.places)
      }) {
        return nil
      } else {
        let successor = Node(marking: nextMarking)
        created.append(successor)
        unprocessed.append(successor)
        node.successors[transition] = successor
      }
    }
  }

  return root
}

func greater(_ lhs: Marking, than rhs: Marking, places: Set<Place>) -> Bool {
  var hasGreater = false
  for place in places {
    guard lhs(place) >= rhs(place)
      else { return false }
    hasGreater = hasGreater || lhs(place) > rhs(place)
  }
  return hasGreater
}
