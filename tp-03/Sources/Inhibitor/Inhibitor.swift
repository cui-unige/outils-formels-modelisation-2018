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
      for (place, arc) in preconditions { //On parcours toutes les places d'entrée
        switch arc{
          case .inhibitor: //Si l'arc partant de la place "place" est un arc inhibiteur
            if marking[place]! != 0{ //Si le marquage de la place "place" est différent de 0
              return false // on renvoit false
            }

          case .regular(let valArc): //Si l'arc partant de la place "place" est un arc régulier
            if marking[place]! < valArc { //Si le marquage de la place "place" est inférieur au poids de l'arc régulier
              return false //on renvoit false
            }
        }
      }

      return true //autrement on renvoie vrai
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      var resultat = marking

      if self.isFireable(from: marking){ //Si on peut tirer, on calcule le prochain marquage

        for (place, arc) in preconditions {
          switch arc {
            case .regular(let valArc):
              resultat[place]! -= valArc

            case .inhibitor:
              break
            }

        }

        for (place, arc) in postconditions {
          switch arc {
            case .regular(let valArc):
              resultat[place]! += valArc
              
            case .inhibitor:
              break
          }
        }
        return resultat
      }

      else {
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
