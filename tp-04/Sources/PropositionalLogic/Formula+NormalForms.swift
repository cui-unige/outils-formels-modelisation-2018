extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self {
    case .conjunction(let a, let b):
      if a == b {
        return a.nnf // a && a <=> a
      }
      else {
        return a.nnf && b.nnf
    }
    case .disjunction(let a, let b):
      if a == b {
        return a.nnf // a || a <=> a
      }
      else {
        return a.nnf || b.nnf
      }
    case .implication(let a, let b):
      return !a.nnf || b.nnf // a=>b <=> !a || b
    case .negation(let a):
      switch a {
      case .constant(let b):
        return .constant(!b) // !b <=> !b (eh oui, je sais, il fallait y penser)
      case .negation(let b):
        return b.nnf // !!b <=> b
      case .conjunction(let b, let c):
        return !b.nnf || !c.nnf // !(b && c) <=> !b || !c
      case .disjunction(let b, let c):
        return !b.nnf && !c.nnf // !(b || c) <=> !b && !c
      case .implication(let b, let c):
        return b.nnf && !c.nnf // !(b=>c) <=> b || !c
      default:
        return self // Cas d'une proposition, qui du coup ne change pas
      }
    default : // Tous les autre cas sont biens tel quel
      return self
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    switch self.nnf {
    case .conjunction:
      var operandes = self.nnf.conjunctionOperands
      if let disjunction = operandes.first(where: {
				if case  .disjunction = $0 {
        	return true
      }
    return false } ) {
          if case let .disjunction(a, b) = disjunction {
            operandes.remove(disjunction)
            var result : Formula?
            for operande in operandes {
              if result != nil  {
                result = result! && operande
              }
              else {
                result = operande
              }
            }
          result = (a.dnf && result!.dnf) || (b.dnf && result!.dnf)
          if result != nil { return result!.dnf}
          }
      }
      return self.nnf
    case .disjunction: // ∨
      var operandes = self.disjunctionOperands
      for operande1 in operandes {
        for operande2 in operandes {
          if operande1.conjunctionOperands.isSubset(of:operande2.conjunctionOperands) && operande2 != operande1 { // si sous-ensembles et différents
            operandes.remove(operande2)
          }
        }
      }
      var result : Formula?
      for operande1 in operandes {
        if result != nil  {
          result = result! || operande1
        }
        else {
          result = operande1
        }
      }
      return result!
    default :
      return self.nnf
    }
  }
   /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    switch self.nnf {
    case .disjunction:
      var operandes = self.nnf.disjunctionOperands
      if let conjunction = operandes.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, b) = conjunction {
            operandes.remove(conjunction)
            var result : Formula?
            for operande in operandes {
              if result != nil  {
                result = result! || operande
              }
              else {
                result = operande
              }
            }
          result = (a.cnf || result!.cnf) && (b.cnf || result!.cnf)
          if result != nil {
          return result!.cnf}
          }
      }
      return self.nnf
    case .conjunction:
      var operandes = self.nnf.conjunctionOperands
      for operande1 in operandes {
        for operande2 in operandes {
          if operande1.disjunctionOperands.isSubset(of:operande2.disjunctionOperands) && operande2 != operande1 {
            operandes.remove(operande2)
          }
        }
      }
      var result : Formula?
      for operande1 in operandes {
        if result != nil  {
          result = result! && operande1
        }
        else {
          result = operande1
        }
      }
      return result!
    default :
      return self.nnf
    }
  }

   /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    var minTerms : Set<Set<Formula>> = []
    switch self {
    case .disjunction:
      for operand in self.disjunctionOperands {
        minTerms.insert(operand.conjunctionOperands) // On insère les operandes de la conjontion dans nos minTerms
      }
      return minTerms
    default:
      return minTerms // On retourne une liste vide
    }
   }

   /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    var maxTerms : Set<Set<Formula>> = []
    switch self {
    case .conjunction:
      for operand in self.conjunctionOperands {
        maxTerms.insert(operand.disjunctionOperands) // On insère les operandes de la disjonction dans nos maxTerms
      }
      return maxTerms
    default:
      return maxTerms // On retourne une liste vide
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
