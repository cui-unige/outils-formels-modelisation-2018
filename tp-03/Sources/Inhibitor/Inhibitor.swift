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

      for place in preconditions{ //On boucle sur les arcs
          switch preconditions[place.key]! { //On boucle sur les préconditions des arcs
          case .regular(let value): //Si c'est un arc normal, on récupère la valeur de l'arc
              if marking[place.key]! < value { //Si la précondition (valeur de l'arc) est plus grande que le nombre de jetons dans la place c'est non tirable
                return false
              }
            case .inhibitor: //Si c'est un inhibiteur
              if marking[place.key] != 0 { //Si une place est non vide, ce n'est pas tirable
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
      if isFireable(from: marking){ //Si c'est tirable
        var newMarking = marking //On met le marquage reçu dans newmarking
        //precondition
        for place in preconditions { //On itère sur les arcs préconditions
          switch preconditions[place.key]! { //!Pour pouvoir avoir la valeur nulle
          case .regular(let value): //Si c'est un arc régulier (une précondition)
            newMarking[place.key]! -= value //On enlève au marking, pour la place définie la valeur de la précondition
          case .inhibitor: //On ne change pas la place quand c'est un arc inhibiteur
              break
          }
        }
          //postcondition
        for place in postconditions{ //On itère sur les arcs postconditions
          switch postconditions[place.key]! { //!Pour pouvoir avoir la valeur nulle
            case .regular(let value):
            newMarking[place.key]! += value //On ajoute au marking, pour la place définie la valeur de la postcondition
          case .inhibitor: //On ne change pas la place quand c'est un arc inhibiteur
              break
          }
        }
         return newMarking
      }
      return nil //si ce n'est pas tirable on retourne nil
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
