extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    return self
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    return self
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    return self
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
