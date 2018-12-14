func is_disjonction(element: Formula) -> Bool {
	switch element {
		case .disjunction(_,_): return true
		default: return false
	}
}

func is_conjonction(element: Formula) -> Bool {
	switch element {
		case .conjunction(_,_): return true
		default: return false
	}
}

extension Formula {

	/// The negation normal form of the formula.
	public var nnf: Formula {
		switch self {
			case .constant(_):
				return self // already nnf (minimal case :¬D)
			case .proposition(_):
				return self // already nnf (minimal case :¬D)
			case .disjunction(let a, let b):
				return a.nnf || b.nnf
			case .conjunction(let a, let b):
				return a.nnf && b.nnf
			case .implication(let a, let b):
				return !a.nnf || b.nnf
			case .negation(let n):
				switch n {
					case .constant(let c):
						return c ? false : true
					case .proposition(_):
						return self // rien à développer

					// De Morgan  ¬(A∨B)≡¬A∧¬B 
					case .disjunction(let aa, let bb):
						return (!aa).nnf && (!bb).nnf

					// De Morgan  ¬(A∧B)≡¬A∨¬B
					case .conjunction(let aa, let bb):
						return (!aa).nnf || (!bb).nnf

					case .implication(let aa, let bb):
						return (aa).nnf && (!bb).nnf
					case .negation(let nn):
						return nn.nnf // ne pas négater du coup !
				}
		}
	}

	/// The disjunctive normal form (DNF) of the formula.
	// but : mettre sous forme ((b ∧ ¬c ) ∨ (¬a ∧ ¬c))
	public var dnf: Formula {

		let nnf = self.nnf
		// nnf n'a que des ∧, ∨, constant, ¬constant, proposition

		// distributivité   A∨(B∧C)≡(A∨B)∧(A∨C)
		// distributivité   A∧(B∨C)≡(A∧B)∨(A∧C)

		switch nnf {
			case .conjunction(_,_):
				var operands = nnf.conjunctionOperands

				// extract first disjunction and fight it
				if let first_disjunction = operands.first( where: is_disjonction ) {
					// that's a bit sad to write this way... I selected it to be a disjunction
					if case let .disjunction(aa, bb) = first_disjunction {
						// pop 
						operands.remove( first_disjunction )

						// we ∧ each operands left
						let out = operands.reduce( true, {(acc, element) -> Formula in return acc && element})
						// distributivité   A∧(B∨C)≡(A∧B)∨(A∧C)
						return ((aa.dnf && out.dnf) || (bb.dnf && out.dnf)).dnf
					}
				}
				// no bad guys around ! yaaay we're done !
				return nnf

			case .disjunction(_,_):
				var operands = nnf.disjunctionOperands
				// simplify
				for operand in operands {
					for op in operands {
						if operand.conjunctionOperands.isSubset(of: op.conjunctionOperands) && operand != op {
							operands.remove(op)
						}
					}
				}

				// `or` each remaining operands
				return operands.reduce( false, {(acc, element) -> Formula in return acc || element})

			default: // constant, ¬constant ...
				return nnf
		}


	}
	
	/// The conjunctive normal form (CNF) of the formula.
	// but : mettre sous forme ((b ∨ ¬c ) ∧ (¬a ∨ ¬c))
	public var cnf: Formula {
		let nnf = self.nnf
		
		switch nnf {
			case .disjunction(_,_):
				var operands = nnf.disjunctionOperands

				// extract first conjunction and fight it
				if let first_conjunction = operands.first( where: is_conjonction ) {
					// that's a bit sad to write this way... I selected it to be a conjunction
					if case let .conjunction(aa, bb) = first_conjunction {
						// pop
						operands.remove( first_conjunction )

						// we ∨ each operands left
						let out = operands.reduce( false, {(acc, element) -> Formula in return acc || element})
						// distributivité   A∨(B∧C)≡(A∨B)∧(A∨C)
						return ((aa.cnf || out.cnf) && (bb.cnf || out.cnf)).cnf
					}
				}
				// no bad guys around ! yaaay we're done !
				return nnf

			case .conjunction(_,_):
				var operands = nnf.conjunctionOperands
				// simplify
				for operand in operands {
					for op in operands {
						if operand.disjunctionOperands.isSubset(of: op.disjunctionOperands) && operand != op {
							operands.remove(op)
						}
					}
				}

				// `and` each remaining operands
				return operands.reduce( true, {(acc, element) -> Formula in return acc && element})

			default: // constant, ¬constant ...
				return nnf
		}
	}
	
	/// The minterms of a formula in disjunctive normal form.
	public var minterms: Set<Set<Formula>> {
		return Set(self.disjunctionOperands.map({
			(operand) in return operand.conjunctionOperands
		}))
	}
	
	/// The maxterms of a formula in conjunctive normal form.
	public var maxterms: Set<Set<Formula>> {
		return Set(self.conjunctionOperands.map({
			(operand) in return operand.disjunctionOperands
		}))
	}
	
	/// Unfold a tree of binary disjunctions into a set of operands.
	///
	///     let f: Formula = .disjunction("a", .disjunction("b", .negation("c")))
	///     print(disjunctionOperands)
	///     // Prints "[a, b, ¬c]"
	///
	private var disjunctionOperands: Set<Formula> {
		switch self {
		case .disjunction(let a, let b):
			return a.disjunctionOperands.union(b.disjunctionOperands)
		default:
			return [self]
		}
	}
	
	/// Unfold a tree of binary conjunctions into a set of operands.
	///
	///     let f: Formula = .conjunction("a", .conjunction("b", .negation("c")))
	///     print(f.conjunctionOperands)
	///     // Prints "[a, b, ¬c]"
	///
	private var conjunctionOperands: Set<Formula> {
		switch self {
		case .conjunction(let a, let b):
			return a.conjunctionOperands.union(b.conjunctionOperands)
		default:
			return [self]
		}
	}
	
}