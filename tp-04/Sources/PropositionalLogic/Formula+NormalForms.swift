extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self{
            case .constant(let p):
                return p ? true : false
            case .proposition(_):
                return self
            case .disjunction(let p, let q): // or
                return (p).nnf || (q).nnf // il faut retourner cette forme
            case .conjunction(let p, let q): // and
                return (p).nnf && (q).nnf // il faut retourner cette forme
            case .implication(let p, let q): // not p or q
                return (!p).nnf || (q).nnf // il faut retourner cette forme
            case .negation(let p): // not
            switch p{
                    case .constant(let t):
                          return t ? false : true
                    case .disjunction(let t, let q): // t or q
                          return (!t).nnf && (!q).nnf // il faut retourner cette forme
                    case .conjunction(let t, let q): // t and q
                        return (!t).nnf || (!q).nnf // il faut retourner cette forme
                    case .implication(let t, let q): // not (t or nit q)
                          return (t).nnf && (!q).nnf // il faut retourner cette forme
                    case .negation(let t): // not
                          return t.nnf // il faut retourner cette forme
                    case .proposition(_):
                        return self
            }
       }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    return self
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    return self
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    return []
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    return []
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
