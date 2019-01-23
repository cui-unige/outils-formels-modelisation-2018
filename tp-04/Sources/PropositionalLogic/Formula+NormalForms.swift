extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self {
    case .constant(let p):
      // si p est vrai on retourne p sinon on retourne faux
      return p ? true : false
    case .proposition(_):
      return self
    case .disjunction(let p, let q):
      // p OU q
      return (p).nnf || (q).nnf
    case .conjunction(let p, let q):
      // p ET q
      return (p).nnf && (q).nnf
    case .implication(let p, let q):
      // non p OU q
      return (!p).nnf || (q).nnf
    // négation de la formule
    case .negation(let p):
      switch p {
      case .constant(let t):
        // si t est faux on retourne t sinon retourne vrai
        return t ? false : true
      case .disjunction(let t, let q):
        // Loi de Morgan : non(t OU q) == non(t) ET non(q)
        return (!t).nnf && (!q).nnf
      case .conjunction(let t, let q):
        // Loi de Morgan : non(t ET q) == non(t) OU non(q)
        return (!t).nnf || (!q).nnf
      case .implication(let t, let q):
        // Implication : non(t implique q) == t ET non(q)
        return (t).nnf && (!q).nnf
      case .negation(let t):
        // non(t)
        return t.nnf
      case .proposition(_):
        return self
      }
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.

    /*les négations doivent être sur les variables pour avoir la conjunctive en forme normale*/
    switch self.nnf {
     case .conjunction:
       // séparation sur les opérandes
       var operands = self.nnf.conjunctionOperands
       // itération sur les opérandes et arrêt à la première disjonction
       if let foundDisjunction = operands.first(where: { if case  .disjunction = $0 {
         // assignation à la variable
         return true
       }
       return false }) {
           if case let .disjunction(a, b) = foundDisjunction {
             operands.remove(foundDisjunction)
             // variable res type : Formula
             var res : Formula?
             for op in operands {
               if res != nil  {
                 res = res! && op
               }
               else {
                 res = op
               }
             }
           // développement du résultat en conjunctive forme normale
           res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf)
           if res != nil { return res!.dnf}
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
    // Write your code here.
    switch self.nnf {
    case .disjunction:
     var operands = self.nnf.disjunctionOperands
     if let firstConjunction = operands.first(where: { if case  .conjunction = $0 {
       return true
     }
     return false }) {
         if case let .conjunction(a, b) = firstConjunction {
           operands.remove(firstConjunction)
           var res : Formula?
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
     for op in operands {
       for op1 in operands {
         if op.disjunctionOperands.isSubset(of:op1.disjunctionOperands) && op1 != op {
           operands.remove(op1)
         }
       }
     }
   var res : Formula?
     for op in operands {
       if res != nil  {
         res = res! && op
       }
       else {
         res = op
       }
     }
     // retourne le contraire du résultat
     return res!
   default :
     return self.nnf
    }

  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
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
    // Write your code here.

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
