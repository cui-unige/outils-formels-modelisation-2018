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
      for place in preconditions { // on parcours pour tous les places des preconditions

			 switch preconditions[place.key]! {
			 case .regular(let value): // dans le cas d'un arc regulier
					 if marking[place.key]! < value { //si le marquage est plus petit que la prècondition alors ce n'est pas tirable
						 return false
					 }
				 case .inhibitor: // dans le cas d'un arc inhibiteur
					 if marking[place.key] != 0 { //si le marquage est different de 0 alors le marquage n'est pas tirable
						 return false
					 }
			 }
		 }
     // on renvoie true car la transition est franchissable depuis le marquage
		 return true
}


    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
      if isFireable(from: marking) { // on teste si le marquage est tirable depuis le marquage
             var newMarking = marking // on recupere le marquage dans une variable (newMarking)
             for place in preconditions { // on parcours les preconditions
               switch preconditions[place.key]! {

                 case .regular(let value): // dans le cas d'un arc regulier

                   newMarking[place.key]! -= value // on retire au marquage le valeur necessaire au tirage
                   break // on quitte la boucle
                 case .inhibitor: // si c'est un arc inhibiteur

                   break // on tire et on quitte la boucle
               }
             }

             for place in postconditions { // on parcours les postconditions
               switch postconditions[place.key]! {

       					case .regular(let value): // pour un arc regulier
                   // on a ajoute le nombre de jetons du tirage au marquage
                   newMarking[place.key]! += value
       						break // on quitte la boucle
       					case .inhibitor: // pour un arc inhibiteur

                   break // on quitte la boucle
               }

             }
             // on renvoie le newMarking comme nouveau marquage
             return newMarking
           }
           // on revoie rien
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
