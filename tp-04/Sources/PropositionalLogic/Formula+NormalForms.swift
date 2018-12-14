extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch (self) {
    case .constant(_):
        return self

      case .proposition(_):
        return self

      case .negation(let c):
        switch(c){
            case .negation(c):
              return .negation(c)
            case .constant:
              return .negation(c)
            case .conjunction(let a, let b):
              return .disjunction( (!a).nnf , (!b).nnf)
            case .disjunction(let a, let b):
              return .conjunction( (!a).nnf, (!b).nnf)
            case .implication(let a, let b):
              return .conjunction( a.nnf, (!b).nnf)
            case .proposition:
              return .negation(c)
            default:
              return self
        }
      case .disjunction(let a, let b):
        return .disjunction( a.nnf, b.nnf)

      case .conjunction(let a, let b):
        return .conjunction( a.nnf, b.nnf)

      case .implication(let a, let b):
        return .disjunction(  (!a).nnf, b.nnf);


    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    var resultInter: Formula? = nil

    switch self.nnf { //On enlève les implications
      case .conjunction:
        var clauses = self.nnf.conjunctionOperands //Toutes les clauses disjonctives
        if let first = clauses.first{ //On prend la première clause disjonctive
          if case let .disjunction(a, b) = first{ //On "casse" la clause first pour la séparer en clause a et et clause b
            clauses.remove(first) //On enlève la clause car on l'a "cassé"
            let next = clauses.first //On prend la nouvelle première clause

            return (a.dnf && next!.dnf) || (b.dnf && next!.dnf) //On retourne de manière récursive les formules (même a et b car il est possible que toutes les clauses à l'intérieur ne soient pas en fnd)
          }
        }
        return self.nnf

      case .disjunction: //Pour la réduction d'une clause disjonctive
        var clauses = self.nnf.disjunctionOperands //Toutes les clauses conjonctives
        for clause in clauses{
            for clause2 in clauses{
              //Comparaison de toutes les clauses entre elles pour pouvoir supprimer celles qui sont équivalentes
              if clause != clause2 && clause.conjunctionOperands.isSubset(of: clause2.conjunctionOperands){
                clauses.remove(clause2)
              }
            }
        }
        resultInter = clauses.first //
        clauses.remove(resultInter!) //On supprime pour ne pas avoir de redondances

        for clause in clauses{
          resultInter = resultInter! || clause //disjonction
        }
        return resultInter!

      default:
        return self.nnf
    }


  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    return self
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .disjunction: //Dans le cas d'une disjonction (||)
        let clauses = self.disjunctionOperands //On prend toutes les clauses
        var results : Set<Set<Formula>> = [] //Ensemble d'ensemble de formules ()
        for clause in clauses {
          results.insert(clause.conjunctionOperands) // On ajoute l'ensemble d'opérandes de la clause dans l'ensmeble results
        }
        return results

      default: //Si pas en fnd, on renvoie un ensemble vide.
        return []
      }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
    case .conjunction: //Dans le cas d'une conjonction (&&)
      let clauses = self.conjunctionOperands //On prend toutes les clauses
      var results : Set<Set<Formula>> = [] //Ensemble d'ensemble des formules
      for clause in clauses {
        results.insert(clause.disjunctionOperands) //On ajoute dans l'ensemble results l'ensemble d'opérande(s) de la clause
      }
      return results

    default: //Si pas en forme normale conjonctive on renvoie un ensemble vide.
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
