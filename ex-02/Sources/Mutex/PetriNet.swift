/// A natural number.
public typealias Nat = UInt
/// A marking.
public typealias Marking = (Place) -> Nat

/// A Petri net structure.
public struct PetriNet {

  public init(
    places: Set<Place>,
    transitions: Set<Transition>,
    pre: @escaping (Place, Transition) -> Nat,
    post: @escaping (Place, Transition) -> Nat)
  {
    self.places = places
    self.transitions = transitions
    self.pre = pre
    self.post = post
  }

  /// A finite set of places.
  public let places: Set<Place>
  /// A finite set of transitions.
  public let transitions: Set<Transition>
  /// A function that describes the preconditions of the Petri net.
  public let pre: (Place, Transition) -> Nat
  /// A function that describes the postconditions of the Petri net.
  public let post: (Place, Transition) -> Nat

  /// A helper function to print markings.
  public func print(marking: Marking) {
    for place in places.sorted() {
      Swift.print("\(place.name) → \(marking(place))")
    }
  }

  /// The incidence matrix of the Petri net.
  public var incidenceMatrix: [[Int]] {
    var matrix: [[Int]] = Array(
      repeating: Array(repeating: 0, count: transitions.count),
      count: places.count)

    for (p, place) in places.sorted().enumerated() {
      for (t, transition) in transitions.sorted().enumerated() {
        matrix[p][t] = Int(post(place, transition)) - Int(pre(place, transition))
      }
    }

    return matrix
  }

  /// Returns the characteristic vector of a transition sequence.
  func characteristicVector<S>(of sequence: S) -> [Int] where S: Sequence, S.Element == Transition {
    let index: [Transition: Int] = Dictionary(
      uniqueKeysWithValues: transitions.sorted().enumerated().map({ ($1, $0) }))
    var result: [Int] = Array(repeating: 0, count: transitions.count)

    for transition in sequence {
      result[index[transition]!] += 1
    }

    return result
  }

  /// Returns a marking as a vector.
  func markingVector(_ marking: Marking) -> [Int] {
    return places.sorted().map { Int(marking($0)) }
  }

}

/// A place.
public struct Place: Comparable, Hashable {

  public init(_ name: String) {
    self.name = name
  }

  public let name: String

  public static func < (lhs: Place, rhs: Place) -> Bool {
    return lhs.name < rhs.name
  }

}

/// A transition.
public struct Transition: Comparable, Hashable {

  public init(_ name: String) {
    self.name = name
  }

  public let name: String

  public static func < (lhs: Transition, rhs: Transition) -> Bool {
    return lhs.name < rhs.name
  }

}

func + (lhs: [Int], rhs: [Int]) -> [Int] {
  return zip(lhs, rhs).map { $0 + $1 }
}

func * (lhs: [[Int]], rhs: [Int]) -> [Int]{
  var result = Array(repeating: 0, count: lhs.count)
  for p in 0 ..< lhs.count {
    for t in 0 ..< lhs[p].count {
      result[p] += lhs[p][t] * rhs[t]
    }
  }
  return result
}
