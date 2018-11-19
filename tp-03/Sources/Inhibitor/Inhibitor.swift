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
    public let preconditions: [Place: Arc] //: car c'est le type de la variable pas assigné,
    // Array car il y a des brackets
    // Place est un type c'est un Hashable qui prend des arcs (comme si c'était int)
    public let postconditions: [Place: Arc]

    /// A method that returns whether a transition is fireable from a given marking.
    public func isFireable(from marking: [Place: Int]) -> Bool {
      // Test pour chaque place (arc) dans les préconditions
      for places in preconditions{
      //Places peut avoir n'importe quel nom
      //Déterminer le type de l'arc
        switch preconditions[places.key]! {

          //Si c'est un arc régulier
          case .regular(let value):
              //Value = la valeur associée à l'arc
              //Alors si le poids de l'arc est plus grand que le nombre de jetons de la place
              //La transition n'est pas tirable
              if marking[places.key]! < value {
                //! car c'est un unary postfix operator solo du ghetto
              return false              }

          //Si c'est un inhibiteur
          case .inhibitor:
            //Alors si la place n'est pas vide la transition n'est pas tirable
            if marking[places.key] != 0 {
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
      if isFireable(from: marking){ //== true
      var newMarking = marking // retourne le marking
      for place in preconditions{
      switch preconditions[place.key]! {
      //Si c'est un arc régulier on enlève à la place concernée le poids de l'arc
      case .regular(let value):
        newMarking[place.key]! -= value
      //Aucun changement sur la place car c'est une transition de type inhibiteur
      case .inhibitor:
          break
       }
      }

      for place in postconditions{
        switch postconditions[place.key]! {
        //Si c'est un arc régulier à l'inverse des préconditions on rajouter à
        //la place en question e poids de l'arc
        case .regular(let value):
          newMarking[place.key]! += value

        //Vu que c'est un inhibiteur rien ne change donc on break
        case .inhibitor:
          break
          }
        }
      return newMarking //retourne le nouveau marquage
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
