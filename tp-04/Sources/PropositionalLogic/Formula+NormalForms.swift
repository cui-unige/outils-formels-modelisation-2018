extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self {
    case .constant(let const):
      return const ? true : false
    case .proposition(_):
      return self
    case .disjunction(let a_ou , let b):
      return (a_ou).nnf && (b).nnf
    case .conjunction(let a_et , let b):
      return (a_et).nnf || (b).nnf
    case .implication(let a_implique,let b):
      return (!a_implique).nnf || (b).nnf
    case .negation(let formula):

          switch formula{
            case .negation(let neg):
              return neg.nnf
            case .disjunction(let a_ou , let b):
              return((!a_ou).nnf) && ((!b).nnf)
            case .conjunction(let a_et , let b):
              return ((!a_et).nnf) || ((!b).nnf)
            case .implication(let a_implique,let b):
              return (a_implique).nnf && (!b).nnf
            case .constant(let cons):
              return cons ? false : true
            case .proposition(_):
              return self
        }
      }
    }



public var dnf: Formula {


        switch self.nnf {
        case .conjunction(let a_et, let b_et):
            switch (a_et.dnf, b_et.dnf) {
            case (.disjunction(let a_ou, let b_ou), _):
                return (a_ou.dnf && b_et.dnf) || (b_ou.dnf && b_et.dnf)
            case (_, .disjunction(let a_ou, let b_ou)):
                return (a_ou.dnf && a_et.dnf) || (b_ou.dnf && a_et.dnf)
            default:
                return a_et.dnf && b_et.dnf
            }
        default:
            return self.nnf
        }

    }

public var cnf: Formula {

       switch self.nnf {
       case .disjunction(let a_ou, let b_ou):
           switch (a_ou.cnf, b_ou.cnf) {
           case (.conjunction(let a_et, let b_et), _):
               return (a_et.cnf || b_ou.cnf) && (b_et.cnf || b_ou.cnf)
           case (_, .conjunction(let a_et, let b_et)):
               return (a_et.cnf || a_ou.cnf) && (b_et.cnf || a_ou.cnf)
           default:
               return a_ou.cnf || b_ou.cnf
           }
       default:
           return self.nnf
       }

   }


  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
        switch self {
        case .disjunction:
            var result : Set<Set<Formula>> = []
            for operand in self.disjunctionOperands {
                result.insert(operand.conjunctionOperands)
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
            var resultat : Set<Set<Formula>> = []
            let operands = self.conjunctionOperands
            for operande in operands {
                resultat.insert(operande.disjunctionOperands)
            }
            return resultat
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
