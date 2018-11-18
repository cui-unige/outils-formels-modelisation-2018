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

      for place in preconditions{ // Pour les places préconditions
      switch preconditions[place.key]! {
      case .regular(let value): //Si c'est un arc régulier
          if marking[place.key]! < value { //Si le poids de l'arc et plus grand que le nombre de jetons de la place
            return false // Alors c'est non tirable
          }
        case .inhibitor: // Si c'est un inhibiteur
          if marking[place.key] != 0 { // Si une place est non vide
            return false // Alors c'est non tirable
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

     if isFireable(from: marking){ //Si c'est tirable
       var newMarking = marking //On met le marquage reçu dans newmarking
       //precondition
       for place in preconditions { // Pour toutes les préconditions
         switch preconditions[place.key]! {
         case .regular(let value): // Si c'est un arc régulier
           newMarking[place.key]! -= value // On enlève à la place le poids de l'arc
         case .inhibitor: // Sauf si on a un inhibiteur
             break
         }
       }

       for place in postconditions{ // Pour toutes les postconditions
         switch postconditions[place.key]! {
         case .regular(let value): // Si c'est un arc régulier
           newMarking[place.key]! += value // On ajoute à la place le poids de l'arc
         case .inhibitor: // Sauf si on a un inhibiteur
             break
         }
       }
        return newMarking // Si c'est tirable on retourne le nouveau marquage
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
