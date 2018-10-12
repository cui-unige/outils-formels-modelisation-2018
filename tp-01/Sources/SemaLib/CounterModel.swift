

/// This function creates the model of a binary counter on three bits.
public func createCounterModel() -> PetriNet {
  // on prend en compte que la transisiton est tirable (vérifié avant)
	// à chaque fois on les tire tous : t0, t1, t2, t3
	// verifie si tirable DANS L'ORDRE, puis tire si ok

	func pre(p: Place, t: Transition) -> Nat {
	  switch (p, t) {
	  case (Place("b0"), Transition("t1")): return 2
	  case (Place("b1"), Transition("t2")): return 2
	  case (Place("b2"), Transition("t3")): return 2
	  default: return 0
	  }
	}

	func post(p: Place, t: Transition) -> Nat {
	  switch (p, t) {
	  case (Place("b0"), Transition("t0")): return 1
	  case (Place("b1"), Transition("t1")): return 1
	  case (Place("b2"), Transition("t2")): return 1
	  default: return 0
	  }
	}

	let petrinet = PetriNet(
		places      : [Place("b2"), Place("b1"), Place("b0")],
		transitions : [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
		pre         : pre,
		post        : post)

  return PetriNet(places: [], transitions: [], pre: { _, _ in 0 }, post: { _, _ in 0 })
}

/// This function returns the initial marking corresponding to the model of your binary counter.
public func createCounterInitialMarking() -> Marking {
	//switch place {
	//case Place("b0"): return { _ in 0 }
	//case Place("b1"): return { _ in 0 }
	//case Place("b2"): return { _ in 0 }
	//default: return { _ in 0 }
//}
	return { _ in 0 }
}
