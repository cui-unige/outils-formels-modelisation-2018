extension Formula {

   public var nnf: Formula {
     switch self {
     case .negation(let a):
       switch a {
       case .constant(let b):
         return Formula.constant(!b)
       case .proposition:
         return self
       case .negation(let b):
         return b.nnf
       case .conjunction(let b, let c): // si A∧B, on change en !A∨!B
         return !b.nnf || !c.nnf
       case .disjunction(let b, let c): // si A∨B, on change en !A∧!B
         return !b.nnf && !c.nnf
       case .implication(let b, let c):  // A → B = !AVB, on change en A∧!B
         return b.nnf && !c.nnf
       }
     case .implication(let a, let b): // si A → B = !AVB,
       return !a.nnf || b.nnf
     case .conjunction(let a, let b): // si conjonction  A∧B
         return a.nnf && b.nnf
 	 case .disjunction(let a, let b): // si  disjonction A∨B
       return a.nnf || b.nnf
     default :
       return self
     }
   }
   /// The disjunctive normal form (DNF) of the formula.
   public var dnf: Formula {
     switch self.nnf {
     case .conjunction:
       var variables = self.nnf.conjunctionOperands
       if let disjonctionTrouvee = variables.first(where: {
 	if case  .disjunction = $0 {
         	return true
       }
 	return false } ) {
           if case let .disjunction(a, b) = disjonctionTrouvee {
             variables.remove(disjonctionTrouvee)
             var resultat : Formula?
             for operande in variables {
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
       var variables = self.disjunctionOperands
       for operandeA in variables {
         for operandeB in variables {
           if operandeA.conjunctionOperands.isSubset(of:operandeB.conjunctionOperands) && operandeB != operandeA {
             variables.remove(operandeB)
           }
         }
       }
       var resultat : Formula?
       for operandeA in variables {
         if resultat != nil  {
           resultat = resultat! || operandeA
         }
         else {
           resultat = operandeA
         }
       }
       return resultat!
     default :
       return self.nnf
     }
   }

   /// The conjunctive normal form (CNF) of the formula.
   public var cnf: Formula {
     switch self.nnf {
     case .disjunction:
       var variables = self.nnf.disjunctionOperands
       if let firstConjunction = variables.first(where: { if case  .conjunction = $0 {
         return true
       }
       return false }) {
           if case let .conjunction(a, b) = firstConjunction {
             variables.remove(firstConjunction)
             var resultat : Formula?
             for operandeA in variables {
               if resultat != nil  {
                 resultat = resultat! || operandeA
               }
               else {
                 resultat = operandeA
               }
             }
           resultat = (a.cnf || resultat!.cnf) && (b.cnf || resultat!.cnf)
           if resultat != nil { return resultat!.cnf}
           }
       }
       return self.nnf
     case .conjunction:
       var variables = self.nnf.conjunctionOperands
       for operandeA in variables {
         for operandeB in variables {
           if operandeA.disjunctionOperands.isSubset(of:operandeB.disjunctionOperands) && operandeB != operandeA {
             variables.remove(operandeB)
           }
         }
       }
       var resultat : Formula?
       for operandeA in variables {
         if resultat != nil  {
           resultat = resultat! && operandeA
         }
         else {
           resultat = operandeA
         }
       }
       return resultat!
     default :
       return self.nnf
     }
   }

   /// The minterms of a formula in disjunctive normal form.
   public var minterms: Set<Set<Formula>> {
     switch self {
     case .disjunction:
       let operands = self.disjunctionOperands
       var resultat : Set<Set<Formula>> = []
       for operande in operands {
         resultat.insert(operande.conjunctionOperands)
       }
       return resultat
     default:
       return []
     }
   }
   /// The maxterms of a formula in conjunctive normal form.
   public var maxterms: Set<Set<Formula>> {
     switch self {
     case .conjunction:
       let operands = self.conjunctionOperands
       var resultat : Set<Set<Formula>> = []
       for operande in operands {
         resultat.insert(operande.disjunctionOperands)
       }
       return resultat
     default:
       return []
     }
   }

   private var disjunctionOperands: Set<Formula> {
     switch self {
     case .disjunction(let a, let b):
       return a.disjunctionOperands.union(b.disjunctionOperands)
     default:
       return [self]
     }
   }

   private var conjunctionOperands: Set<Formula> {
     switch self {
     case .conjunction(let a, let b):
       return a.conjunctionOperands.union(b.conjunctionOperands)
     default:
       return [self]
     }
   }
 }
