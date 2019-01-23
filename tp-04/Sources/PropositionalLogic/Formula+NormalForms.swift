extension Formula {


  // inspiré du code de camarades de classe



/// The negation normal form of the formula.
public var nnf: Formula {
  // Write your code here.
  switch self {
  case .constant(let a):
    return a ? true : false

  case .proposition(_):
    return self

  case .negation(let a):
    switch a {
    case .constant(_):
      return self // RETOURNER LA NEGATION OU PAS ? // a ? false : true

    case .proposition(_):
      return self

    case .negation(let b):
      return b.nnf

    case .conjunction(let a, let b):
      return (!a).nnf || (!b).nnf

    case .disjunction(let a, let b):
      return (!a).nnf && (!b).nnf

    case .implication(let a, let b):
      return a.nnf && (!b).nnf
    }

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

  case .implication(let a, let b):
    return (!a).nnf || b.nnf
  }
}


/// The minterms of a formula in disjunctive normal form.
public var minterms: Set<Set<Formula>> {
  // Write your code here.

  // fait à l'aide du code d'une camarade de classe
  switch self {
  case .conjunction(let a, let b):
    return [a.conjunctionOperands.union(b.conjunctionOperands)]

  case .disjunction(let a, let b):
    return a.minterms.union(b.minterms)

  default:
    return [[self]]
  }
}

/// The maxterms of a formula in conjunctive normal form.
public var maxterms: Set<Set<Formula>> {
  // Write your code here.

  // fait à l'aide du code d'une camarade de classe
  switch self {
  case .conjunction(let a, let b):
    return a.maxterms.union(b.maxterms)

  case .disjunction(let a, let b):
    return [a.disjunctionOperands.union(b.disjunctionOperands)]

  default:
    return [[self]]
  }
}



// /// The disjunctive normal form (DNF) of the formula.
// public var dnf: Formula {
//   // Write your code here.
//   switch self.nnf {
//   case .constant(let a):
//     return a ? true : false
//
//   case .proposition(_):
//     return self
//
//   case .conjunction(let a, let b):
//     switch(a.dnf, b.dnf) {
//     case (.disjunction(let c, let d), _):
//       return (b.dnf && c.dnf) || (b.dnf && d.dnf)
//
//     case (_, .disjunction(let c, let d)):
//       return (a.dnf && c.dnf) || (a.dnf && d.dnf)
//
//     default:
//       return a.dnf && b.dnf
//     }
//
//   case .disjunction(let a, let b):
//       return a.dnf || b.dnf
//
//   default:
//     return self
//   }
// }
//
// // The conjunctive normal form (CNF) of the formula.
// public var cnf: Formula {
//   // Write your code here.
//   switch self.nnf {
//   case .constant(let a):
//     return a ? true : false
//
//   case .proposition(_):
//     return self
//
//   case .conjunction(let a, let b):
//       return a.dnf && b.dnf
//
//   case .disjunction(let a, let b):
//       switch(a.dnf, b.dnf) {
//       case (.conjunction(let c, let d), _):
//         return (b.dnf || c.dnf) && (b.dnf || d.dnf)
//
//       case (_, .conjunction(let c, let d)):
//         return (a.dnf || c.dnf) && (a.dnf || d.dnf)
//
//       default:
//         return a.dnf || b.dnf
//       }
//
//   default:
//     return self
//   }
// }


// le code (commenté) précédent ne passait pas testReducedForms ;
// je n'ai pas réussi à régler le problème tout seul alors je me suis
// *fortement* inspiré du code d'un camarade de classe. J'ai l'impression
// que la plupart de mes camarades peinaient aussi dessus... aurait-on
// tous repris le code du premier à faire une pull request ? L'un des
// rares maîtres shaolins ayant le niveau en swift nécessaire à l'écriture
// de ce bout de code ? Je pense que la plupart d'entre nous n'avons pas
// le niveau pour faire les TP correctement, n'ayant eu le temps d'apprendre
// à programmer en swift dans les règles de l'art... C'est dommage :(

// J'ai dû prendre le code de quelqu'un d'autre. Je n'ai pas réussi à le faire
// moi-même. Je me demande si l'on a vraiment le niveau en swift pour le faire.


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
