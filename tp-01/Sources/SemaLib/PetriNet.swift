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

  /// A method that returns whether a transition is fireable from a given marking.
  public func isFireable(_ transition: Transition, from marking: Marking) -> Bool {
    for place in places {
      if marking(place) < pre(place,transition)
      {
        return false
      } else {
        continue
      }
    }
    return true
  }

  /// A method that fires a transition from a given marking.
  ///
  /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
  /// otherwise it returns the new marking.
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {
    // Create a new marking
    var newMarking: Marking = marking;
    // If the transition is not fireable from the given marking, nil is returned
    if (!isFireable(transition, from: marking) )
    {
      return nil
    }
    // If it is fireable, we subtract the tokens in the preconditions and add new tokens in the postconditions.
    // Then the new marking is returned.
    else
    {
      for place in places {
        newMarking(place) = marking(place) - pre(place,transition) + post(place,transition);
      }
      return newMarking;
    }
  }

  /// A helper function to print markings.
  public func print(marking: Marking) {
    for place in places.sorted() {
      Swift.print("\(place.name) → \(marking(place))")
    }
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
