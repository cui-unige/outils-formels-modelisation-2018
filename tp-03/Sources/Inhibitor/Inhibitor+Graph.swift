public class MarkingNode<Place>: Sequence where Place: Hashable {

  public init(marking: [Place: Int]) {
    self.marking = marking
  }

  public let marking: [Place: Int]
  public var successors: [InhibitorNet<Place>.Transition: MarkingNode] = [:]

  public func makeIterator() -> AnyIterator<MarkingNode> {
    var unprocessed: [MarkingNode] = [self]
    var processed  : [MarkingNode] = []

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

  public var count: Int {
    var counter = 0
    for _ in self {
      counter += 1
    }
    return counter
  }

}

extension InhibitorNet {

  /// Computes the marking graph of this model, from a given initial marking.
  ///
  /// - Note: Since Petri nets extended with inhibitor arcs are as powerful as a turing machine,
  ///   there's no way to decide whether the computation of the marking graph terminates. Therefore,
  ///   it's possible calling this method will never terminate.
  public func computeMarkingGraph(from initialMarking: [Place: Int]) -> MarkingNode<Place> {
    let root = MarkingNode(marking: initialMarking)
    var created = [root]
    var unprocessed = [root]

    while let node = unprocessed.popLast() {

      for transition in transitions {
        guard let nextMarking = transition.fire(from: node.marking)
          else { continue }
        if let successor = created.first(where : { other in other.marking == nextMarking }) {
          node.successors[transition] = successor
        } else {
          let successor = MarkingNode(marking: nextMarking)
          created.append(successor)
          unprocessed.append(successor)
          node.successors[transition] = successor
        }
      }
    }

    return root
  }

}
