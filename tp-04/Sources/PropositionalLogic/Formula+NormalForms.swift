extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self
    {
      case .constant(_):
        return self
      case .proposition(_):
        return self
      case .negation(let a):
        switch a
        {
        case .constant(let b):
            return Formula.constant(!b)
          case .proposition(_):
            return self
          case .negation(let b):
            return b.nnf
          case .disjunction(let b, let c):
            return (!(b.nnf) && !(c.nnf))
          case .conjunction(let b, let c):
            return (!(b.nnf) || !(c.nnf))
          case .implication(let b, let c):
            return ((b.nnf) && !(c.nnf))
        }
      case .disjunction(let a, let b):
        return (a.nnf || b.nnf)
      case .conjunction(let a, let b):
        return (a.nnf && b.nnf)
      case .implication(let a, let b):
        return (!(a.nnf) || b.nnf)
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    switch self.nnf {
    case .conjunction:
      var operands = self.nnf.conjunctionOperands
      if let firstDis = operands.first(where: { if case  .disjunction = $0 {
        return true
      }
      return false }) {
          if case let .disjunction(a, b) = firstDis {
            operands.remove(firstDis)

            var sol : Formula?

            for op in operands {
              if sol != nil  {
                sol = sol! && op
              }
              else {
                sol = op
              }
            }

          sol = (a.dnf && sol!.dnf) || (b.dnf && sol!.dnf)
          if sol != nil { return sol!.dnf}
          }
      }
      return self.nnf

    case .disjunction:
      var operands = self.disjunctionOperands

      for op in operands {
        for op1 in operands {
          if op.conjunctionOperands.isSubset(of:op1.conjunctionOperands) && op1 != op {
            operands.remove(op1)
          }
        }
      }

      var sol : Formula?
      for op in operands {
        if sol != nil  {
          sol = sol! || op
        }
        else {
          sol = op
        }
      }
      return sol!

    default :
      return self.nnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {

    switch self.nnf {
    case .disjunction:
      var operands = self.nnf.disjunctionOperands
      if let firstConj = operands.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, b) = firstConj {
            operands.remove(firstConj)
            var sol : Formula?
            for op in operands {
              if sol != nil  {
                sol = sol! || op
              }
              else {
                sol = op
              }
            }
          sol = (a.cnf || sol!.cnf) && (b.cnf || sol!.cnf)
          if sol != nil { return sol!.cnf}
          }
      }
      return self.nnf

    case .conjunction:
      var operands = self.nnf.conjunctionOperands
      for op in operands {
        for op1 in operands {
          if op.disjunctionOperands.isSubset(of:op1.disjunctionOperands) && op1 != op {
            operands.remove(op1)
          }
        }
      }

      var sol : Formula?
      for op in operands {
        if sol != nil  {
          sol = sol! && op
        }
        else {
          sol = op
        }
      }
      return sol!
    default :
      return self.nnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    switch self {
    case .disjunction:
      let operands = self.disjunctionOperands
      var result : Set<Set<Formula>> = []
      for op in operands {
        result.insert(op.conjunctionOperands)
      }
      return result

    default:
      return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    switch self {
    case .conjunction:
      let operands = self.conjunctionOperands
      var result : Set<Set<Formula>> = []
      for op in operands {
        result.insert(op.disjunctionOperands)
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
