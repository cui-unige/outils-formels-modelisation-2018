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
		 for place in preconditions {
			 switch preconditions[place.key]! { // on itère sur les arcs
			 case .regular(let value): // si on a un arc "normal", on récupère la valeur de l'arc = précondition
					 if marking[place.key]! < value { // si la précondition est plus grande que le marquage : non tirable
						 return false
					 }
				 case .inhibitor: // si on a un arc inhibiteur
					 if marking[place.key] != 0 { // si le marquage n'est pas 0, la transition n'est pas tirable
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
      if isFireable(from: marking){
        var newMarking = marking // on récupère le marquage passé en argument

        for place in preconditions { // on itère sur les arcs, dans les préconditions
          switch preconditions[place.key]! {
					case .regular(let value): // si arc normal (value = précondition)
            newMarking[place.key]! -= value // on enlève au marquage la valeur demandée pour le tirage, donc le nombre pris pour tirer
						break
					case .inhibitor: // si arc inhibiteur
              break // rien à faire, on tire juste
          }
        }

        for place in postconditions{ //on itère sur les arcs, dans les postconditions
          switch postconditions[place.key]! {
					case .regular(let value): // si arc "normal"
            newMarking[place.key]! += value // on ajoute au marquage le nombre gagné après le tirage
						break
					case .inhibitor: // si inhibiteur
             break
          }
        }
         return newMarking
      }
      return nil // si pas tirable, on retourne nil
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
