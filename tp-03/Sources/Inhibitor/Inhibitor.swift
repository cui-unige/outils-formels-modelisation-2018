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
      // Similaire au tp-01:
      // Pour toutes les places de préconditions ne sera pas tirable si:
      // 1. l'arc est inhibiteur et non-null
      // 2. l'arc est normal et que le poids est supérieur au marquage
      // sinon la transition est tirable
      for ( place, arc ) in self.preconditions {
        switch arc {
        case .inhibitor:
          if marking[place] != 0 {
            return false
          }

        case .regular( Int: let x ):
          if marking[place]! < x {
            return false
          }
        // default:
        //   print( "Problem" )
        }
      }
      return true
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Similaire à tp-01 :
      // Si transition non tirable on retourne nil :
      if( isFireable(from: marking) == false ) {
        return nil
      }

      // Si transition est tirable :
      // On créer un marquage temporaire puis on regarde les pre et post conditions
      // sur toutes les places en vérifiant les arcs inhibiteur et normaux :
      var markingTmp: [ Place: Int ] = marking

      // pré conditions :
      // si arc inhibiteur on continue
      // si arc normal on enleve un marquage
      for ( place, arc ) in self.preconditions {
          switch arc {
          case .inhibitor:
            continue
          case .regular( Int: let x ):
            markingTmp[place]! -= x
          }
      }

      // post conditions :
      // si arc inhibiteur on continue
      // si arc normal on ajoute un marquage
      for ( place, arc ) in self.postconditions {
          switch arc {
          case .inhibitor:
            continue
          case .regular( Int: let x ):
            markingTmp[place]! += x
          }
      }
      return markingTmp //on retourne le marquage temporaire
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
