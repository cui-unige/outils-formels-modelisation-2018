/// Base protocol for graph nodes.
///
/// Marking and coverability nodes shall conform to this protocol, so as to provide a default
/// conformance to `Hashable` and `Sequence`.
public protocol GraphNode: AnyObject, Hashable, Sequence {

  /// The type of the transition that'll be used to represent the labels to the successors.
  associatedtype TransitionType: Hashable
  /// The type of markings the node are associated with.
  associatedtype MarkingType: Hashable

  /// The marking associated with the node.
  var marking: MarkingType { get }
  /// The successors of the node.
  var successors: [TransitionType: Self] { get }

}

extension GraphNode {

  /// Create an iterator over all the graph's node accessible from this one.
  public func makeIterator() -> AnyIterator<Self> {
    var unprocessed: [Self] = [self]
    var processed: [Self] = []

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

  /// The number of nodes accessible from this one, included.
  public var count: Int {
    var counter = 0
    for _ in self {
      counter += 1
    }
    return counter
  }

  /// Returns the hash value of this node.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(marking)
  }

  /// Returns whether two nodes are equal.
  ///
  /// Node equality is established on their reference equality, as they are supposed to be unique.
  /// Note that there's no built-in mechanism to ensure such unicity, and that it's the user's
  /// responsability to bookkeep such unicity.
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs === rhs
  }

}

public final class MarkingNode<Place>: GraphNode where Place: CaseIterable & Hashable {

  /// Initializes a node with a marking and an optional mapping of successors.
  public init(marking: Marking<Place, Int>, successors: [Transition<Place>: MarkingNode] = [:]) {
    self.marking = marking
    self.successors = successors
  }

  /// The marking associated with the node.
  public let marking: Marking<Place, Int>
  /// The successors of the node.
  public var successors: [Transition<Place>: MarkingNode]

}

public final class CoverabilityNode<Place>: GraphNode where Place: CaseIterable & Hashable {

  /// Initializes a node with a marking and an optional mapping of successors.
  public init(
    marking: Marking<Place, ExtendedInt>, successors: [Transition<Place>: CoverabilityNode] = [:])
  {
    self.marking = marking
    self.successors = successors
  }

  /// The marking associated with the node.
  public let marking: Marking<Place, ExtendedInt>
  /// The successors of the node.
  public var successors: [Transition<Place>: CoverabilityNode]

}
