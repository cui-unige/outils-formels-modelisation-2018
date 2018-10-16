/*
------------------------------------------------------------------------------
# NAME : PetriNet.swift
#
# PURPOSE : Implementation of a Petri's network
#
# AUTHOR : Benjamin Fischer
#
# CREATED : 12.10.2018
-----------------------------------------------------------------------------
*/

// Natural number
public typealias Nat = UInt
// Marking
public typealias Marking = (Place) -> Nat
// Petri's network structure
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

  // Finite set of places
  public let places: Set<Place>
  // Finite set of transitions
  public let transitions: Set<Transition>
  // Function describing the preconditions of the Petri's network
  public let pre: (Place, Transition) -> Nat
  // Function describing the postconditions of the Petri's network
  public let post: (Place, Transition) -> Nat

  /*
  ------------------------------------------------------------------------------
  METHOD : isFireable(_ transition: Transition, from marking: Marking) -> Bool

  PURPOSE : Returns a boolean value depending on whether a transition is
            fireable from a given marking

  INPUT : transition: Transition, marking: Marking

  OUTPUT : TRUE if transition is firable, FALSE if it is not
  -----------------------------------------------------------------------------
  */
  public func isFireable(_ transition: Transition, from marking: Marking) -> Bool {

    var result:Bool = true

    for place in places  { // For all places : M(place) >= E(place,transition)
      if marking(place)  < pre(place, transition) {
        result = false
        break // Exit the loop
      }
    }

    return result
  }

  /*
  ------------------------------------------------------------------------------
  METHOD : fire(_ transition: Transition, from marking: @escaping Marking) -> Marking?

  PURPOSE : Fires a transition from a given marking. If the transition is fireable
            from the given marking, the method returns the new marking, otherwise
            it returns a nil value

  INPUT : transition: Transition, marking: @escaping Marking

  OUTPUT : New marking if transition is firable, nil if it is not
  -----------------------------------------------------------------------------
  */
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {

    // For all places ($0) : NewMarking(p) = initMarking(p) - E(p,t) + S(p,t)
    if self.isFireable(transition, from: marking) {
      return {marking($0) - self.pre($0, transition) + self.post($0, transition)}
    }

    return nil // No fire
  }

  // Printing marking function
  public func print(marking: Marking) {
    for place in places.sorted() {
      Swift.print("\(place.name) → \(marking(place))")
    }
  }

  // Incidence matrix of the Petri's network
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

  // Function returning the characteristic vector of a transition sequence
  func characteristicVector<S>(of sequence: S) -> [Int] where S: Sequence, S.Element == Transition {
    let index: [Transition: Int] = Dictionary(
      uniqueKeysWithValues: transitions.sorted().enumerated().map({ ($1, $0) }))
    var result: [Int] = Array(repeating: 0, count: transitions.count)

    for transition in sequence {
      result[index[transition]!] += 1
    }

    return result
  }

  // Function returning a marking as a vector
  func markingVector(_ marking: Marking) -> [Int] {
    return places.sorted().map { Int(marking($0)) }
  }

}

// Place
public struct Place: Comparable, Hashable {

  public init(_ name: String) {
    self.name = name
  }

  public let name: String

  public static func < (lhs: Place, rhs: Place) -> Bool {
    return lhs.name < rhs.name
  }

}

// Transition
public struct Transition: Comparable, Hashable {

  public init(_ name: String) {
    self.name = name
  }

  public let name: String

  public static func < (lhs: Transition, rhs: Transition) -> Bool {
    return lhs.name < rhs.name
  }

}
