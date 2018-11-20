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
      // If the transition doesn't have an inhibitor arc, we treat it as a classical Petri net transition:
      for (pl, precondArc) in preconditions
      {
        switch precondArc
        // There are two cases here: either it's an inhibitor arc,
        // or it's a normal arc. In the former case, the transition is 
        // fireable given that the marking of the preceding place is 0.
        // In the latter case, we treat it as a classical Petri net transition.
        {
          case .regular(let precond): // precond is the number of tokens removed by the firing
            if (marking[pl]! < precond) // ! because optional
            {
              return false
            }

          case .inhibitor:
            if (marking[pl] != 0)
            {
              return false
            }
          }
        }
        return true
      }
        



    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // check if transition is fireable
      if (!isFireable(from: marking))
      {
        return nil
      } else {
        var myMarking : [Place:Int] = marking
        // We can have inhibitor arcs as preconditions or postconditions.
        // That's why we treat preconditions and postconditions as two separate cases:
        
        // preconditions
        for (pl, precondArc) in self.preconditions {
          switch precondArc {
            case .regular(let precond):
              myMarking[pl]! = myMarking[pl]! - precond
            case .inhibitor:
              continue
           }
         }


        // postconditions
        for (pl, postcondArc) in self.postconditions {
          switch postcondArc {
            case .regular(let postcond):
              myMarking[pl]! = myMarking[pl]! + postcond
            case .inhibitor:
              continue
           }
         }
        

        return myMarking
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
