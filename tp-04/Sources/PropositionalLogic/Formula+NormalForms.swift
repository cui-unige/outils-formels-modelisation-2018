extension Formula {

  /// The negation normal form of the formula.

  public var nnf: Formula {
    // Write your code here.

    switch self {
       case .constant(let c):
        return c ? true : false

        case .proposition(_):
          return self

        case .negation(let a):
          switch a {
            case .constant(let c):
              return c ? false : true
            case .proposition(_):
              return self
            case .negation(let b):
              return b.nnf
            case .disjunction(let b, let c):
              return (!b).nnf && (!c).nnf
            case .conjunction(let b,let c):
              return (!b).nnf || (!c).nnf
            case .implication(_):
              return (!a.nnf).nnf
          }

        case .disjunction(let b,let c):
          return b.nnf || c.nnf

        case .conjunction(let b,let c):
          return b.nnf && c.nnf

        case .implication(let b,let c):
          return (!b).nnf || c.nnf
    }

  }

  /// The disjunctive normal form (DNF) of the formula.

  public var dnf: Formula {
    // Write your code here.

    var form=self.nnf
    //form=(!form).nnf
    //Swift.print("DANS DNF: \(form)")

    switch form {
      case .constant(let c):
       return c ? true : false

       case .proposition(_):
         return self

       case .negation(let a):
            return !a.dnf

       case .disjunction(let b,let c):
         return b.dnf || c.dnf

       case .conjunction(let b,let c):
         switch b {
             case .disjunction(let d,let e):
                 return (d.dnf && c.dnf) || (e.dnf && c.dnf)
             default:
               switch c {
                 case .disjunction(let d,let e):
                   return (b.dnf && d.dnf) || (b.dnf && e.dnf)
                 default:
                   return b.dnf && c.dnf
               }
         }

        case .implication(let b,let c):
          return ((!(self.nnf)).nnf).dnf
    }
  }

  /// The conjunctive normal form (CNF) of the formula.

  public var cnf: Formula {
    // Write your code here.

    var form=self.nnf
    //form=(!form).nnf
    //Swift.print("DANS DNF: \(form)")

    switch form {
      case .constant(let c):
       return c ? true : false

       case .proposition(_):
         return self

       case .negation(let a):
            return !a.dnf

       case .conjunction(let b,let c):
         return b.dnf && c.dnf

       case .disjunction(let b,let c):
         switch b {
             case .conjunction(let d,let e):
                 return (d.dnf || c.dnf) && (e.dnf || c.dnf)
             default:
               switch c {
                 case .conjunction(let d,let e):
                   return (b.dnf || d.dnf) && (b.dnf || e.dnf)
                 default:
                   return b.dnf || c.dnf
               }
         }

        case .implication(let b,let c):
          return ((!(self.nnf)).nnf).dnf
    }
  }

  /// The minterms of a formula in disjunctive normal form.

  public var minterms: Set<Set<Formula>> {
    // Write your code here.

    var a:Set<Set<Formula>> = []
    for p in disjunctionOperands{
        a.insert(p.conjunctionOperands)
    }
    return a
  }

  /// The maxterms of a formula in conjunctive normal form.

  public var maxterms: Set<Set<Formula>> {
    // Write your code here.

    var a:Set<Set<Formula>> = []
    for p in self.conjunctionOperands{
        a.insert(p.disjunctionOperands)
    }
    return a
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
