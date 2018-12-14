extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self {
      case .negation(let a):
        switch a{
          case .constant(let b):
            return .constant(!b) /// ¬b
          case .proposition:
            return self
          case .negation(let b):
            return b.nnf
          case .disjunction(let b, let c):
            return !b.nnf && !c.nnf //¬(b ∨ c)
          case .conjunction(let b, let c):
            return !b.nnf || !c.nnf //¬(b ∧ c)
          case .implication(let b, let c):
            return !b.nnf || c.nnf //¬b ∨ c
        }
      case .disjunction(let a, let b):
        return a.nnf || b.nnf
      case .conjunction(let a, let b):
        return a.nnf && b.nnf
      case .implication(let a, let b):
        return !a.nnf || b.nnf
      default:
        return self

    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf { //distribution des négations
      case .conjunction:
        var operandes = self.nnf.conjunctionOperands
        if let firstDisj = operandes.first(where: {
          switch $0 {
            case .disjunction(_,_): //rechercher la première disjonction
              return true
            default:
              return false
          }
        })  {
        if case let .disjunction(a, b) = firstDisj {
          operandes.remove(firstDisj)
          var res : Formula?
          for op in operandes {
            if res != nil {
              res = res! && op
            }
            else {
              res = op
            }
          }
          res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf)
          return res!.dnf
        }
      }
      return self.nnf

    case .disjunction:
      var operandes = self.disjunctionOperands
      for op1 in operandes {
        for op2 in operandes {
          if op1.conjunctionOperands.isSubset(of: op2.conjunctionOperands) && op2 != op1 {
            operandes.remove(op2)
          }
        }
      }
      var res : Formula?
      for op1 in operandes {
        if res != nil {
          res = res! || op1
        }
        else {
          res = op1
        }
      }
      return res!

    default:
      return self.nnf
  }
}

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    switch self.nnf {
      case .disjunction:
        var operandes = self.nnf.disjunctionOperands
        if let firstConj = operandes.first(where: {
          switch $0 {
            case .conjunction(_,_):
              return true
            default:
              return false
          }
        }) {
        if case let .conjunction(a, b) = firstConj {
          operandes.remove(firstConj)
          var res : Formula?
          for op in operandes {
            if res != nil {
              res = res! || op
            }
            else {
              res = op
            }
          }
          res = (a.cnf || res!.cnf) && (b.cnf || res!.cnf)
          return res!.cnf
          }
        }
        return self.nnf

      case .conjunction:
        var operandes = self.nnf.conjunctionOperands
        for op1 in operandes {
          for op2 in operandes {
            if op1.disjunctionOperands.isSubset(of: op2.disjunctionOperands) && op2 != op1 {
              operandes.remove(op2)
            }
          }
        }
        var res : Formula?
        for op1 in operandes {
          if res != nil {
            res = res! && op1
          }
          else {
            res = op1
          }
        }
        return res!

      default:
        return self.nnf
    }
  }


  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .disjunction(let a, let b):
      return a.minterms.union(b.minterms)
    case .conjunction(let a, let b):
      return [a.conjunctionOperands.union(b.conjunctionOperands)]
    default:
      return [[self]]
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .conjunction(let a, let b):
      return a.maxterms.union(b.maxterms)
    case .disjunction(let a, let b):
      return [a.disjunctionOperands.union(b.disjunctionOperands)]
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
