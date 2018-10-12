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
    // Write your code here.
    var test = true                                       // On initialise une variable à true
    for place in places.sorted() {                        // On parcourt les places du réseau de Petri
      if (marking(place) < pre(place, transition)) {      // Si le marquage à la place i est strictement plus petit que l'entrée à la place i et à la transition donnée
        test = false                                      // On modifie test à false
      }
    }
    if test == true {                                     // Si test vaut true
      return true                                         // On retourne true, la transition est tirable
    }
    return false                                          // Sinon on retourne false, la transition n'est pas tirable
  }

  /// A method that fires a transition from a given marking.
  ///
  /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
  /// otherwise it returns the new marking.
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {
    // Write your code here.
    if (isFireable(transition, from: marking) == false) {  // Si la transition n'est pas tirable
      return nil                                           // On retourne nil
    }

    func markingPrime(_ placeprime: Place) -> Nat {        // On définit la nouvelle fonction markingPrime selon la formule donnée en cours
      if ((marking(placeprime) - pre(placeprime, transition) + post(placeprime,transition)) > 0) {  // Si la valeur de la formule donnée en cours
        return (marking(placeprime) - pre(placeprime, transition) + post(placeprime,transition))    // On la retourne
      }
      return 0                                             // Sinon on retourne 0 car on ne veut pas de marquage négatif
    }
    return markingPrime                                    // On retourne la fonction markingPrime
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
