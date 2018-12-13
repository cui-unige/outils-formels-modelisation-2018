extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {

    switch self{
               case .constant(let p):
                   return p ? true : false
               case .proposition(_):
                   return self
               case .disjunction(let p, let q): // OU
                return (p).nnf || (q).nnf // Forme retourée

               case .conjunction(let p, let q): // ET
                   return (p).nnf && (q).nnf

               case .implication(let p, let q): // NON p OU q
                   return (!p).nnf || (q).nnf
               case .negation(let p): // Négation
               switch p{
                       case .constant(let t):
                             return t ? false : true
                       case .disjunction(let t, let q): // t OU q
                             return (!t).nnf && (!q).nnf // Forme retourée

                       case .conjunction(let t, let q): // t ET q
                           return (!t).nnf || (!q).nnf

                       case .implication(let t, let q): // NON (t OU NON q)
                             return (t).nnf && (!q).nnf

                       case .negation(let t): // NON
                             return t.nnf     //Résultat
                       case .proposition(_):
                           return self
                     }
                }
              }


  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula
  {

    switch self.nnf
    {
          case .conjunction:
              var operands = self.nnf.conjunctionOperands
              if let firstDisjunction = operands.first(where: { if case  .disjunction = $0 {
          return true }

          return false })
          {
                if case let .disjunction(a, b) = firstDisjunction
                {
                  operands.remove(firstDisjunction)
                  var res : Formula?
                  for op in operands {
                    if res != nil  { // si  res est non nil
                      res = res! && op
                    }
                    else {
                      res = op //sinon
                    }
                  }
                res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf) // OU
                if res != nil { return res!.dnf}
                }
            }
            return self.nnf
          case .disjunction:
            var operands = self.disjunctionOperands
            for op in operands {
              for op1 in operands {
                if op.conjunctionOperands.isSubset(of:op1.conjunctionOperands) && op1 != op { //if : Sous-ensembles de op1
                  operands.remove(op1) //Alors retirer opl
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
   case .conjunction: // AND
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
     return res! // lE résultat retourné est le contraire de res
   default :
     return self.nnf
   }
}

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {

    var output = Set<Set<Formula>>()
          switch self {
          case .disjunction(_, _): // OR
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
         case .conjunction(_, _): // conjonction AND
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
