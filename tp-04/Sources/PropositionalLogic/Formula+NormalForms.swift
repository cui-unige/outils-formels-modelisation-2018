extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula
  {
    let m = self
    if case .implication (let a, let b) = m //pattern match for each relevant case of the enum
    {
      return !a.nnf || b.nnf
    }
    else if case .conjunction (let a, let b) = m
    {
      return a.nnf && b.nnf
    }
    else if case .disjunction (let a, let b) = m
    {
      return a.nnf || b.nnf
    }
    else if case .negation (let a) = m
    {
      if case .constant (let b) = a
      {
        return .constant(!b)
      }
      else if case .proposition = a
      {
        return self
      }
      else if case .implication (let b, let c) = a
      {
        return b.nnf && !c.nnf
      }
      else if case .conjunction (let b, let c) = a
      {
        return !b.nnf || !c.nnf
      }
      else if case .disjunction (let b, let c) = a
      {
        return !b.nnf && !c.nnf
      }
      else if case .negation (let b) = a
      {
        return b.nnf
      }
    }
    else
    {
      return m
    }
    return m
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula
  {
    var intermediate : Formula? = nil
    let m = self.nnf
    if case .conjunction = m
    {
      var conjunctiveClauses = self.nnf.conjunctionOperands
      if let claus = conjunctiveClauses.first
      {
        if case .disjunction (let a, let b) = claus
        {
          conjunctiveClauses.remove(claus)
          let remaining = conjunctiveClauses.first
          return (a.dnf && remaining!.dnf) || (b.dnf && remaining!.dnf)
        }
      }
      return m
    }
    else if case .disjunction = m
    {
      var disjunctiveClauses = self.disjunctionOperands
      for e in disjunctiveClauses
      {
        for f in disjunctiveClauses
        {
          if e.conjunctionOperands.isSubset(of: f.conjunctionOperands) && f != e
          {
            disjunctiveClauses.remove(f)
          }
        }
      }
      intermediate = disjunctiveClauses.first
      disjunctiveClauses.remove(intermediate!)
      for claus in disjunctiveClauses
      {
        intermediate = intermediate! || claus
      }
      return intermediate!
    }
    else
    {
      return m
    }
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula
  {
    let m = self.nnf
    var intermediate: Formula? = nil
    if case .disjunction = m
    {
        var disjunctiveClauses = self.nnf.disjunctionOperands
        if let claus = disjunctiveClauses.first
        {
          if case .conjunction (let a, let b) = claus
          {
            disjunctiveClauses.remove(claus)
            let remaining = disjunctiveClauses.first
            return (a.dnf || remaining!.cnf) && (b.cnf || remaining!.cnf)
          }
        }
        return self.nnf
    }
    else if case .conjunction = m
    {
        var conjunctiveClauses = self.nnf.conjunctionOperands
        for e in conjunctiveClauses
        {
          for f in conjunctiveClauses
          {
            if e.disjunctionOperands.isSubset(of: f.disjunctionOperands) && f != e
            {
              conjunctiveClauses.remove(f)
            }
          }
        }
        intermediate = conjunctiveClauses.first
        conjunctiveClauses.remove(intermediate!)
        for e in conjunctiveClauses
        {
          intermediate = intermediate! && e
        }
        return intermediate!
    }
    else
    {
      return m
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>>
  {
    var minterms: Set<Set<Formula>> = []
    let disjunctiveClauses = self.disjunctionOperands
    for claus in disjunctiveClauses
    {
      minterms.insert(claus.conjunctionOperands)
    }
    return minterms
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
   // Write your code here.
   var maxterms : Set<Set<Formula>> = []
   let conjunctiveClauses = self.conjunctionOperands
   for claus in conjunctiveClauses
   {
     maxterms.insert(claus.disjunctionOperands)
   }
   return maxterms
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
