extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self{
    case .negation(let a):// partie negative
        switch a {
        case .constant(let b):
            //constante, renvoi de la negation
            return Formula.constant(!b)
        case .proposition:
            return self
        case .negation(let b):
            return b.nnf
        case .conjunction(let b, let c):
            //  !(B & C) = !B || !C
            return !b.nnf || !c.nnf
        case .disjunction(let b, let c):
        //  !(B || C) = !B & !C
            return !b.nnf && !c.nnf
        case .implication(let b, let c):
        // A→B ≡ A∧!B
            return b.nnf && !c.nnf
        }
        //partie positive
    case .implication(let a, let b):
        // A→B≡¬A∨B
        return !a.nnf || b.nnf
    case .conjunction(let a, let b):
        return a.nnf && b.nnf
    case .disjunction(let a, let b):
        return a.nnf || b.nnf
    case .constant (_):
        return self
    case .proposition(_):
        return self
        }
    }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    let nnf = self.nnf
    switch nnf {
    case .conjunction:
        var operands = nnf.conjunctionOperands
        if let disjunction_one = operands.first(where: {
            switch $0{
                case .disjunction(_,_):
                    return true
            default:
                return false
            }
        }){
            
            if case let .disjunction(lhs, rhs) = disjunction_one {
                operands.remove(disjunction_one)
                var result : Formula!
                for operand in operands{
                    if result != nil{
                        result = result && operand // Remplacement des disjonction en conjonction
                    }
                    else {
                        result = operand // Quand plus de disjonction, on revoit le résultat
                    }
                }
                
                result = (lhs.dnf && result.dnf) || (rhs.dnf && result.dnf)
                return result.dnf
            }
        }
    
        return nnf
        case .disjunction:
            var operands = self.disjunctionOperands
            for operand in operands{
                for operand1 in operands{
                    if operand.conjunctionOperands.isSubset(of: operand1.conjunctionOperands) && operand1 != operand{
                        operands.remove(operand1)
                    }
                }
        }
        
            var result : Formula?
            for operand in operands{
                if result != nil{
                    result = result! || operand
                }
                else{
                    result = operand
                }
        }
        return result!
    default:
        return nnf
    }
    // Write your code here.
  }

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    let nnf = self.nnf
    switch nnf {
    case .disjunction:
        var operands = nnf.disjunctionOperands
        if let conjunction_one = operands.first(where: {
            switch $0{
            case .conjunction(_,_):
                return true
            default:
                return false
            }
        }){
            
            if case let .conjunction(lhs, rhs) = conjunction_one {
                operands.remove(conjunction_one)
                var result : Formula!
                for operand in operands{
                    if result != nil{
                        result = result || operand
                    }
                    else {
                        result = operand
                    }
                }
                
                result = (lhs.dnf || result.dnf) && (rhs.dnf || result.dnf)
                return result.dnf
            }
        }
        
        return nnf
    case .conjunction:
        var operands = self.conjunctionOperands
        for operand in operands{
            for operand1 in operands{
                if operand.disjunctionOperands.isSubset(of: operand1.disjunctionOperands) && operand1 != operand{
                    operands.remove(operand1)
                }
            }
        }
        
        var result : Formula?
        for operand in operands{
            if result != nil{
                result = result! && operand
            }
            else{
                result = operand
            }
        }
        return result!
    default:
        return nnf
    }
    // Write your code here.
    }

  /// The minterms of a formula in disjunctive normal form.
    // Changement des opérateur de disjonctif à conjonctif
  public var minterms: Set<Set<Formula>> {
    switch self {
    case .disjunction: // si disjonction on change a conjonction
        var result : Set<Set<Formula>> = []
        for operand in self.disjunctionOperands{
            result.insert(operand.conjunctionOperands)
        }
        return result
    default: // Sinon on laisse tel quel
        return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
    // Changement des opérateur de conjonctif à disjonctif
  public var maxterms: Set<Set<Formula>> {
    switch self {
    case .conjunction:
        var result : Set<Set<Formula>> = []
        for operand in self.conjunctionOperands{
            result.insert(operand.disjunctionOperands)
        }
        return result
    default:
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
