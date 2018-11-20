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

      for place in preconditions { /* Boucle sur les préconditions sur le paramètre place*/
          switch preconditions[place.key]!  { /* On s'intéresse à la place de chaque précondition */
        case .inhibitor:  /*cas de l'arc temporel,inhibition*/
                        if marking[place.key] != 0 { /* on vérifie si le marquage != 0*/
                                return false
                              }
                case .regular(let value):  /* cas de l'arc régulier */
                /*On associe la valeur de précondition*/
                      if marking[place.key  ]! < value { /* On vérifie si la précondition est sup à la valeur de précondition de l'arc*/
                          return false
                      }

          }
     }
      return true /*cas écheant,transition tirable*/

    }

    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      if isFireable(from: marking) { /*Si la transition est tirable alors ..*/
          var actualMarking = marking  /* marquage actuel*/

          for place in preconditions { /* Boucle sur les préconditions sur le paramètre place*/
            switch preconditions[place.key]! { /* On s'intéresse à la place de chaque précondition */
                    case .regular(let value): /*cas du l'arc régulier*/
                    /*On associe la valeur de précondition*/
                        actualMarking[place.key]! -= value   /* et on change le marquage*/
                        break /* ... se termine*/
                    case .inhibitor: /*cas de l'arc inhibition*/
                        actualMarking[place.key] = 0
                        break /*se termine*/
            }
          }
          for place in postconditions  {
                switch postconditions[place.key]! { /* Maintenant sur les postconditions*/
                    case .regular(let value): /* cas du l'arc régulier*/
                    /*On prend la valeur de postcondition l'arc */
                    // fire transition : add regular arc postcondition value to marking of postcondition place
                          actualMarking[place.key]! += value /*On donne la nouvelle valeur de postcondition*/
                          break /* se termine*/
                   case .inhibitor: /*cas de l'arc temporel,inhabition*/
                          actualMarking[place.key]! = 0
                          break /* se termine*/
                }
          }
   /*cas écheant , on retourne le marquage modifié*/
        return actualMarking
      } else {
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
