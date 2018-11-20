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
      for (place, arc) in self.preconditions { // On parcourt les places de preconditions
        switch arc {                           // Si l'arc d'une place
        case .regular(Int: let x):             // est normal
          if x > marking[place]! {             // Alors on vérifie si son poids est strictement supérieur au marquage à la place 'place'
            return false                       // Si c'est le cas alors la transition n'est pas tirable
          }
        case .inhibitor:                       // Si l'arc est inhibiteur
          if marking[place] != 0 {             // Alors si le marquage à la place 'place' est différent de 0
            return false                       // Si c'est le cas alors la transition n'est pas tirable
          }
        }
      }

      return true                              // Sinon la transition est bien tirable
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
      if (isFireable(from: marking) == false) { // Si la transition n'est pas tirable
        return nil                              // On retourne nil
      }

      var newMarking: [Place: Int] = marking    // Si elle est tirable alors on initialise le nouveau marquage au marquage présent
      for (place, arc) in self.preconditions {  // On parcourt les places des préconditions
        switch arc {                            // Si l'arc d'une place
        case .regular(Int: let x):              // est normal
          newMarking[place]! -=  x              // alors on soustrait au nouveau marquage à la place 'place' la valeur x de l'arc
        case .inhibitor:                        // Si l'arc est inhibiteur
          continue                              // on continue la boucle
        }
      }
      for (place, arc) in self.postconditions { // On parcourt ensuite les places des postconditions
        switch arc {                            // Si l'arc d'une place
        case .regular(Int: let x):              // est normale
          newMarking[place]! += x               // alors on rajoute au nouveau marquage à la place 'place' la valeur x de l'arc
        case .inhibitor:                        // Si l'arc est inhibiteur
          continue                              // on continue la boucle
        }
      }

      return newMarking                         // On retourne finalement le nouveau marquage
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
