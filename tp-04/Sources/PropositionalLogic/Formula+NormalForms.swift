extension Formula {
  /// The negation normal form of the formula.
  public var nnf: Formula {
 // Write your code here.
 switch self{
           case .constant(let p):
               return p ? true : false
           case .proposition(_):
               return self
           case .disjunction(let p, let q):
               return (p).nnf || (q).nnf
           case .conjunction(let p, let q):
               return (p).nnf && (q).nnf
           case .implication(let p, let q):
               return (!p).nnf || (q).nnf
           case .negation(let p):
           switch p{
                   case .constant(let t):
                         return t ? false : true
                   case .disjunction(let t, let q):
                         return (!t).nnf && (!q).nnf
                   case .conjunction(let t, let q):
                       return (!t).nnf || (!q).nnf
                   case .implication(let t, let q):
                         return (t).nnf && (!q).nnf
                   case .negation(let t):
                         return t.nnf
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
        var operandes = self.nnf.conjunctionOperands
        if let firstDisjunction = operandes.first(where: { if case  .disjunction = $0 {
          return true
        }
        return false }) {
            if case let .disjunction(a, b) = firstDisjunction {
              operandes.remove(firstDisjunction)
              var resultat : Formula?
              for operande in operandes{
                if resultat != nil  {
                  resultat = resultat! && operande
                }
                else {
                  resultat = operande
                }
              }
            resultat = (a.dnf && resultat!.dnf) || (b.dnf && resultat!.dnf)
            if resultat != nil { return resultat!.dnf}
            }
        }
        return self.nnf
      case .disjunction:
        var operandes = self.disjunctionOperands
        for operande in operandes{
          for operande2 in operandes{
            if operande.conjunctionOperands.isSubset(of:operande2.conjunctionOperands) && operande2 != operande {
              operandes.remove(operande2)
            }
          }
        }
        var resultat : Formula?
        for operande in operandes{
          if resultat != nil  {
            resultat = resultat! || operande
          }
          else {
            resultat = operande
          }
        }
        return resultat!
      default :
        return self.nnf
      }
    }
  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
   switch self.nnf {
   case .disjunction:
     var operandes = self.nnf.disjunctionOperands
     if let conjonction = operandes.first(where: { if case  .conjunction = $0 {
       return true
     }
     return false }) {
         if case let .conjunction(a, b) = conjonction {
           operandes.remove(conjonction)
           var resultat : Formula?
           for operande in operandes{
             if resultat != nil  {
               resultat = resultat! || operande
             }
             else {
               resultat = operande
             }
           }
         resultat = (a.cnf || resultat!.cnf) && (b.cnf || resultat!.cnf)
         if resultat != nil { return resultat!.cnf}
         }
     }
     return self.nnf
   case .conjunction:
     var operandes = self.nnf.conjunctionOperands
     for operande in operandes{
       for operande2 in operandes{
         if operande.disjunctionOperands.isSubset(of:operande2.disjunctionOperands) && operande2 != operande {
           operandes.remove(operande2)
         }
       }
     }
   var resultat : Formula?
     for operande in operandes{
       if resultat != nil  {
         resultat = resultat! && operande
       }
       else {
         resultat = operande
       }
     }
     return resultat!
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
            for operande in self.disjunctionOperands {
                output.insert(operande.conjunctionOperands)
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
           for operande in self.conjunctionOperands {
               output.insert(operande.disjunctionOperands)
           }
           return output
       default:
           return output
       }
   }
  /// Unfold a tree of binary disjunctions into a set of operandes.
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
  /// Unfold a tree of binary conjunctions into a set of operandes.
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
