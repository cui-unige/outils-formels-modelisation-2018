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
    var tirable:Bool = true

    for placeX in places{
        if (marking(placeX) >= pre(placeX, transition)) == false {
          tirable = false
        }
    }

    return tirable
  }

  /// A method that fires a transition from a given marking.
  ///
  /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
  /// otherwise it returns the new marking.
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {

    if isFireable(transition, from: marking){
      var newMarking: [Place:Nat] = [:]

      for placeX in places {
        let tempToken = post(placeX, transition)

        if tempToken > 0 {
          newMarking[Place(placeX.name)] = marking(placeX) + tempToken
        }else {
          newMarking[Place(placeX.name)] = marking(placeX)
        }
      }

      for placeX in places {
        let tempToken = pre(placeX, transition)

        if tempToken > 0 {
          newMarking[Place(placeX.name)] = Nat(newMarking[Place(placeX.name)]!) - tempToken
        }
      }

      func markingTemp(_ place: Place) -> Nat {
        let markingEnd: [Place:Nat] = newMarking
        return markingEnd[place]!
        }

      return markingTemp
    }else {
      return nil
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
