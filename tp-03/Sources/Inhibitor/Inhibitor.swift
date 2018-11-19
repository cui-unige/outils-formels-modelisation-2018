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
      //TODO
      for (place, arc) in preconditions{ //boucle sur les arc et transitions des préconditions
          //print(place, arc)
          switch arc { //switch sur les arcs
          case .inhibitor: //cas ou l'arc est un ihhibitor
              if(marking[place]! != 0){ //si le maquage de la place n'est pas null (place pas vide), alors transition pas tirable (retourne false)
                  return false
              }
          case .regular(let value): //cas regulier (pas inhibitor), récupère la valeur de l'arc
              // print(value)
              // print(marking[place]!)
              if(marking[place]! < value){ //si le marquage de la place est plus petit que la valeur de l'arc, la transition n'est pas tirable (retourne false)
                  return false
              }
          }
      }
      return true //sinon, la transitionest tirable
      //print("est tirable")
  }


    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
      //TODO
      //print("marquage de la place:")
      //print(marking)
      if(self.isFireable(from: marking)){ //test si transition est tirable
          var newMarking = marking //stocke nouveau marquage de la place dans variable newMarking

          //preconditions
          for (place, arc) in preconditions { //boucle sur arcs et transitions des preconditions
              switch arc{ //switch sur les arcs
              case .regular(let value): //cas ou l'arc est régulier (pas inhibitor), récupère la valeur de l'arc
                  newMarking[place]! -= value //décrémente le nouveau marquage de la place
              case .inhibitor: // cas ou l'arc est un inhibitor
                  break //nb jeton dans vaut 0, on change pas le nb de jeton avec un arc inhibitor
              }
              // print("YOLO")
              // print(newMarking[place]!)
          }


          //postconditions
          for (place, arc) in postconditions { //boucle sur arcs et transitions des postconditions
              switch arc{ //switch sur les arcs
              case .regular(let value): //cas ou l'arc est régulier, récupère la valeur de l'arc
                  newMarking[place]! += value //incrément le nouveau marquage de la place
              case .inhibitor: //cas ou l'arc est un inhibitior
                  break //on change pas le nb de jeton de la place avec un arc inhibitor
              }
              //print(newMarking[place]!)
          }

          return newMarking //on retourne le nouveau marquage de la place après avoir tiré la transition
      }
      else{ //sinon (si pas tirable) on retourne nil
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
