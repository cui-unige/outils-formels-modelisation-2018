public struct InhibitorNet<Place> where Place: Hashable {

  /// Struct that represents a transition of a Petri net extended with inhibitor arcs.
  public struct Transition: Hashable {

    public init(name: String, pre: [Place: Arc], post: [Place: Arc]) {
      for (_, arc) in post {
        guard case .regular = arc
          else { preconditionFailure() }
      }

      self.name = name
      self.preconditions = pre
      self.postconditions = post
    }

    public let name: String
    public let preconditions: [Place: Arc]
    public let postconditions: [Place: Arc]

    /// A method that returns whether a transition is fireable from a given marking.
    public func isFireable(from marking: [Place: Int]) -> Bool {
      // inspiré d'un bout de code que j'ai vu ailleurs
      for (place, arc) in self.preconditions {
        switch(arc) {
        case let .regular(arc: arc):
          guard marking[place]! >= arc else { return false } // arc normal: on vérifie qu'il y a suffisamment de jetons dans la place
        case .inhibitor:
          guard marking[place]! == 0 else { return false } // arc inhibiteur: on vérifie qu'il n'y a pas de jetons dans la place
        }
      }

      return true
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // insipiré d'un bout de code que j'ai vu ailleurs
      guard self.isFireable(from: marking) else { return nil }

      var new_marking = marking

      for (place, arc) in self.preconditions { // on applique les préconditions
        switch(arc) {
          case let .regular(arc: arc):
            new_marking[place] = marking[place]! - arc // le marking moins la precondition
          default:
            break
        }
      }

      for (place, arc) in self.postconditions { // on applique les postconditions
        switch(arc) {
          case let .regular(arc: arc):
            new_marking[place] = new_marking[place]! + arc // le marking (actuel) plus la postcondition
          default:
            break
        }
      }

      return new_marking
    }

  }

  /// Struct that represents an arc of a Petri net extended with inhibitor arcs.
  public enum Arc: Hashable {

    case inhibitor
    case regular(Int)

  }

  public init(places: Set<Place>, transitions: Set<Transition>) {
    self.places = places
    self.transitions = transitions
  }

  public let places: Set<Place>
  public let transitions: Set<Transition>

}
