extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {

    switch self {
    case .negation(let a):
      switch a { // On boucle sur différents types de a (p.ex a=c->d)
      case .constant(let b):
        return Formula.constant(!b)
      case .proposition:
        return self
      case .negation(let b):
        return b.nnf // C'est récursif
      case .conjunction(let b, let c):
        return !b.nnf || !c.nnf
      case .disjunction(let b, let c):
        return !b.nnf && !c.nnf
      case .implication(let b, let c):
        return b.nnf && !c.nnf
      }
    case .implication(let a, let b):
      return !a.nnf || b.nnf
    case .conjunction(let a, let b):
      if a == b {
        return a.nnf
      }
      else {
        return a.nnf && b.nnf
    }
    case .disjunction(let a, let b):
      if a == b {
        return a.nnf
      }
      else {
      return a.nnf || b.nnf
      }
    default :
      return self
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {

    switch self.nnf { // on commence avec nnf
    case .conjunction:
      var operands = self.nnf.conjunctionOperands
      if let firstDisjunction = operands.first(where: { if case  .disjunction = $0 {
        return true
      }
      return false }) {
          if case let .disjunction(a, b) = firstDisjunction {
            // enlève firstDisjunction de l'ensemble
            operands.remove(firstDisjunction)
            // declare res comme un optionnel (on ne peut pas utiliser des variables non déclarées)
            var res : Formula?
            // Construction du résultat
            for op in operands {
              if res != nil  {
                res = res! && op
              }
              else {
                res = op
              }
            }
          res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf)
          if res != nil { return res!.dnf} // Récurrence
          }
      }
      return self.nnf
    case .disjunction:
      var operands = self.disjunctionOperands
      // absorption
      for op in operands {
        for op1 in operands {
          if op.conjunctionOperands.isSubset(of:op1.conjunctionOperands) && op1 != op { //Si les opérandes de conjonction de op sont sous-ensembles des opérandes de conjonction de op1
            operands.remove(op1) //On supprime op1
          }
        }
      }
      // build result
      var res : Formula?
      for op in operands {
        if res != nil  {
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

    switch self.nnf { // On commence avec nnf
    case .disjunction:
      var operands = self.nnf.disjunctionOperands
      if let firstConjunction = operands.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, b) = firstConjunction {
            //On enlève firstconjonction de l'ensemble
            operands.remove(firstConjunction)
            // declare res comme un optionnel (on ne peut pas utiliser des variables non déclarées)
            var res : Formula?
            // Construction du résultat
            for op in operands {
              if res != nil  {
                res = res! || op
              }
              else {
                res = op
              }
            }
          res = (a.cnf || res!.cnf) && (b.cnf || res!.cnf)
          if res != nil { return res!.cnf}
          }
      }
      return self.nnf
    case .conjunction:
      var operands = self.nnf.conjunctionOperands
      // absorption
      for op in operands {
        for op1 in operands {
          if op.disjunctionOperands.isSubset(of:op1.disjunctionOperands) && op1 != op {
            operands.remove(op1)
          }
        }
      }
      // Construction du résultat
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
    default :
      return self.nnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {

    switch self {
    case .disjunction:
      let operands = self.disjunctionOperands
      // On initialise l'ensemble résultat
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
      // On initialise l'ensemble résultat
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
