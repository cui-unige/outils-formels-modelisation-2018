extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self {
    case .negation(let a)://In case of negation
      switch a {
      case .constant(let b):
        return Formula.constant(!b)
      case .proposition:
        return self
      case .negation(let b):
        return b.nnf
      case .implication(let b, let c):
        return b.nnf && !c.nnf
      case .disjunction(let b, let c):
        return !b.nnf && !c.nnf
      case .conjunction(let b, let c):
        return !b.nnf || !c.nnf
      }
    case .implication(let a, let b):
      return !a.nnf || b.nnf
	  case .disjunction(let a, let b):
      return a.nnf || b.nnf
    case .conjunction(let a, let b):
      return a.nnf && b.nnf
    default :
      return self
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf {
    case .conjunction:
      var variables = self.nnf.conjunctionOperands
      if let disjonctionTrouvee = variables.first(where: {
				if case  .disjunction = $0 {
        	return true
      }
		return false } ) {
          if case let .disjunction(a, b) = disjonctionTrouvee {
            variables.remove(disjonctionTrouvee)
            var result : Formula?
            for operand in variables {
              if result != nil  {
                result = result! && operand
              }
              else {
                result = operand
              }
            }
          result = (a.dnf && result!.dnf) || (b.dnf && result!.dnf)
          if result != nil { return result!.dnf}
          }
      }
      return self.nnf
    case .disjunction: // ∨
      var variables = self.disjunctionOperands
      for operandA in variables {
        for operandB in variables {
          if operandA.conjunctionOperands.isSubset(of:operandB.conjunctionOperands) && operandB != operandA {
            variables.remove(operandB)
          }
        }
      }
      var result : Formula?
      for operandA in variables {
        if result != nil  {
          result = result! || operandA
        }
        else {
          result = operandA
        }
      }
      return result!
    default :
      return self.nnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    switch self.nnf {
    case .disjunction:
      var variables = self.nnf.disjunctionOperands
      if let firstConjunction = variables.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, b) = firstConjunction {
            variables.remove(firstConjunction)
            var result : Formula?
            for operandA in variables {
              if result != nil  {
                result = result! || operandA
              }
              else {
                result = operandA
              }
            }
          result = (a.cnf || result!.cnf) && (b.cnf || result!.cnf)
          if result != nil { return result!.cnf}
          }
      }
      return self.nnf
    case .conjunction:
      var variables = self.nnf.conjunctionOperands
      for operandA in variables {
        for operandB in variables {
          if operandA.disjunctionOperands.isSubset(of:operandB.disjunctionOperands) && operandB != operandA {
            variables.remove(operandB)
          }
        }
      }
      var result : Formula?
      for operandA in variables {
        if result != nil  {
          result = result! && operandA
        }
        else {
          result = operandA
        }
      }
      return result!
    default :
      return self.nnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .disjunction:
      let operands = self.disjunctionOperands
      var result : Set<Set<Formula>> = []
      for operand in operands {
        result.insert(operand.conjunctionOperands)
      }
      return result
    default:
      return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .conjunction:
      let operands = self.conjunctionOperands
      var result : Set<Set<Formula>> = []
      for operand in operands {
        result.insert(operand.disjunctionOperands)
      }
      return result
    default:
      return []
    }
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
