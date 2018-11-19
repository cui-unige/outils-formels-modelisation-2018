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
    for place in preconditions {    // loop on places of preconditions
        switch preconditions[place.key]! {

          case .regular(let value): // case of regular arc
                      // value == regular arc precondition value
            if marking[place.key]! < value {
                        // regular arc precondition value > marking of precondition place
              return false
            }

          case .inhibitor: // case of inhibitor arc
            if marking[place.key] != 0 {
              // marking of precondition place is not empty
              return false
            }

          }
        }
      // given marking is fireable
      return true
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
        if isFireable(from: marking) { // check if the given marking if fireable
          var newMarking = marking // store the current marking
          for place in preconditions { // loop on places of preconditions
            switch preconditions[place.key]! {

  					case .regular(let value): // case of regular arc
              // value == regular arc precondition value
              // fire transition : substract regular arc precondition value from marking of precondition place
              newMarking[place.key]! -= value
  						break // exit loop
  					case .inhibitor: // case of inhibitor arc
              // fire
              break // exit loop
            }
          }

          for place in postconditions { // loop on places of postconditions
            switch postconditions[place.key]! {

    					case .regular(let value): // case of regular arc
                // value == regular arc precondition value
                // fire transition : add regular arc postcondition value to marking of postcondition place
                newMarking[place.key]! += value
    						break // exit loop
    					case .inhibitor: // case of inhibitor arc
                // fire
                break // exit loop
            }

          }
          // new marking after firing
          return newMarking
        }
        // nil otherwise
        return nil
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
