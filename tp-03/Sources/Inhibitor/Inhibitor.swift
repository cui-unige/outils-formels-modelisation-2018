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
      for (p, arc) in preconditions{
        switch arc {
          case let .regular(entre):
            if(marking[p]!  < entre){return false}
          case .inhibitor:
            if(marking[p]!  != 0){return false}
          }
      }
      return true
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      if(isFireable(from: marking)){
        var result_marking = marking
        for (p, arc) in preconditions{
          if case let .regular(entre) = arc{
              result_marking[p]! -= entre
          }
        }
        for (p, arc) in postconditions{
            if case let .regular(sortie) = arc{
                result_marking[p]! += sortie
            }
        }
        return result_marking
      }else{return nil}
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
