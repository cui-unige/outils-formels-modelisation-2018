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
      for place in preconditions {
        switch preconditions[place.key]! {
        case .inhibitor: //si arc inhibiteur
            if (marking[place.key]! != 0) { //si marquage n'est pas égal à 0, transition non tirable.
              return false
            }
          case .regular(let arcValue):
            if (marking[place.key]! < arcValue) {//si marquage inférieur à valeur de l'arc (précondition), alors non tirable.
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
      // Write your code here.
      if (self.isFireable(from: marking)) {
        var newMarking = marking //initialiser nouveau marquage avec valeurs du marquage en question.
        for place in preconditions {
          switch preconditions[place.key]! {
            case .regular(let arcValue):
              newMarking[place.key]! = newMarking[place.key]! - arcValue
              break
            case .inhibitor:
              break
          }
        }

        for place in postconditions {
          switch postconditions[place.key]! {
            case .regular(let arcValue):
              newMarking[place.key]! = newMarking[place.key]! + arcValue
              break
            case .inhibitor:
              break
          }
        }
        return newMarking
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
