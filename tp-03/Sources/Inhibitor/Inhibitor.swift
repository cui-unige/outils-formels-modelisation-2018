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
      var Fireable = true;                    /// Set default return to true
      var Break = false;                      /// Set break to false
      for (transition, arc) in preconditions {    /// iterate over transitions and arcs and of preconditions
        if (!Break) {
          switch(arc) {                           /// swithing over arc to get if it's an regular or inhibitor
          case .regular(let value):              /// regular case
            if (marking[transition]! < value) {  /// if the marking of the transition is smaller than the value then the transition is not fireable will return false
              Fireable = false;
              Break = true;                      /// not fireable set break to true
              break;
            }
          case .inhibitor:                      /// inhibitor case
            if (marking[transition]! != 0) {    /// if the marking of the transition isn't null then the transition is not fireable will return false
              Fireable = false;
              Break = true;                     /// not fireable set break to true
              break;
            }
          }
        }
        else {
          break;                                /// break for loop
        }
      }
      return Fireable;                          /// return Fireable boolean that contains the value if this marking is fireable
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      if(self.isFireable(from: marking)) {          /// if marking is fireable
        var markingToReturn = marking;               /// copy of the marking otherwise we shouldn't change the value of the marking
        for (transition, arc) in preconditions {     /// iterate over transitions and arcs and of preconditions
            switch (arc) {                           /// swithing over arc to get if it's an regular or inhibitor
            case .regular(let value):                /// regular case
                   markingToReturn[transition]! = markingToReturn[transition]! - value; /// increase the marking at the transition
             default:                                /// nothing to do on other case
                 break;
             }
        }
        for (transition, arc) in postconditions {   /// iterate over transitions and arcs and of postconditions
          switch(arc) {                             /// swithing over arc to get if it's an regular or inhibitor
          case .regular(let value):                 /// regular case
            markingToReturn[transition]! = markingToReturn[transition]! + value; /// increase the marking at the transition
          default:                                  /// nothing to do on other case
              break;
          }
        }
        return markingToReturn;                     /// returning the marking
      }
      return nil;                                   /// if not fireable then null is returned
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
