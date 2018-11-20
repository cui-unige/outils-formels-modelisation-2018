public struct InhibitorNet<Place> where Place: Hashable {

  /// Struct that represents an transition of a Petri net extended with inhibitor arcs.
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
        for (place, arc) in preconditions {
            switch arc {
            case .regular(let value):
                if (marking[place]! >= value) {
                    return true
                }
            case .inhibitor:
                if (marking[place]! == 0) {
                    return true
                }
            }
        }
        return false
    }
    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
        var NextMarking = marking
        if self.isFireable(from: marking) {
            for (place, arc) in postconditions {
                switch arc {
                case .regular(let value):
                    NextMarking[place]! = NextMarking[place]! + value
                case .inhibitor:
                    break
                }
            }
            for (place, arc) in preconditions {
                switch arc {
                case .regular(let value):
                    NextMarking[place]! = NextMarking[place]! - value
                case .inhibitor:
                    break

                }
            }
            return NextMarking
        }
        else{
            return nil
        }
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
