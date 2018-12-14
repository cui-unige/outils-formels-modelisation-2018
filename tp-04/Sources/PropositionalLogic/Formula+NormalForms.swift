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
					case .disjunction(let aa, let bb):
						return (!aa).nnf && (!bb).nnf
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
	public var dnf: Formula {

		let nnf = self.nnf

		// nnf n'a que des ∧, ∨, constant, ¬constant, proposition

		// De Morgan        ¬(A∧B)≡¬A∨¬B
		// De Morgan        ¬(A∨B)≡¬A∧¬B

		// distributivité   A∨(B∧C)≡(A∨B)∧(A∨C)
		// distributivité   A∧(B∨C)≡(A∧B)∨(A∧C)

		// but : ((b ∧ ¬c) ∨ (¬a ∧ ¬c))

		return nnf
	}
	
	/// The conjunctive normal form (CNF) of the formula.
	public var cnf: Formula {

		let nnf = self.nnf

		return nnf
	}
	
	/// The minterms of a formula in disjunctive normal form.
	public var minterms: Set<Set<Formula>> {
		let dnf = self.dnf
		return Set(dnf.disjunctionOperands.map({
			(operand) in return operand.conjunctionOperands
		}))
	}
	
	/// The maxterms of a formula in conjunctive normal form.
	public var maxterms: Set<Set<Formula>> {
		let dnf = self.dnf
		return Set(dnf.conjunctionOperands.map({
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