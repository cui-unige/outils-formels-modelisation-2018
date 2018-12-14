extension Formula {
  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here
    switch(self){
      case .negation(let c):
        switch(c){
          case .negation(c):
            return .negation(c)
          case .constant:
            return .negation(c)
          case .conjunction(let a, let b):
            return .disjunction((!a).nnf , (!b).nnf)
          case .disjunction(let a, let b):
            return .conjunction((!a).nnf, (!b).nnf)
          case .implication(let a, let b):
            return .conjunction(a.nnf, (!b).nnf)
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
        return .disjunction((!a).nnf, b.nnf);
      case .constant(let c):
        return .constant(c);
      case .proposition(let p):
        return .proposition(p)
    }
  }
  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    var resultatInter : Formula? = nil
    switch (self.nnf){
      case .conjunction:
        var clauseDisjonctive = self.nnf.conjunctionOperands
        if let clauseOne = clauseDisjonctive.first{
          if case let .disjunction( a, b) = clauseOne{
              clauseDisjonctive.remove(clauseOne)
              let reste = clauseDisjonctive.first
              return (a.dnf && reste!.dnf)||(b.dnf && reste!.dnf)
           }
        }
        return self.nnf
      case .disjunction:
        var clauseConjonctive = self.disjunctionOperands
        for clause in clauseConjonctive{
          for other in clauseConjonctive{
            if clause.conjunctionOperands.isSubset(of: other.conjunctionOperands) && other != clause{
                 clauseConjonctive.remove(other)
            }
          }
        }
        resultatInter = clauseConjonctive.first
        clauseConjonctive.remove(resultatInter!)
        for clause in clauseConjonctive{
          resultatInter = resultatInter! || clause
        }
        return resultatInter!
      default :
        return self.nnf
    }
  }
  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    var resultatInter : Formula? = nil
    switch (self.nnf){
      case .disjunction:
        var clauseConjonctive = self.nnf.disjunctionOperands
        if let clauseOne = clauseConjonctive.first{
          if case let .conjunction( a, b) = clauseOne{
            clauseConjonctive.remove(clauseOne)
            let reste = clauseConjonctive.first
            return (a.dnf || reste!.cnf) && (b.cnf || reste!.cnf)
          }
        }
        return self.nnf

      case .conjunction:
        var clauseDisjonctive = self.conjunctionOperands
        for clause in clauseDisjonctive{
          for other in clauseDisjonctive{
             if clause.disjunctionOperands.isSubset(of: other.disjunctionOperands) && other != clause{
               clauseDisjonctive.remove(other)
             }
          }
        }
        resultatInter = clauseDisjonctive.first
        clauseDisjonctive.remove(resultatInter!)
        for clause in clauseDisjonctive{
          resultatInter = resultatInter! && clause
        }
        return resultatInter!
      default :
        return self.nnf
    }
  }
  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    var resultat : Set<Set<Formula>> = []
    let clauseConjonctive = self.disjunctionOperands
    for clause in clauseConjonctive{
     resultat.insert(clause.conjunctionOperands)
    }
    return resultat
  }
  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    var resultat : Set<Set<Formula>> = []
      let clauseDisjonctive = self.conjunctionOperands
      for clause in clauseDisjonctive{
        resultat.insert(clause.disjunctionOperands)
      }
      return resultat 
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
