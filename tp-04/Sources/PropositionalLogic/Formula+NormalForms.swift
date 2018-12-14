extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {

    switch self {

    case .negation(let a): // Si on a une négation
      switch a {
      case .constant(let b):
        return Formula.constant(!b)
      case .proposition:
        return self
      case .negation(let b):
        return b.nnf
      case .disjunction(let b, let c):
        return !b.nnf && !c.nnf
      case .conjunction(let b, let c):
        return !b.nnf || !c.nnf
      case .implication(let b, let c):
        return b.nnf && !c.nnf
      } // Le reste si il n'y a pas de négation
    case .disjunction(let a, let b):
      return a.nnf || b.nnf
    case .conjunction(let a, let b):
      return a.nnf && b.nnf
    case .implication(let a, let b):
      return !a.nnf || b.nnf
    default :
      return self
    }

    return self
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {

    switch self.nnf {
    case .conjunction:
      var operands = self.nnf.conjunctionOperands
      if let firstDisjunction = operands.first(where: { if case .disjunction = $0 {
        return true
      }
    return false }) {
      if case let .disjunction(a,b) = firstDisjunction {
        operands.remove(firstDisjunction)
        var res : Formula?
        for op in operands {
          if res != nil {
            res = res! && op
          }
          else {
            res = op
          }
        }
        res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf)
        if res != nil { return res!.dnf}
      }
    }
    return self.nnf
  case .disjunction:
    var operands = self.disjunctionOperands
    for op in operands {
      for op2 in operands {
        if op.conjunctionOperands.isSubset(of: op2.conjunctionOperands) && op2 != op {
          operands.remove(op2)
        }
      }
    }
    var res : Formula?
    for op in operands {
      if res != nil {
        res = res! || op
      }
      else {
        res = op
      }
    }
    return res!
  default :
    return self.nnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {

    switch self.nnf {
    case .disjunction:
      var operands = self.nnf.disjunctionOperands
      if let firstConjunction = operands.first(where : {if case .conjunction = $0 {
        return true
      }
    return false}) {
      if case let .conjunction(a, b) = firstConjunction {
        operands.remove(firstConjunction)
        var res : Formula?
        for op in operands {
          if res != nil {
            res = res! || op
          }
          else{
            res = op
          }
        }
        res = (a.cnf || res!.cnf) && (b.cnf || res!.cnf)
        if res != nil {return res!.cnf}
      }
    }
    return self.nnf
  case .conjunction:
    var operands = self.nnf.conjunctionOperands
    for op in operands {
      for op2 in operands {
        if op.disjunctionOperands.isSubset(of:op2.disjunctionOperands) && op2 != op {
          operands.remove(op2)
        }
      }
    }
    var res: Formula?
    for op in operands {
      if res != nil {
        res = res! && op
      }
      else{
        res = op
      }
    }
    return res!
    default :
    return self.nnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {

    var output = Set<Set<Formula>>()
    switch self {
    case .disjunction(_, _):
      for operand in self.disjunctionOperands {
        output.insert(operand.conjunctionOperands)
      }
      return output
    default:
      return output
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {

    var output = Set<Set<Formula>>()
    switch self {
    case .conjunction(_, _):
      for operand in self.conjunctionOperands {
        output.insert(operand.disjunctionOperands)
      }
      return output
    default:
      return output
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
