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
      for (place,arc) in self.preconditions //for all the places and arc in the preconditions
      {
        switch arc  //for each arc of either type
        {
          case .inhibitor:  //if the arc is of type inhibitor
            if (marking[place] != 0)  //if the marking has something other than 0 tokens
            {
              return false  //return false
            }
          case .regular(let tokens):  //else if regular arc, dewraps the number of tokens on the arc
            //the ! here is not a NOT, but an optional, as Int must be unwrapped as it is an Int? returned
            if (marking[place]! < tokens) //if the number of tokens in the place for the given marking is less than the condition
            {
              return false  //return false
            }
        }
      }
      return true //otherwise the transition can be fired and true is returned
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
      //return nil
      if self.isFireable(from: marking)
      {
        var newMarking: [Place: Int] = marking
        for (place, arc) in self.preconditions
        {
          switch arc
          {
            case .inhibitor:  //as the isFireable already checks if the transition is fireable, there is nothing to do here
                continue
            case .regular(let tokens): //else if regular arc, dewraps the number of tokens on the arc, and removes them from the current place (for loop)
              newMarking[place]! -= tokens
          }
        }

        for (place, arc) in self.postconditions
        {
          switch arc
          {
            case .inhibitor:  //nothing to do here, basically just checks that the place is empty (from isFireable), so no token moving
                continue
            case .regular(let tokens): //else if regular arc, dewraps the number of tokens on the arc, and adds them to the the current place (for loop)
              newMarking[place]! += tokens
          }
        }
        return newMarking
      }
      else
      {
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
