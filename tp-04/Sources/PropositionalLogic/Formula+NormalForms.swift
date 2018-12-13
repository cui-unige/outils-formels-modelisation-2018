extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here.
    switch self{
              case .constant(let p):
                  return p ? true : false
              case .proposition(_):
                  return self
              case .disjunction(let p, let q):
              //(p || q)
                  return (p).nnf || (q).nnf
              case .conjunction(let p, let q):
              //(p && q)
                  return (p).nnf && (q).nnf
              case .implication(let p, let q):
              // (¬p) ∨ q
                  return (!p).nnf || (q).nnf

              case .negation(let p):
              //not

              switch p{
                      case .constant(let t):
                            return t ? false : true
                      case .disjunction(let t, let q):
                          //!(t || q)il faut changer l'operande
                            return (!t).nnf && (!q).nnf
                      case .conjunction(let t, let q):
                          //!(t && q)il faut changer l'operande
                          return (!t).nnf || (!q).nnf
                      case .implication(let t, let q):
                          // =>: ¬(t ∧ ¬q)
                            return (t).nnf && (!q).nnf
                      case .negation(let t):
                        //double not gives no not
                            return t.nnf

                      case .proposition(_):
                          return self

              }

    }


  }

  /// The disjunctive normal form (DNF) of the formula.

  public var dnf: Formula {
    // Write your code here.
    //enlever les implications
    let result = self.nnf

          switch result{
          case .constant(let p):
              return p ? true : false
          case .proposition(_):
              return self

          case .conjunction(let a, let b):
            //return (!a).dnf || (!b).dnf: faire une distribution pour descendre le and
            let aNew = a.dnf//essayer de monter un OR
            let bNew = b.dnf
              switch (aNew, bNew){
                      case (.disjunction(let p,let q),_):
                            return (p && bNew ) || (q && bNew)
                      case (_,.disjunction(let p,let q)):
                            return (aNew && p) || (aNew && q)
                      default://cas ou il y a que des prop
                            return aNew && bNew
              }

          case .disjunction(let a, let b):
                return a.dnf || b.dnf
          default:
            return result



        }


}

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    // Write your code here.
    let result = self.nnf
    //enlever les implications
          switch result{
          case .constant(let p):
              return p ? true : false
          case .proposition(_):
              return self
          case .implication(let a, let b):
            return (!a || b).cnf
          case .disjunction(let a, let b):
            //return (!a).dnf || (!b).dnf : remonter des and
            let aNew = a.cnf
            let bNew = b.cnf
              switch (aNew, bNew){
                      case (.conjunction(let p,let q),_):
                            return (p || bNew ) && (q || bNew)//distribution
                      case (_,.conjunction(let p,let q)):
                            return (aNew || p ) && (aNew || q)//distribution
                      default:
                            return aNew || bNew
              }

          case .conjunction(let a, let b):
              return a.cnf && b.cnf
          default:
            return result



        }

  }

  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
      case .disjunction(let a, let b):
        return a.minterms.union(b.minterms)
      case .conjunction(let a, let b)://il faut mettre Set puisqu'ils sont tous dans la meme paranthese
        return [a.conjunctionOperands.union(b.conjunctionOperands)]
      default://proposition
      return [[self]]
  }

  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    switch self {
      case .disjunction(let a, let b)://il faut mettre Set puisqu'ils sont tous dans la meme paranthese
        return [a.disjunctionOperands.union(b.disjunctionOperands)]
      case .conjunction(let a, let b):
        return a.maxterms.union(b.maxterms)
      default:
      return [[self]]
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
