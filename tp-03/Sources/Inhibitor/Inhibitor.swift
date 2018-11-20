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
        for (place, arc) in self.preconditions {
            switch(arc) {
            case let .regular(arc: arc):
                guard marking[place]! >= arc else { return false } // on vérifie si il y a assez de jetons
            case .inhibitor:
                guard marking[place]! == 0 else { return false } // on vérifie qu'il n'y a pas de jetons dans la place
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
        if isFireable(from: marking){ // On vérifie que c'est tirable
            var newMarking = marking //On initialise le marquage
            //preconditions
            for place in preconditions {
                switch preconditions[place.key]! {
                case .regular(let value):
                    newMarking[place.key]! -= value //On retire la précondition
                case .inhibitor: //On ne retire rien comme la place est vide
                    break
                }
            }
            //postconditions
            for place in postconditions{
                switch postconditions[place.key]! {
                case .regular(let value):
                    newMarking[place.key]! += value //On ajoute la précondition
                case .inhibitor: //Il n'y pas de postconditon .inhibitor
                    break
                }
            }
            return newMarking
        }
        return nil //cas ou on ne peut pas tirer
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
