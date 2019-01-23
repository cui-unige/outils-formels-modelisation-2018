extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self {
    case .constant(let c):
      return c ? true : false
    case .proposition(_): // mieux avec _ que let p : vu garce au warnings
      return self

    case .negation(let a):
    // !a
      switch a {
      case .constant(let c):
        return c ? false : true
      case .proposition(_):
        return self
      case .negation(let a):
      // not !a --> a
        return a.nnf
      case .disjunction(let a, let b):
      // not (a || b) --> (!a && !b)
        return !a.nnf && !b.nnf
      case .conjunction(let a, let b):
      // not (a && b) --> (!a || !b)
        return !a.nnf || !b.nnf
      case .implication(let a, let b):
      // not (!a || b) --> (a && !b)
        return a.nnf && !b.nnf
      }

    case .disjunction(let a, let b):
    // (a || b)
      return a.nnf || b.nnf
    case .conjunction(let a, let b):
    // (a && b)
      return a.nnf && b.nnf
    case .implication(let a, let b):
    // (!a || b)
      return !a.nnf || b.nnf

    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.

    // !(a => b => c) --> (b && !c) || (!a && !c)
    // peut utiliser conjunctionOperands <-- pas besoin

    let nega = self.nnf

    switch nega {
    case .constant(let c):
      return c ? true : false
    case .proposition(_):
      return self

    case .disjunction(let a, let b):
    // (a || b)
      return a.dnf || b.dnf
    case .conjunction(let a, let b):
    // (a && b) --> descendre && --> !a.dnf || !b.dnf
      let aPrime = a.dnf // monter ||
      let bPrime = b.dnf

      switch (aPrime, bPrime) {
      case (_ , .disjunction(let a, let b)):
        return (aPrime && a) || (aPrime && b)
      case (.disjunction(let a, let b), _):
        return (a && bPrime) || (b && bPrime)
      default :
        return aPrime && bPrime
      }

    default :
      return nega
    }

  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.

    // !(a => b => c) --> (!c && (!a || b))
    // peut utiliser disjunctionOperands <-- pas besoin

    let nega = self.nnf

    switch nega {
    case .constant(let c):
      return c ? true : false
    case .proposition(_):
      return self

    case .disjunction(let a, let b):
    // (a || b) --> monter &&
      let aPrime = a.cnf // descendre ||
      let bPrime = b.cnf

      switch (aPrime, bPrime) {
      case (_ , .conjunction(let a, let b)):
        return (aPrime || a) && (aPrime || b)
      case (.conjunction(let a, let b), _):
        return (a || bPrime) && (b || bPrime)
      default :
        return aPrime || bPrime
      }

    case .conjunction(let a, let b):
    // (a && b)
      return a.cnf && b.cnf
    case .implication(let a, let b):
    // (!a || b)
      return (!a || b).cnf
    default :
      return nega
    }
  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    //return []

    // pour ||
    
    switch self {
    case .disjunction(_ , _):
      var sol : Set<Set<Formula>> = []
      for operand in self.disjunctionOperands {
        sol.insert(operand.conjunctionOperands)
      }
      return sol
    default :
      return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    //return []

    // pour &&

    switch self {
    case .conjunction(_ , _):
      var sol : Set<Set<Formula>> = []
      for operand in self.conjunctionOperands {
        sol.insert(operand.disjunctionOperands)
      }
      return sol
    default :
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
