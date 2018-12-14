extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self{
    case .constant(let a):
      return a ? true : false
    case .proposition(_):
      return self
    case .disjunction(let a,let b):
      return a.nnf || b.nnf
    case .conjunction(let a,let b):
      return b.nnf && a.nnf
    case .implication(let a,let b):
      return !a.nnf || b.nnf
    case .negation(let a):
      return !a

      switch a {
      case .constant(let c):
        return c ? false : true
      case .disjunction(let c,let b):
        return !c.nnf && !b.nnf
      case .conjunction(let c,let b):
        return !c.nnf || !b.nnf
      case .implication(let c,let b):
        return c.nnf && !b.nnf
      case .negation(let c):
        return c.nnf

      case .proposition(_):
        return self
      }
    }

  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    let result = self.nnf

    switch result{
     case .constant(let p):
         return p ? true : false
     case .proposition(_):
         return self
     case .conjunction(let a, let b):

       let c = a.dnf
       let d = b.dnf
         switch (c, d){
         case (.disjunction(let p,let q),_):
                       return (p && d ) || (q && d)
                 case (_,.disjunction(let p,let q)):
                       return (c && p) || (c && q)
                 default:
                       return c && d
         }
     case .disjunction(let a, let b):
           return a.dnf || b.dnf
     default:
       return result
   }


}

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    let nnf = self.nnf
    switch nnf {
    case .disjunction:
        var operands = nnf.disjunctionOperands
        if let firstConjunction = operands.first(where: {
                switch $0{
                case .conjunction(_,_):
                      return true
                default:
                    return false
          }
            }) {
         if case let .conjunction(lhs, rhs) = firstConjunction {
         operands.remove(firstConjunction)
         var result : Formula!
         for op in operands {
            if result != nil  {
                result = result || op
              }
                else {
                result = op
               }
        }
        result = (lhs.cnf || result.cnf) && (rhs.cnf || result.cnf)
        return result.cnf
          }
        }
        return nnf
        case .conjunction:
            var operands = nnf.conjunctionOperands
                for op in operands {
                    for op1 in operands {
                        if op.disjunctionOperands.isSubset(of: op1.disjunctionOperands) && op1 != op {
                              operands.remove(op1)
                        }
                    }
                }
             var result : Formula?
             for op in operands {
                  if result != nil  {
                      result = result! && op
                    }
                  else {
                        result = op
                    }
                }
                return result!
            default :
                return nnf
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
