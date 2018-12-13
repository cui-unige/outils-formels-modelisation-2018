extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self{
            case .constant(let p):
                return p ? true : false
            case .proposition(_):
                return self
            case .disjunction(let p, let q): // or
                return (p).nnf || (q).nnf // il faut retourner cette forme
            case .conjunction(let p, let q): // and
                return (p).nnf && (q).nnf // il faut retourner cette forme
            case .implication(let p, let q): // not p or q
                return (!p).nnf || (q).nnf // il faut retourner cette forme
            case .negation(let p): // not
            switch p{
                    case .constant(let t):
                          return t ? false : true
                    case .disjunction(let t, let q): // t or q
                          return (!t).nnf && (!q).nnf // il faut retourner cette forme
                    case .conjunction(let t, let q): // t and q
                        return (!t).nnf || (!q).nnf // il faut retourner cette forme
                    case .implication(let t, let q): // not (t or nit q)
                          return (t).nnf && (!q).nnf // il faut retourner cette forme
                    case .negation(let t): // not
                          return t.nnf // il faut retourner cette forme
                    case .proposition(_):
                        return self
            }
       }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf {
     case .conjunction:
       var operands = self.nnf.conjunctionOperands
       if let firstDisjunction = operands.first(where: { if case  .disjunction = $0 {
         return true
       }
       return false }) {
           if case let .disjunction(a, b) = firstDisjunction {
             operands.remove(firstDisjunction)
             var res : Formula?
             for op in operands {
               if res != nil  {
                 res = res! && op
               }
               else {
                 res = op // si le res est nil
               }
             }
           res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf) // or
           if res != nil { return res!.dnf}
           }
       }
       return self.nnf
     case .disjunction:
       var operands = self.disjunctionOperands
       for op in operands {
         for op1 in operands {
           if op.conjunctionOperands.isSubset(of:op1.conjunctionOperands) && op1 != op { //Si ce sont des sous-ensembles de op1
             operands.remove(op1) //On remove op1
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
             res = op // seulement si res est nil
           }
         }
       res = (a.cnf || res!.cnf) && (b.cnf || res!.cnf)
       if res != nil { return res!.cnf}
       }
   }
   return self.nnf
 case .conjunction: // and
   var operands = self.nnf.conjunctionOperands
   for op in operands {
     for op1 in operands {
       if op.disjunctionOperands.isSubset(of:op1.disjunctionOperands) && op1 != op {
         operands.remove(op1) //On les remove
       }
     }
   }
 var res : Formula? // comme ci-dessus on fait le résultat
   for op in operands {
     if res != nil  {
       res = res! && op
     }
     else {
       res = op
     }
   }
   return res! // On retourne le contraire de notre res
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
