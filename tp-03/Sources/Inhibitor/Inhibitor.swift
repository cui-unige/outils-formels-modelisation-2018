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
      for place in preconditions { // On parcourt toutes les places dans nos précontditions
        switch preconditions[place.key]! { // On va maintenant s'intéresser aux arcs
        case .inhibitor: // Cas le plus simple, il s'agit d'un arc inhibiteur
          if marking[place.key] != 0 { // Si il y a des jetons dans le marquage
            return false // Alors la transition n'est pas tirable
          }
        case .regular(let nbrJetons): // Cas où c'est un arc à l'ancienne
          if marking[place.key]! < nbrJetons { // Si il y a moins de jetons dans la place que de jetons demandés
                         return false // Alors, à nouveau, la transition n'est pas tirable
                     }
        }
      }
      return true // Si tout a fonctionné jusque ici, c'est que la transition est tirable
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      if isFireable(from: marking) { // Test si la transition est tirable
        var resultMarking = marking // On crée une variable à partir de notre marking pour stocker le marquage résultant que l'on retournera
        for place in preconditions { // On va maintenant update les préconditions, que l'on parcourt
          switch preconditions[place.key]! { // On rentre dans les arcs
          case .inhibitor: // Cas le plus simple où c'est un arc inhibiteur : on laisse juste la transition être tirée
            break
                    case .regular(let nbrJetons): // Si en revanche c'est un arc classique :
            resultMarking[place.key]! -= nbrJetons // On enlève les jetons demandés pour que la transition soit tirée
            break
          }
        }
         for place in postconditions { // On va maintenant update les postconditions
          switch postconditions[place.key]! { // On rentre dans les arcs
          case .inhibitor: // Si c'est un inhibiteur on ne fait rien
            break
                    case .regular(let nbrJetons): // Sinon on rajoute les jetons produits lors de la transition
            resultMarking[place.key]! += nbrJetons
                        break
          }
        }
         return resultMarking // On retourne le marquage résultant
      }
      return nil // Si la transition n'est pas tirable on retourne nil
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
