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

      //pour chaque place contenue dans les préconditions de la place ciblée
      for place in preconditions{
        switch preconditions[place.key]! {
          //si la place est liée par un ihnibiteur
          case .inhibitor:
            //la transition est tirable que si le marquage est nul
            if marking[place.key]! != 0 {
              return false
            }
          //si la place n'est pas liée par un ihnibiteur
          case .regular(let val):
              //la place est tirable si le marquage est supérieur à la valeur englobée dans l'arc
              if marking[place.key]! < val {
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

      //si la transition est tirable depuis le marquage choisi:
      //le nouveau marquage se contruit de la sorte : marquage choisi + entrées + sorties
      if isFireable(from: marking){
        //on crée le nouveau marquage en l'initialisant avec les valeurs du marquage choisi
        var marquageResultant = marking

        //pour chaque place ayant des préconditions,
        //on construit le nouveau marquage en soustrayant la valeur contenue
        // dans l'arc de précondition à la valeur initalement contenue dans la place
        for place in preconditions {
          switch preconditions[place.key]! {
            case .regular(let val):
              marquageResultant[place.key]! -= val
            case .inhibitor:
              break
          }
        }

        //pour chaque place ayant des postconditions,
        //on construit le nouveau marquage en additionnant la valeur contenue
        // dans l'arc de postcondition à la valeur initalement contenue dans la place
        for place in postconditions {
          switch postconditions[place.key]! {
            case .regular(let val):
              marquageResultant[place.key]! += val
            case .inhibitor:
              break
          }
        }

        //on retourne enfin le marquage marquageResultant
        return marquageResultant;
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
