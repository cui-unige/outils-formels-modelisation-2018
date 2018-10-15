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

  /// The function returns if a transition is fireable from a given marking.
  public func isFireable(_ transition: Transition, from marking: Marking) -> Bool {
      // Write your code here./
      for place in places.sorted() { //We sort places in order.
        if pre(place, transition)>marking(place){ //If a place does not have enough tokens to pass the arcs.
          return false //Then we consider that the transition is not fireable.
        }
      }
      return true //If there is no place that can not cross their arc, then the transition is fireable.
    }

  /// A method that fires a transition from a given marking.
  ///
  /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
  /// otherwise it returns the new marking.
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {
      // Write your code here.
      if isFireable(transition, from: marking)==false{ // If the transition is not fireable.
      return nil //If it is false, then it is not fireable, so it returns nothing.
    }
        else {//Else it is fireable, so we can return the next transition.
          func newmark(_ place: Place) -> Nat { //We create an intermediate function that proceeds to the transition.
            return marking(place)+post(place, transition)-pre(place, transition) //Then we return the transition formula.
          }
        return newmark //We return our function that applies to all places.
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
