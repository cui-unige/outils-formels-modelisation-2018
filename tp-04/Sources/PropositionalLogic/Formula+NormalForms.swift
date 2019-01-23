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
            return (p).nnf || (q).nnf
        case .conjunction(let p, let q):
            return (p).nnf && (q).nnf
        case .implication(let p, let q):
            return (!p).nnf || (q).nnf
        case .negation(let p):

            
            switch p{
            case .negation(let t):
                return t.nnf
            case .disjunction(let t, let q):
                // il faut distribuer la négation
                return (!t).nnf && (!q).nnf
            case .conjunction(let t, let q):
                // il faut distribuer la négation
                return (!t).nnf || (!q).nnf
            case .implication(let t, let q):
                // il faut remplacer l'implication
                return (t).nnf && (!q).nnf
            case .constant(let t):
                return t ? false : true
                
            case .proposition(_):
                return self
                
            }
            
        }
        
        
    }
    
    /// The disjunctive normal form (DNF) of the formula.
    public var dnf: Formula {
        // Write your code here.
        //distribution des negation et des &&
        switch self.nnf {
        case .conjunction(let a, let b):
            switch (a.dnf, b.dnf) {
            case (.disjunction(let c, let d), _):
                return (c.dnf && b.dnf) || (d.dnf && b.dnf)
            case (_, .disjunction(let c, let d)):
                return (c.dnf && a.dnf) || (d.dnf && a.dnf)
            default:
                return a.dnf && b.dnf
            }
        default:
            return self.nnf
        }
        
    }

    
    /// The conjunctive normal form (CNF) of the formula
    public var cnf: Formula {
        // Write your code here.
        // distributin des négation et des ||
        switch self.nnf {
        case .disjunction(let a, let b):
            switch (a.cnf, b.cnf) {
            case (.conjunction(let c, let d), _):
                return (c.cnf || b.cnf) && (d.cnf || b.cnf)
            case (_, .conjunction(let c, let d)):
                return (c.cnf || a.cnf) && (d.cnf || a.cnf)
            default:
                return a.cnf || b.cnf
            }
        default:
            return self.nnf
        }
        
    }
    
    /// The minterms of a formula in disjunctive normal form.
    public var minterms: Set<Set<Formula>> {
        switch self {
        case .disjunction:
            var result : Set<Set<Formula>> = []
            for operand in self.disjunctionOperands {
                result.insert(operand.conjunctionOperands)
            }
            return result
        default:
            return []
        }
    }
    
    /// The maxterms of a formula in conjunctive normal form.
    public var maxterms: Set<Set<Formula>> {
        // Write your code here.
        switch self {
        case .conjunction:
            var resultat : Set<Set<Formula>> = []
            let operands = self.conjunctionOperands
            for operande in operands {
                resultat.insert(operande.disjunctionOperands)
            }
            return resultat
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
