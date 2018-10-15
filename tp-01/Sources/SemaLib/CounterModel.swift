/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  var pre={p:Place,t:Transition-> Nat in
		var retour=0
		if ((p==b0 && t!=t0) || (p==b1 && (t==t2 || t==t3)) || (p==b2 && t==t3))
		{retour=1}
		return retour }
  var post={p:Place,t:Transition -> Nat in
		var retour=0
		if ((p==b0 && t==t0)||(p==b1 && t==t1)||(p==b2 && t==t2))
		{retour=1}
		return retour}
	 	
  return PetriNet(places: [p0,p1,p2], transitions: [t0,t1,t2,t3], pre: pre, post: post)
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
  // Write your code here.
  return { place:Place -> Nat in return 0  }
}
