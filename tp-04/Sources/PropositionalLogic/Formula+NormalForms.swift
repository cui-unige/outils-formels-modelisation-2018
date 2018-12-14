extension Formula {
  /// The negation normal form of the formula.
	// une formule est dite être en forme normale négative (abrégé FNN) si l'opérateur de la négation
	// est appliqué uniquement aux variables, et les seuls opérateurs booléens autorisés sont la conjonction  et la disjonction .
  public var nnf: Formula {
    switch self {
			// CAS OU ON A UNE NEGATION à "DISTRIBUER", pour avoir l'opérateur de négation appliqué uniquement aux variables
    case .negation(let a):
      switch a {
      case .constant(let b):
        return Formula.constant(!b) // si b est une constante, on envoie la négation  (true->false et false->true)
      case .proposition:
        return self // on retourne lui même car négation de négation
      case .negation(let b):
        return b.nnf // si b est une négation, on traite simplement b tel quel
      case .conjunction(let b, let c): // si on a:  a ∧ b, on transforme en !a ∨ !b
        return !b.nnf || !c.nnf
      case .disjunction(let b, let c): // si on a: a ∨ b, on transforme en !a ∧ !b
        return !b.nnf && !c.nnf
      case .implication(let b, let c):  // a → b = !a ∨ b, on transforme en a ∧ !b
        return b.nnf && !c.nnf
      }
			// CAS OU PAS D'OPERATEUR NEGATION GLOBAL-TOTAL
    case .implication(let a, let b): // si on a une implication a → b = !a ∨ b,
      return !a.nnf || b.nnf // .nnf car à vérifier la forme de a et b (récursivement, à l'aide d'au-dessus)
    case .conjunction(let a, let b): // si on a une conjonction  a ∧ b
        return a.nnf && b.nnf
	  case .disjunction(let a, let b): // si on a une disjonction a ∨ b
      return a.nnf || b.nnf
    default :
      return self
    }
  }
  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    switch self.nnf { // pour pouvoir une forme normale conjonctive, il faut obligatoirment que les négations soient sur les variables (distribués)
    case .conjunction: // ∧
      var variables = self.nnf.conjunctionOperands // on sépare les opérandes
      if let disjonctionTrouvee = variables.first(where: {
				if case  .disjunction = $0 { // on itère sur les opérandes et on récupère la première qui a une disjonction
        	return true // ok assignation de variable
      }
		return false } ) {
          if case let .disjunction(a, b) = disjonctionTrouvee {
            variables.remove(disjonctionTrouvee) // on l'enlève du set, car pas besoin de la traiter car sous la bonne forme
            var resultat : Formula? // initialisation de la variable de type Formula (ok à NULL)
            for operande in variables { // on itère sur les opérandes des variables restantes (qui ne sont donc pas des disjonctions)
              if resultat != nil  { // (boucles 2..)
                resultat = resultat! && operande // on concatène par AND les opérandes
              }
              else {
                resultat = operande // (première boucle, première opérande)
              }
            }
          resultat = (a.dnf && resultat!.dnf) || (b.dnf && resultat!.dnf) // développement en forme normale conjonctive (distribution)
          if resultat != nil { return resultat!.dnf}
          }
      }
      return self.nnf
    case .disjunction: // ∨
      var variables = self.disjunctionOperands // on récupère les opérandes dans le cas d'une disjonction
      for operandeA in variables { // première opérande
        for operandeB in variables { // deuxième opérande
          if operandeA.conjunctionOperands.isSubset(of:operandeB.conjunctionOperands) && operandeB != operandeA { // si sous-ensembles et différents
            variables.remove(operandeB) // on peut l'enlever des variables à traiter car sous la bonne forme
          }
        }
      }
      var resultat : Formula?
      for operandeA in variables {
        if resultat != nil  {
          resultat = resultat! || operandeA // on concatène les opérandes avec des OU
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

  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {
    switch self.nnf {
    case .disjunction:
      var variables = self.nnf.disjunctionOperands
      if let firstConjunction = variables.first(where: { if case  .conjunction = $0 {
        return true
      }
      return false }) {
          if case let .conjunction(a, b) = firstConjunction {
            variables.remove(firstConjunction)
            var resultat : Formula?
            for operandeA in variables {
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
    case .conjunction:
      var variables = self.nnf.conjunctionOperands
      for operandeA in variables {
        for operandeB in variables {
          if operandeA.disjunctionOperands.isSubset(of:operandeB.disjunctionOperands) && operandeB != operandeA {
            variables.remove(operandeB)
          }
        }
      }
      var resultat : Formula?
      for operandeA in variables {
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
			// on doit récupérer les opérandes séparées par des ∨
    case .disjunction:
      let operands = self.disjunctionOperands
      var resultat : Set<Set<Formula>> = [] // initialisation du set que l'on retournera
      for operande in operands {
        resultat.insert(operande.conjunctionOperands) // on boucle sur les opérandes (séparées donc pas des disjonctions de base) et on les ajoute au résultat final 
      }
      return resultat
    default:
      return []
    }
  }
  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    switch self {
			// on doit récupérer les opérandes séparées par des ∧
    case .conjunction:
      let operands = self.conjunctionOperands
      var resultat : Set<Set<Formula>> = [] // initialisation du set que l'on retournera
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
