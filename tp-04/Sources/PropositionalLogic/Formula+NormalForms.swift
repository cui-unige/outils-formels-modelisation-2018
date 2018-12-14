extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self {
    case .implication(let a, let b):          // a => b devient !a || b
        return !a.nnf || b.nnf
      case .disjunction(let a, let b):        // a || b ne change pas
        return a.nnf || b.nnf
      case .conjunction(let a, let b):        // a && b ne change pas
        return a.nnf && b.nnf
      case .constant(let a):                  // a ne change pas
        return a ? true : false
      case .proposition:                      // la proposition ne change pas
        return self
      case .negation(let a):                  // On vérifie le contenu de la négation
          switch a {
          case .implication(let a, let b):    // !(a => b) devient a && !b
              return a.nnf && !b.nnf
            case .disjunction(let a, let b):  // !(a || b) devient !a && !b
              return !a.nnf && !b.nnf
            case .conjunction(let a, let b):  // !(a && b) devient !a || !b
              return !a.nnf || !b.nnf
            case .negation(let a):            // !(!a) devient a
              return a.nnf
            case .constant(let a):            // a devient !a
              return a ? false : true
            case .proposition:                // la proposition ne change pas
              return self
            }
    }

  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf {                         // les négations doivent être distribuées
      case .conjunction(let a, let b):
        switch (a.dnf, b.dnf) {
          case (_, .disjunction(let c, let d)):   // On distribue le && pour avoir l'expression en dnf dans le cas où b est une disjonction
            return (c.dnf && a.dnf) || (d.dnf && a.dnf)
          case (.disjunction(let c, let d), _):   // Pareil si a est une disjonction
            return (c.dnf && b.dnf) || (d.dnf && b.dnf)
          default:                                // Sinon on retourne a && b
            return a.dnf && b.dnf
        }
      default:                                    // Si ce n'est pas une conjonction on retourne self.nnf
        return self.nnf
    }

  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    switch self.nnf {                         // les négations doivent être distribuées
      case .disjunction(let a, let b):
        switch (a.cnf, b.cnf) {
          case (_, .conjunction(let c, let d)):   // On distribue le || pour avoir l'expression en cnf dans le cas où b est une conjonction
            return (c.cnf || a.cnf) && (d.cnf || a.cnf)
          case (.conjunction(let c, let d), _):   // Pareil si a est une conjonction
            return (c.cnf || b.cnf) && (d.cnf || b.cnf)
          default:                                // Sinon on retourne a || b
            return a.cnf || b.cnf
        }
      default:                                    // Si ce n'est pas une disjonction on retourne self.nnf
        return self.nnf
    }

  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
      case .disjunction:                                // Dans le cas ou self est une disjonction
        var resultat : Set<Set<Formula>> = []           // On initialise le tableau qui contient les termes voulus
        for op in self.disjunctionOperands {            // On boucle sur les opérandes du tableau donné par disjunctionOperands
          resultat.insert(op.conjunctionOperands)       // On ajoute au tableau resultat le tableau donné par conjunctionOperands appliqué à chaque op
        }
        return resultat                                 // On retourne le resultat
      default:
        return [[self]]                                 // Sinon on retourne [[self]]
    }

  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .conjunction:                                  // Dans le cas ou self est une conjonction
        var resultat : Set<Set<Formula>> = []           // On initialise le tableau qui contient les termes voulus
        for op in self.conjunctionOperands {              // On boucle sur les opérandes du tableau donné par conjunctionOperands
          resultat.insert(op.disjunctionOperands)       // On ajoute au tableau resultat le tableau donné par disjunctionOperands appliqué à chaque op
        }
        return resultat                                 // On retourne le resultat
      default:
        return [[self]]                                 // Sinon on retourne [[self]]
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
