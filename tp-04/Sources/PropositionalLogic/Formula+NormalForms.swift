extension Formula {

  ///The negation normal form of the formula.
  public var nnf: Formula {
 ///Write your code here.
 switch self{
 case .constant(let vrp): ///
               return vrp ? true : false
           case .proposition:
               return self
           case .disjunction(let vrp, let vrq):///Computed for p or q.
               return (vrp).nnf || (vrq).nnf
           case .conjunction(let vrp, let vrq):///And computed for p and q.
               return (vrp).nnf && (vrq).nnf
           case .implication(let vrp, let vrq):///Imply is equivalent to not p or q.
               return (!vrp).nnf || (vrq).nnf
           case .negation(let vrp):///not
           switch vrp{
                   case .constant(let vrt):
                         return vrt ? false : true
                   case .disjunction(let vrt, let vrq):///The result is (not t) and (not q).
                         return (!vrt).nnf && (!vrq).nnf
                   case .conjunction(let vrt, let vrq):///(not t) or (not q)
                       return (!vrt).nnf || (!vrq).nnf
                   case .implication(let vrt, let vrq):///t and (not q)
                         return (vrt).nnf && (!vrq).nnf
                   case .negation(let vrt):///not (not t)
                         return vrt.nnf
                   case .proposition:///The proposition does not change.
                       return self
           }
      }
}

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    switch self.nnf { ///In order to form a conjunction normal form.
    case .conjunction: ///And.
      var operands = self.nnf.conjunctionOperands ///We separate the operands.
      if let disjunction = operands.first(where: { if case  .disjunction = $0 {///We iterate on the operands and we recover the first one which has a disjunction.
        return true///Returns true.
      }
      return false }) {
          if case let .disjunction(a, e) = disjunction {///Remove it from the set.
            operands.remove(disjunction)///Remove disjunction from set
            var result : Formula?///Initialization of the Formula optional variable.
            for operand in operands {///Iterates on the operands of the remaining variables.
              if  nil != result  {
                result = result! && operand
              }
              else {
                result = operand
              }
            }
          result = (a.dnf && result!.dnf) || (e.dnf && result!.dnf)///Normal conjunctive form development.
          if nil != result  { return result!.dnf}
          }

      }
      return self.nnf
    case .disjunction(let a, let b):///Or.
      var operands = (a.dnf || b.dnf).disjunctionOperands///The operands are recovered in the case of a  disjunction.
      // absorbtion
      for operand in operands {///Operand.
        for o in operands {///O.
          if operand.conjunctionOperands.isSubset(of:o.conjunctionOperands) && o != operand {///If subset is different.
            operands.remove(o) ///It can be removed from the variables to be processed because in the right form.
          }
        }
      }

      
      var result : Formula?///Build the result.
      for operand in operands {
        if nil != result   {
          result = result! || operand
        }
        else {
          result = operand///Set results as the operand.
        }
      }
      return result!

    default :
      return self.nnf
    }

  }

  ///The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    ///Write your code here.
    switch self.nnf { ///We start with the nnf.
    case .disjunction:
      var operands = self.nnf.disjunctionOperands
      if let conjunction = operands.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, e) = conjunction {
            operands.remove(conjunction)///Remove conjunction from set
            var result : Formula?///Declare result as optional.
            for operand in operands {///For each operand.
              if nil !=  result {
                result = result! || operand
              }
              else {
                result = operand///The result is the operand.
              }
            }
          result = (a.cnf || result!.cnf) && (e.cnf || result!.cnf)
          if nil != result  { return result!.cnf}
          }

      }
      return self.nnf
    case .conjunction(let a, let e):

      var operands = (a.cnf && e.cnf).conjunctionOperands
      for operand in operands {///For.
        for prn in operands {
          if operand.disjunctionOperands.isSubset(of:prn.disjunctionOperands) && operand !=  prn {
            operands.remove(prn)
          }
        }
      }

      var result : Formula?//Build final result
      for operand in operands {
        if nil != result   {///For all operand.
          result = result! && operand
        }
        else {
          result = operand///Result equals operand.
        }
      }
      return result!

    default :
      return self.nnf
    }
  }

  ///The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    ///Write your code here.
    switch self {///We have to recover the operands separated by disjunction.
    case .disjunction:
      let operands = self.disjunctionOperands
      var result : Set<Set<Formula>> = []///Initialization of the set that we will return.
      for operand in operands {
        result.insert(operand.conjunctionOperands)///We loop on the operands and we add them to the final result.
      }
      return result///Here we return.
    default:
      return []
    }

  }

  ///The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    ///Write your code here.

    switch self {///We have to recover the operands separated by conjunction.
    case .conjunction:
      let operands = self.conjunctionOperands
      var result : Set<Set<Formula>> = []///Initialize the set of result.
      for op in operands {
        result.insert(op.disjunctionOperands)
      }
      return result
    default:
      return []
    }
  }

  /// Unfold a tree of binary disjunctions into a set of operand.
  ///
  ///     let f: Formula = .disjunction("a", .disjunction("b", .negation("c")))
  ///     print(disjunctionOperands)
  ///     // Prints "[a, b, ¬c]"
  ///
  private var disjunctionOperands: Set<Formula> {
    switch self {
    case .disjunction(let a, let e):
      return a.disjunctionOperands.union(e.disjunctionOperands)
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
