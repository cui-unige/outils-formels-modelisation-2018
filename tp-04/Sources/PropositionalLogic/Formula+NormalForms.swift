extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self {
    case .constant(let a):
        return a ? true : false
    case .proposition(_):
        return self
    case .negation(let a):
        switch a {
        case .constant(let b):
            return b ? false : true //vrai devient faux et inversement
        case .proposition(_):
            return self
        case .negation(let b):
            return b.nnf
        case .disjunction(let c, let d):
            return (!c).nnf && (!d).nnf //¬(c ∧ d)
        case .conjunction(let e, let f):
            return (!e).nnf || (!f).nnf // ¬(e v f)
        case .implication(let g, let h):
            return g.nnf && (!h).nnf // g ∧ ¬h
        }
    case .disjunction(let b, let c):
        return b.nnf || c.nnf //b v c
    case .conjunction(let d, let e):
        return d.nnf && e.nnf //d ∧ e
    case .implication(let f, let g):
        return (!f).nnf || g.nnf //¬f ∧ g
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
      let a = self.nnf
      switch a {
      case .conjunction(let b, let c):
          switch (b.dnf, c.dnf) {
          case (_, .disjunction(let d, let e)):
              return (b.dnf && d.dnf).dnf || (b.dnf && e.dnf).dnf
          case (.disjunction(let f, let g), _):
              return (c.dnf && f.dnf).dnf || (c.dnf && g.dnf).dnf
          default:
              return b.dnf && c.dnf
          }
      case .disjunction(let b, let c):
          return b.dnf || c.dnf
      default:
          return a
      }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula { //même principe que dnf, on inverse juste les ∧ et les v
      let a = self.nnf
      switch a {
      case .disjunction(let b, let c):
          switch (b.cnf, c.cnf) {
          case (_, .conjunction(let d, let e)):
              return (b.cnf || d.cnf).cnf && (b.cnf || e.cnf).cnf
          case (.conjunction(let f, let g), _):
              return (c.cnf || f.cnf).cnf && (c.cnf || g.cnf).cnf
          default:
              return b.cnf || c.cnf
          }
      case .conjunction(let b, let c):
          return b.cnf && c.cnf
      default:
          return a
      }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    switch self {
    case .disjunction(let a, let b):
        return a.minterms.union(b.minterms)
    case .conjunction(let a, let b):
        return [a.conjunctionOperands.union(b.conjunctionOperands)]
    default:
        return [[self]] // on met [[self]] car on veut un type Set<Set>Formula>>
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    switch self {
    case .disjunction(let a, let b):
        return [a.disjunctionOperands.union(b.disjunctionOperands)]
    case .conjunction(let a, let b):
        return a.maxterms.union(b.maxterms)
    default:
        return [[self]]
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
