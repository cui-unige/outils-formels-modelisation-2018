extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    switch self {
    case .implication(let a_implique,let b):
      return (!a_implique).nnf || (b).nnf
    case .conjunction(let a_et , let b):
      return (a_et).nnf || (b).nnf
    case .disjunction(let a_ou , let b):
      return (a_ou).nnf && (b).nnf
    case .constant(let const):
      return const ? true : false
    case .proposition(_):
      return self
    case .negation(let formula):

          switch formula{
            case .constant(let cons):
              return cons ? false : true
            case .proposition(_):
              return self
            case .negation(let neg):
              return neg.nnf
            case .conjunction(let a_et , let b):
              return ((!a_et).nnf) || ((!b).nnf)
            case .disjunction(let a_ou , let b):
              return((!a_ou).nnf) && ((!b).nnf)
            case .implication(let a_implique,let b):
              return (a_implique).nnf && (!b).nnf
        }
      }
    }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
     switch self.nnf { //on fait un nnf

//cas conjonction
    case .conjunction:
      var operands = self.nnf.conjunctionOperands
    //but: separation en disjonction
      if let firstDisjunction = operands.first(where: { //separation des operandes
              if case .disjunction = $0 { //recherche de disjonction
                return true //true si trouvé
              }
            return false }) //false sinon
      {
        if case let .disjunction(a,b) = firstDisjunction {
          operands.remove(firstDisjunction) //suppression de l'opérande car redondance
          var res : Formula?
          for op in operands { //itération sur opérandes des opérandes
            if res != nil {
              res = res! && op //concaténation
             }
            else {
              res = op
            }
          }
        res = (a.dnf && res!.dnf) || (b.dnf && res!.dnf)
          if res != nil { return res!.dnf}
      }
    }
    return self.nnf
//cas disjonction
  case .disjunction: //
    var operands = self.disjunctionOperands
    for op in operands {
      for op2 in operands {
        if op.conjunctionOperands.isSubset(of: op2.conjunctionOperands) && op2 != op {
          operands.remove(op2)
        }
      }
    }
    var res : Formula?
    for op in operands {
      if res != nil {
        res = res! || op
      }
      else {
        res = op
      }
    }
    return res!

  default :
    return self.nnf
    }
  }
  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    switch self.nnf {
 //cas disjonction

    case .disjunction:
      var operandes = self.nnf.disjunctionOperands
      if let firstConjunction = operandes.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, b) = firstConjunction {
            operandes.remove(firstConjunction)
            var resultat : Formula?
            for operandeA in operandes {
              if resultat != nil  {
                resultat = resultat! || operandeA
              }
              else {
                resultat = operandeA
              }
            }
          resultat = (a.cnf || resultat!.cnf) && (b.cnf || resultat!.cnf)
          if resultat != nil { return resultat!.cnf}
          }
      }
      return self.nnf
  //cas conjonction
    case .conjunction:
      var operandes = self.nnf.conjunctionOperands
      for operandeA in operandes {
        for operandeB in operandes {
          if operandeA.disjunctionOperands.isSubset(of:operandeB.disjunctionOperands) && operandeB != operandeA {
            operandes.remove(operandeB)
          }
        }
      }
      var resultat : Formula?
      for operandeA in operandes {
        if resultat != nil  {
          resultat = resultat! && operandeA
        }
        else {
          resultat = operandeA
        }
      }
      return resultat!
    default :
      return self.nnf
    }
  }



  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    switch self {

    case .disjunction:
      let operands = self.disjunctionOperands
      var resultat : Set<Set<Formula>> = []
      for operande in operands {
        resultat.insert(operande.conjunctionOperands)
      }
      return resultat
    default:
      return []

    }
  }
  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    switch self {

      case .conjunction:
        let operands = self.conjunctionOperands
        var resultat : Set<Set<Formula>> = []
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
