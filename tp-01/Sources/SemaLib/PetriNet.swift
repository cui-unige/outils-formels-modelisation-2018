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
    // on fait une boucle qui parcours toutes les places
    for place in places {
    // si il y a pas assez de boules dans la place pour franchir l'etape , si il y en a pas assez on arrête le programme et on renvoie false
    // si au contraire il y en a assez on continue jusqu'a voir si la transition est franchissable et et quand la fonction sort de la boucle
    // alors touts les marquages ont assez de balles pour franchir la transition et la fonction renvoie true
    if marking(place) < pre(place , transition){
        return false}
    else {
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
// la fonction sert à franchir la transition si elle est franchissable et dans le cas contraire retourne rien
// d'abord on fait appelle a la fonction isFireable et si elle est fausse on retourne rien , mais si elle est vraie
// on retourne le marking de tout les points - les preconditions(ceux qu'on a retirer apres avoir franchis la transition)  + les post transitions(ceux qu'on ajoute après avoir franchis la trnasition)
  if (!isFireable(transition, from: marking) )
  {
    return nil
  }

  else
  {
    return {marking($0) - self.pre($0, transition) + self.post($0, transition)}
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
