extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self{

    case .conjunction(let a, let b): return a.nnf && b.nnf
    case .disjunction(let a, let b): return a.nnf || b.nnf
    case .implication(let a, let b): return !a.nnf || b.nnf // a implique b = !a or b
    case .negation(let a):
        switch a{
        case .constant(let b): return Formula.constant(!b) //On retourne la négation
        case .negation(let b): return b.nnf //On renvoie b dans la fonction par recursivité
        case .proposition: return self //Déjà en nnf
        case .implication(let b, let c): return b.nnf && !c.nnf //a implique b = !a ou b devient a and !b
        case .conjunction(let b, let c): return !b.nnf || !c.nnf //a and b en devient !a or !b
        case .disjunction(let b, let c): return !b.nnf && !c.nnf //a or b devient !a and !b
        }

    default: return self
  }
}

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf{

    case .conjunction:
        var operandes = self.nnf.conjunctionOperands
        if let disjunction = operandes.first(
            where:{if case .disjunction = $0{return true}
        return false}){
        if case let .disjunction(a,b) = disjunction{
            operandes.remove(disjunction)
            var resultat: Formula?
            for operande in operandes {
                if resultat != nil{resultat = resultat! && operande}
                else{resultat = operande}
            }
            resultat = (a.dnf && resultat!.dnf) || (b.dnf && resultat!.dnf)
            if resultat != nil {return resultat!.dnf}
            }
        }
        return self.nnf
    case .disjunction: var operandes = self.disjunctionOperands
        for operande_i in operandes{
            for operande_j in operandes{
                if operande_i.conjunctionOperands.isSubset(of:operande_j.conjunctionOperands) && operande_i != operande_j{
                    operandes.remove(operande_j)
                }
            }
        }
        var resultat: Formula?
        for operande_i in operandes {
            if resultat != nil {
                resultat = resultat! || operande_i
            }
            else{resultat = operande_i}
        }
        return resultat!

    default : return self.nnf
  }
}

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    switch self.nnf {
    case .disjunction: var operandes = self.nnf.disjunctionOperands
        if let conjunction1 = operandes.first(where: { if case  .conjunction = $0 {
            return true
        }
        return false }) {
        if case let .conjunction(a, b) = conjunction1 {
            operandes.remove(conjunction1)
            var resultat : Formula?
            for operande_i in operandes {
                if resultat != nil  {
                resultat = resultat! || operande_i
            }
            else {
                resultat = operande_i
            }
        }
        resultat = (a.cnf || resultat!.cnf) && (b.cnf || resultat!.cnf)
        if resultat != nil { return resultat!.cnf}
        }
    }
    return self.nnf

    case .conjunction:
        var operandes = self.nnf.conjunctionOperands
        for operande_i in operandes {
            for operande_j in operandes {
                if operande_i.disjunctionOperands.isSubset(of:operande_j.disjunctionOperands) && operande_j != operande_i {
                    operandes.remove(operande_j)
                }
            }
        }
        var resultat : Formula?
        for operande_i in operandes {
            if resultat != nil  {
                resultat = resultat! && operande_i
            }
            else {
                resultat = operande_i
            }
        }
        return resultat!
    default : return self.nnf
    }
  }


  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    var resultat : Set<Set<Formula>> = []

    switch self{
    case .disjunction: let operandes = self.disjunctionOperands
        for operande in operandes{
            resultat.insert(operande.conjunctionOperands)
        }
        return resultat
    default: return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
      // Write your code here.
    var resultat : Set<Set<Formula>> = []

    switch self {
        case .conjunction: let operandes = self.conjunctionOperands
            for operande in operandes {
                resultat.insert(operande.disjunctionOperands)
            }
            return resultat
        default: return []
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
