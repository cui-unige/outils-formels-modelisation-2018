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

        for place in preconditions {
          switch preconditions[place.key]! {
          case .regular(let ValueArc):
              if marking[place.key]! < ValueArc { // nombre de jetons ds place < poids de l'arc
                print(" Arc non tirable")
                return false
              }
            case .inhibitor:
              if marking[place.key] != 0 { // !
                print(" Arc non tirable")
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

       if isFireable(from: marking){
         var nextMarking = marking

         //Les préconditions
         for place in preconditions {
           switch preconditions[place.key]! {
             case .inhibitor:
               break
             case .regular(let arcValue):
               nextMarking[place.key]! -= arcValue
           }
         }
         //Les postconditions
         for place in postconditions{
           switch postconditions[place.key]! {
             case .regular(let arcValue):
               nextMarking[place.key]! += arcValue
             case .inhibitor:
               break
             }
         }
         return nextMarking
       }
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
