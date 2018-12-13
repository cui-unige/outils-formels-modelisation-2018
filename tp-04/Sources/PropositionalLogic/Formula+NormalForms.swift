extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self {
    case Formula.negation(let a):
      switch a {
        case Formula.constant(let b):
          return Formula.constant(!b)
        case Formula.proposition:
          return self
        case Formula.negation(let b):
          return b.nnf
        case Formula.conjunction(let b, let c):
          return !b.nnf || !c.nnf
        case Formula.disjunction(let b, let c):
          return !b.nnf && !c.nnf
        case Formula.implication(let b, let c):
          return b.nnf && !c.nnf
      }
    case Formula.implication(let a, let b):
      return !a.nnf || b.nnf
    case Formula.conjunction(let a, let b):
      return a.nnf && b.nnf
    case Formula.disjunction(let a, let b):
      return a.nnf || b.nnf
    default :
      return self
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf {
    case .disjunction:
      var tempOperands = self.disjunctionOperands
      for operatorA in tempOperands {
        for operatorSUP in tempOperands {
          if operatorA.conjunctionOperands.isSubset(of:operatorSUP.conjunctionOperands) && operatorSUP != operatorA { //Si les opérandes de conjonction de op sont sous-ensembles des opérandes de conjonction de op1
            tempOperands.remove(operatorSUP)
          }
        }
      }
      var reponse : Formula?
      for operatorA in tempOperands {
        if reponse != nil  {
          reponse = reponse! || operatorA
        }
        else {
          reponse = operatorA
        }
      }
      return reponse!
    case Formula.conjunction:
      var  tempOperands = self.nnf.conjunctionOperands
      if let origine = tempOperands.first(where: { if case  .disjunction = $0 {
        return true
      }
      return false }) {
          if case let Formula.disjunction(a, b) = origine {
            tempOperands.remove(origine)
            var disRetz : Formula?
            for operatorTm in tempOperands {
              if disRetz != nil  {
                disRetz = disRetz! && operatorTm
              }
              else {
                disRetz = operatorTm
              }
            }
          disRetz = (a.dnf && disRetz!.dnf) || (b.dnf && disRetz!.dnf)
          if disRetz != nil { return disRetz!.dnf}
          }
      }
      return self.nnf
    default :
      return self.nnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    switch self.nnf {
    case Formula.conjunction:
       var tempOperands = self.nnf.conjunctionOperands
       for operatorA in tempOperands {
         for operatorSUP in tempOperands {
           if operatorA.disjunctionOperands.isSubset(of:operatorSUP.disjunctionOperands) && operatorSUP != operatorA {
             tempOperands.remove(operatorSUP)
           }
         }
       }
       var A : Formula?
       for operatorRes in tempOperands {
         if A != nil  {
           A = A! && operatorRes
         }
         else {
           A = operatorRes
         }
       }
       return A!
     case Formula.disjunction:
      var tempOperands = self.nnf.disjunctionOperands
      if let firstConjunction = tempOperands.first(where: { if case  Formula.conjunction = $0 {
        return true
      }
      return false }) {
          if case let Formula.conjunction(a, b) = firstConjunction {
            tempOperands.remove(firstConjunction)
            var A : Formula?
            for operatorTm in tempOperands {
              if A != nil  {
                A = A! || operatorTm
              }
              else {
                A = operatorTm
              }
            }
            A = (a.cnf || A!.cnf) && (b.cnf || A!.cnf)
            if A != nil { return A!.cnf}
            }
      }
      return self.nnf
     default :
      return self.nnf
   }
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
