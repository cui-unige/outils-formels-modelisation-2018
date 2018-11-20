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
      for place in preconditions {    // on parcourt les places des preconditions
        switch preconditions[place.key]! {
        case .regular(let value): // si on a un arc regulier
            // value = "valeur de l'arc regulier de la precondition"
            if marking[place.key]! < value { // marquage precondition
              return false
            }
          case .inhibitor: // si on a un arc inhibitor
            if marking[place.key] != 0 { // marquage precondition
              return false
            }
          }
        }
      return true // marquage est tirable
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
      if isFireable(from: marking) { // on verifie si le marquage actuel est tirable
        var newMarking = marking // arrete le marquage
        for place in preconditions { // boucle sur preconditions
          switch preconditions[place.key]! {
            case .regular(let value): // si on a un arc regulier
              // value = "valeur de l'arc regulier de la precondition"
              newMarking[place.key]! -= value
              break // on quitte la boucle
            case .inhibitor: // si on a un arc inhibitor
              // on tire
              break // on quitte la boucle
          }
        }
        for place in postconditions { // loop on places of postconditions
          switch postconditions[place.key]! {
            case .regular(let value): // si on a un arc regulier
              // value = "valeur de l'arc regulier de la precondition"
              newMarking[place.key]! += value
              break // on quitte la boucle
            case .inhibitor: // si on a un arc inhibitor
              // on tire
              break // on quitte la boucle
          }
        }
        // nouveau marquage après avoir tiré
        return newMarking
      }
        // nil sinon
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
