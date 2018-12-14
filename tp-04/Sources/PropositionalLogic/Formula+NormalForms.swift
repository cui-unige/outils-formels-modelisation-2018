extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self {
    case .negation(let a): /// ¬(a)
        switch a {
        case .constant(let b): /// ¬(b) --> ¬b
            return .constant(!b)
        case .negation(let b): /// ¬(¬b) --> b
            return b.nnf
        case .disjunction(let b, let c): /// ¬(b ∨ c) --> ¬b ∧ ¬c
            return (!b.nnf && !c.nnf)
        case .conjunction(let b, let c): /// ¬(b ∧ c) --> ¬b ∨ ¬c
            return (!b.nnf || !c.nnf)
        case .implication(let b, let c): /// ¬(b → c)  -->  ¬(¬b ∨ c) == b ∧ ¬c
            return (b.nnf && !c.nnf)
        default:
            return self
        }
    case .disjunction(let a, let b): /// a ∨ b --> a ∨ b
        return (a.nnf || b.nnf)
    case .conjunction(let a, let b): /// a ∧ b --> a ∧ b
        return (a.nnf && b.nnf)
    case .implication(let a, let b): /// a → b  -->  ¬a ∨ b
        return (!a.nnf || b.nnf)
    default:
        return self
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    switch self.nnf { /// DNF also requires the negations in the same form as NNF
    case .conjunction(let a, let b): /// a ∧ b --> Try to convert to disjunction of
                                     /// conjunctions
        if case let .disjunction(c, d) = a { /// (c ∨ d) ∧ b --> (c ∧ b) ∨ (d ∧ b)
            return (c.dnf && b.dnf) || (d.dnf && b.dnf)
        } else if case let .disjunction(c, d) = b { /// a ∧ (c ∨ d) -->
                                                    /// (a ∧ b) ∨ (d ∧ b)
            return (a.dnf && c.dnf) || (a.dnf && d.dnf)
        } else {
            return self.nnf
        }
    case .disjunction: /// a ∨ b ∨ c ∨ d ∨ a ... --> Remove possible duplicates
        var operands = self.disjunctionOperands
        for op in operands {
            for op1 in operands {
                if op.conjunctionOperands.isSubset(of:op1.conjunctionOperands) && op1 != op {
                    operands.remove(op1)
                }
            }
        }
        var res: Formula?
        for op in operands {
            if res != nil  {
                res = res! || op
            } else {
                res = op
            }
        }
        return res!
    default:
        return self.nnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    switch self.nnf { /// DNF also requires the negations in the same form as NNF
    case .disjunction(let a, let b):/// a ∧ b --> Try to convert to conjunction of
                                    /// disjunctions
        if case let .conjunction(c, d) = a { /// (c ∧ d) ∨ b --> (c ∨ b) ∧ (d ∨ b)
            return (c.dnf || b.dnf) && (d.dnf || b.dnf)
        } else if case let .disjunction(c, d) = b { /// a ∨ (c ∧ d) -->
            /// (a ∨ b) ∧ (d ∨ b)
            return (a.dnf || c.dnf) && (a.dnf || d.dnf)
        } else {
            return self.nnf
        }
    case .conjunction: /// a ∨ b --> Reduce
        var operands = self.nnf.conjunctionOperands
        for op in operands {
            for op1 in operands {
                if op.disjunctionOperands.isSubset(of:op1.disjunctionOperands) && op1 != op {
                    operands.remove(op1)
                }
            }
        }
        var res : Formula?
        for op in operands {
            if res != nil  {
                res = res! && op
            }
            else {
                res = op
            }
        }
        return res!
    default:
        return self.nnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    switch self {
    case .disjunction:
        let operands = self.disjunctionOperands
        var terms : Set<Set<Formula>> = []
        for op in operands {
            terms.insert(op.conjunctionOperands)
        }
        return terms
    default:
        return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    switch self {
    case .conjunction:
        let operands = self.conjunctionOperands
        var terms : Set<Set<Formula>> = []
        for op in operands {
            terms.insert(op.disjunctionOperands)
        }
        return terms
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
