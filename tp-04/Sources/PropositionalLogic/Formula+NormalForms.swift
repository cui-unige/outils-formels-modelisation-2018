extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self {
      case .constant(_):
        return self
      case .proposition(_):
        return self
      case .implication(let imp1, let imp2):
        return !imp1.nnf || imp2.nnf
      case .conjunction(let conj1, let conj2):
        return conj1.nnf && conj2.nnf
      case .disjunction(let disj1, let disj2):
        return disj1.nnf || disj2.nnf
      case .negation(let neg):
        switch neg {
        case .constant(let const):
            return Formula.constant(!const)
          case .proposition:
            return self
          case .implication(_):
            return self
          case .conjunction(let conj1, let conj2):
            return !conj1.nnf || !conj2.nnf
          case .disjunction(let disj1, let disj2):
            return !disj1.nnf && !disj2.nnf
          case .negation(let neg):
            return neg.nnf
        }
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
    public var dnf: Formula {
      switch self.nnf {
        case .conjunction:
          var conjunctionOperands = self.nnf.conjunctionOperands
          if let disjunction = conjunctionOperands.first(
            where: {
              switch $0{
                case .disjunction(_,_):
                    return true
                default:
                    return false
              }
            }
          ) {
            if case let .disjunction(disj1, disj2) = disjunction {
              conjunctionOperands.remove(disjunction)
              var ret : Formula!
              for conjunctionOperand in conjunctionOperands {
                ret = (ret != nil) ? ret! || conjunctionOperand : conjunctionOperand
              }
              return ((ret.dnf && disj1.dnf) || (ret.dnf && disj2.dnf)).dnf
            }
          }
          return self.nnf
        case .disjunction:
          var disjunctionOperands = self.disjunctionOperands
          for disjunctionOerand in disjunctionOperands {
            for tmpDisjunctionOerand in disjunctionOperands {
              if (
                disjunctionOerand != tmpDisjunctionOerand &&
                disjunctionOerand.conjunctionOperands.isSubset(of: tmpDisjunctionOerand.conjunctionOperands)
              ) {
                disjunctionOperands.remove(tmpDisjunctionOerand)
              }
            }
          }
          var ret : Formula?
          for operand in disjunctionOperands {
            ret = (ret != nil) ? ret! || operand : operand
          }
          return ret!
        default :
          return self.nnf
      }
    }

  /// The conjunctive normal form (CNF) of the formula.
public var cnf: Formula {
  switch self.nnf {
    case .conjunction:
      var conjunctionOperands = self.nnf.conjunctionOperands
      for conjunctionOperand in conjunctionOperands {
        for tmpConjunctionOperand in conjunctionOperands {
          if (
            conjunctionOperand != tmpConjunctionOperand &&
            conjunctionOperand.disjunctionOperands.isSubset(of: tmpConjunctionOperand.disjunctionOperands)
          ) {
            conjunctionOperands.remove(tmpConjunctionOperand)
          }
        }
      }
      var ret : Formula?
      for conjunctionOperand in conjunctionOperands {
          ret = (ret != nil) ? ret! && conjunctionOperand : conjunctionOperand
      }
      return ret!
    case .disjunction:
      var disjunctionOperands = self.nnf.disjunctionOperands
      if let conjunction = disjunctionOperands.first(
        where: {
          switch $0 {
            case .conjunction(_,_):
              return true
            default:
              return false
          }
        }
      ) {
        if case let .conjunction(conj1, conj2) = conjunction {
          disjunctionOperands.remove(conjunction)
          var ret : Formula!
          for disjunctionOperand in disjunctionOperands {
            ret = (ret != nil) ? ret! || disjunctionOperand : disjunctionOperand
          }
          return ((ret.cnf || conj1.cnf) && (ret.cnf || conj2.cnf)).cnf
        }
      }
      return self.nnf
    default :
      return self.nnf
  }
}

/// The minterms of a formula in disjunctive normal form.
public var minterms: Set<Set<Formula>> {
  switch self {
    case .disjunction:
      var result : Set<Set<Formula>> = []
      for disjunction in self.disjunctionOperands {
        result.insert(disjunction.conjunctionOperands)
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
      var result : Set<Set<Formula>> = []
      for operand in self.conjunctionOperands {
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
