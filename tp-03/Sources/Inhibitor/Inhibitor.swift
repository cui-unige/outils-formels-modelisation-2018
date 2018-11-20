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

	var retour = true // return value

      for p in marking.keys 
	{	// test all Place from marking

		let m : Int! = marking[p]// m is the marking of place p. Dont repeat marking[p] in code

		switch preconditions[p]
		{
			case .regular(let a)?:
			if m < a
				{
					retour = false
				}
			
		
			case .inhibitor?:
			if m != 0
			{
				retour = false
			}		
			else
			{ 
				retour=false
			}
			default:
			retour=false
		}		 

	}
      return retour
    }

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.
    public func fire(from marking: [Place: Int]) -> [Place: Int]? {

      if isFireable( from: marking){
	var retour = [Place: Int]()

	for p in marking.keys 
	{
		let m : Int! = marking[p]
		var b : Int
		
		switch postconditions[p]
		{
			case .inhibitor?:
			b=0
			case .regular(let c)?:
			b=c
			default:
			return nil
		
		}

		switch preconditions[p] 
		{
			case .inhibitor?:
			retour[p] = m + b
		
			case .regular(let a)?:
			retour[p] = m + b - a
			
			default:
			return nil
		}
	}
	
	return retour
      }	

     else{
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
