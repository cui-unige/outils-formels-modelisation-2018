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
      // Write your code here.
      // For all pairs of place and arcs in precondition.
      for (p, a) in preconditions{
            switch a {
            case .inhibitor: // If the arc is inhibitor.
                if(marking[p]! != 0){ // If the place is not worth 0 then the transition is not fireable.
                    return false
                }
            case .regular(let v)://If the arc is not regular.
                if !(marking[p]! >= v){// If all the places do not have a
                    return false //number of tokens greater or equal to the weight of the arcs
                } //then the transition is not fireable.
            }
        }
        return true //Else it is fireable.
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
      if isFireable(from: marking){ //If the transition is fireable, we can calculate the new marking.
    var new = marking
    for (p, a) in preconditions {
        switch a{
        case .regular(let v): //If the arc is not inhibitor.
                new[p]! -= v //Subs to the marking.
            case .inhibitor: //If it is.
                break //Fires the transition.
        }
    }

    for (p, a) in postconditions {// Same but for the postconditions.
        switch a{
        case .regular(let v):
            new[p]! += v //This time it adds to the marking.
        case .inhibitor:
            break
        }
    }

    return new //It returns the new marking.
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
