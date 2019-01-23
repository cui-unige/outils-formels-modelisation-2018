extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // We treat every case with a switch
    switch self{
    case .constant(let a):
      return a ? true : false
    case .proposition(_):
      return self
    case .disjunction(let a, let b):
      return a.nnf || b.nnf
    case .conjunction(let a, let b):
      return a.nnf && b.nnf
    case .implication(let a, let b): // we use the formula a => b is !a v b
      return !a.nnf || b.nnf
    case .negation(let a):
      switch a{
      case .constant(let b): // inverse it
        return b ? false : true
      case .proposition(_):
        return self
      case .negation(let b):
        return b.nnf
      case .disjunction(let b, let c): // !(a v b) is !a ∧ !b
        return !b.nnf && !c.nnf
      case .conjunction(let b, let c): // !(a ∧ b) is !a v !b
        return !b.nnf || !c.nnf
      case .implication(let b, let c): // !(!a v b) is a ∧ !b
        return b.nnf && !c.nnf
      }
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    switch self.nnf{ // we do self.nnf to transform negation and implication
    case .constant(let a):
      return a ? true : false
    case .proposition(_):
      return self
    case .disjunction(let a, let b):
      return a.dnf || b.dnf
    case .conjunction(let a, let b):
      let aa = a.dnf // store the dnf
      let bb = b.dnf // sotre the dnf

      switch (aa,bb){ // we treat the case where first part is a disjunction then second
      case (.disjunction(let c, let d),_): // (b ∨ c) ∧ a is (b ∧ a) ∨ (c ∧ a)
        return (c && bb) || (d && bb)
      case (_,.disjunction(let c, let d)): // a ∧ (b ∨ c) is (a ∧ b) ∨ (a ∧ c)
        return (aa && c) || (aa && d)
      default:
        return aa && bb
      }
    default:
      return self.nnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    switch self.nnf{
    case .constant(let a):
      return a ? true : false
    case .proposition(_):
      return self
    case .disjunction(let a, let b):
      let aa = a.cnf
      let bb = b.cnf

      switch (aa,bb){
      case (.conjunction(let c, let d),_): // (b ∧ c) v a is (b v a) ∧ (c v a)
        return (c || bb) && (d || bb)
      case (_,.conjunction(let c, let d)): // a v (b ∧ c) is (a v b) ∧ (a v c)
        return (aa || c) && (aa || d)
      default:
        return aa || bb
      }
    case .conjunction(let a, let b):
      return a.cnf && b.cnf
    default:
      return self.nnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    switch self{
    case .disjunction(_,_):
      var list_dis : Set<Set<Formula>> = []
        for op in self.disjunctionOperands{
          list_dis.insert(op.conjunctionOperands)
        }
        return list_dis
      default:
        return []
      }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    switch self{
    case .conjunction(_,_):
      var list_con : Set<Set<Formula>> = []
        for op in self.conjunctionOperands{
          list_con.insert(op.disjunctionOperands)
        }
        return list_con
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
