extension Formula {

// Contributors: Mark Tropin, Bauch Saleh


  /// The negation normal form of the formula.
  public var nnf: Formula {
    // A formula is in NNF if we have negations only before atoms(variables).
    switch self {
    case .constant:
      return self
    case .proposition:
      return self
    case .implication(let op1, let op2):
      return !op1.nnf || op2.nnf // Implication is defined as (NOT A) OR B.
    case .conjunction(let op1, let op2):
        return op1.nnf && op2.nnf
	  case .disjunction(let op1, let op2):
      return op1.nnf || op2.nnf

      // For negation, we consider the multiple possibilities for the negated expression.
      // That's why we use a nested switch case:
    case .negation(let op1):
      switch op1 {
      case .constant(let opa):
        return Formula.constant(!opa)
      case .proposition:
        return self
      case .negation(let op1):
        return op1.nnf // Double negation
      case .conjunction(let opa, let opb):
        return !opa.nnf || !opb.nnf // DeMorgan's law
      case .disjunction(let opa, let opb):
        return !opa.nnf && !opb.nnf // DeMorgan's law
      case .implication(let opa, let opb):
        return opa.nnf && !opb.nnf // DeMorgan's law + def. of implication
      default:
        return op1
      }

    }
}

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    let goodSelf = self.nnf // For starters, we apply nnf to self
    switch goodSelf {
    case .conjunction(let opa, let opb):
        if case let .disjunction(opc, opd) = opa {
            return (opc.dnf && opb.dnf) || (opd.dnf && opb.dnf) // if the first one is a disjunction, we use distributivity
        } else if case let .disjunction(opc, opd) = opb {
            return (opa.dnf && opc.dnf) || (opa.dnf && opd.dnf) // if the second one is a disjunction, we use distributivity
        } else {
            return goodSelf
        }
    case .disjunction: // Reduced forms
        var ops = self.disjunctionOperands
        for op in ops {
            for op1 in ops {
                if op.conjunctionOperands.isSubset(of:op1.conjunctionOperands) && op1 != op {
                    ops.remove(op1) // If one op appears twice, we remove it
                }
            }
        }
        // Then we add all ops to the list
        var result: Formula?
        for op in ops {
            if result != nil  {
                result = result! || op
            } else {
                result = op
            }
        }
        return result!
    default:
        return goodSelf
    }
}

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    let goodSelf = self.nnf // For starters, we apply nnf to self
    switch goodSelf {
    case .disjunction(let opa, let opb):

        if case let .conjunction(opc, opd) = opa {
            return (opc.dnf || opb.dnf) && (opd.dnf || opb.dnf) // if the first one is a conjunction, we use distributivity
        } else if case let .disjunction(opc, opd) = opb {
            return (opa.dnf || opc.dnf) && (opa.dnf || opd.dnf) // if the second one is a conjunction, we use distributivity
        } else {
            return goodSelf
        }
    case .conjunction: // Reduced forms
        var ops = self.nnf.conjunctionOperands
        for op in ops {
            for op1 in ops {
                if op.disjunctionOperands.isSubset(of:op1.disjunctionOperands) && op1 != op {
                    ops.remove(op1) // If one op appears twice, we remove it
                }
            }
        }
        // Then we add all ops to the list
        var result : Formula?
        for op in ops {
            if result != nil  {
                result = result! && op
            }
            else {
                result = op
            }
        }
        return result!
    default:
        return goodSelf
    }
}
/// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
        // Write your code here.
        //
        var minterme_retour = Set<Set<Formula>>()

        switch self { // on controle dans un switch  si on a une conjonction (and) qui separe nos operandes dans self
        case .disjunction(_, _): // On utilise la disjonction (or)
            for operand in self.disjunctionOperands { //si on a une disjonction pour self
                minterme_retour.insert(operand.conjunctionOperands) //on insert les operandes dans notre variabe de retour minterme_retour
            }
            return minterme_retour // on renvoie notre variable de sortie
        default:
            return minterme_retour // dans le cas ou on est pas face a une disjonctions on fait rien et on renvoie notre variable de sortie
        }
}

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // idée similaire a minterme mais avec les conjonctions au lieux des disjonctions
       var maxterme_retour = Set<Set<Formula>>() // on initialise notre set qu'on renvoie
       switch self { // on controle dans un switch  si on a une conjonction (and) qui separe nos operandes dans self
       case .conjunction(_, _): // si on a une conjonction pour self
           for operand in self.conjunctionOperands { // on parcours les operandes du self
               maxterme_retour.insert(operand.disjunctionOperands) //on insert dans notre variable qu'on renvoie  maxterme_retour les operandes
           }
           return maxterme_retour // on renvoie notre variable de sortie
       default: // dans le cas ou on est pas face a une conjunction on fait rien et on renvoie notre variable de sortie
           return maxterme_retour
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
