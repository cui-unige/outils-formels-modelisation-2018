extension Formula {

  /// The negation normal form of the formula.
  //FNN: si neg que sur variables et opérateurs autorisées : &;v (ou)
  public var nnf: Formula {
    // Write your code here.
    //return self
    switch self {
			// negation a distribuer, ex: ¬(a & b)
    case .negation(let a): //seul
      switch a  {
        case .constant(let b): // si b est une constante on donne /"retourne" la neg (inverse) de b
            return Formula.constant(!b)
        case .proposition: // retourne lui-même car ¬¬a = a
            return self
        case .negation(let b): // si b est neg, on le traite tel quel
            return b.nnf
        case .conjunction(let b, let c): // ¬(a & b) devient: ¬a ∨ ¬b
            return !b.nnf || !c.nnf
        case .disjunction(let b, let c): // ¬(a ∨ b) devient:  ¬a ∧ ¬b
            return !b.nnf && !c.nnf
        case .implication(let b, let c):  // ¬(a -> b) devient: a & ¬b
            return b.nnf && !c.nnf
      }
			// pas de negation a distribuer
    case .implication(let a, let b): // a -> b devient: ¬a ∨ b,
      return !a.nnf || b.nnf // .nnf pour être sur que a et b son aussi conforme pour la neg pour FNN
    case .conjunction(let a, let b): // si on a une conjonction  a & b, on verifie aussi a et b (de facon recursie avec soi-même)
        return a.nnf && b.nnf
	case .disjunction(let a, let b): // si on a une disjonction a ∨ b
      return a.nnf || b.nnf
    default :
      return self
    }
  }

  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    //return self
    //DNF: ou entre clauses et & dans clauses
    switch self.nnf { // pour avoir DNF, il faut que les neg soient distribuées, on applique .nnf pour les ditribuées
    case .conjunction: // &, cas de la conjonction
      var operandes = self.nnf.conjunctionOperands // on sépare les opérandes
      if let disjTrouvee = operandes.first(where: { //true ou false Regarde si dijonction trouvée
				if case  .disjunction = $0 { // cherche premiere disjonction (on itère sur les opérandes et on récupère la première qui a une disjonction)
        	           return true // disjTrouvee = true
                   }
               return false } ) { //disjTrouvee = false, pas disjonciton donc se retourne soi-même
          if case let .disjunction(a, b) = disjTrouvee {
              operandes.remove(disjTrouvee) // on l'enlève du set, car pas besoin de la traiter, a la bonne forme
              var resultat : Formula? // initialisation de la variable de type Formula
              for operande in operandes { // on itère sur les opérandes des operandes restantes (qui ne sont donc pas des disjonctions)
                  if resultat != nil  { // (boucles 2..)
                      resultat = resultat! && operande // on concatène par AND les opérandes on met dans variable resultat
                  }
                  else {
                      resultat = operande // (première boucle, première opérande)
                  }
              }
              resultat = (a.dnf && resultat!.dnf) || (b.dnf && resultat!.dnf) // développement en forme normale conjonctive (distribution) retourne tout "gauche ou droite", applique a l'int dnf, pour avoir && entre les clauses
              if resultat != nil { return resultat!.dnf}
          }
      }
      return self.nnf

  case .disjunction: // ∨, cas de la disjonction
      var operandes = self.disjunctionOperands // on récupère les opérandes dans le cas d'une disjonction
      for operandeA in operandes { // première opérande
        for operandeB in operandes { // deuxième opérande
          if operandeA.conjunctionOperands.isSubset(of:operandeB.conjunctionOperands) && operandeB != operandeA { // si sous-ensembles et différents
            operandes.remove(operandeB) // on peut l'enlever des operandes à traiter car sous la bonne forme
          }
        }
      }
      var resultat : Formula?// initialise var de type formula
      for operandeA in operandes {
        if resultat != nil  { //resultat pas null
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
    // Write your code here.
    //return self
    //CNF: ou dans clause, & entre clauses
    switch self.nnf {// pour avoir DNF, il faut que les neg soient distribuées, on applique .nnf pour les ditribuées
    case .disjunction: //cas disjonction
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
    // Write your code here.
    //return []
    switch self {
			// récupérer les opérandes séparées par des ∨
    case .disjunction:
      let operands = self.disjunctionOperands
      var resultat : Set<Set<Formula>> = [] // initialisation du set a reourner
      for operande in operands {// boucle sur operande
        resultat.insert(operande.conjunctionOperands) // on ajoute au resultat les operandes separee (opérandes (séparées donc pas des disjonctions de base))
      }
      return resultat
    default:
      return []
    }
  }

  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    //return []
    switch self {
			//récupérer les opérandes séparées par des &
    case .conjunction:
      let operands = self.conjunctionOperands
      var resultat : Set<Set<Formula>> = [] // initialisation du set qui sera retourner
      for operande in operands {
        resultat.insert(operande.disjunctionOperands)// on ajoute au resultat les operandes separee (opérandes (séparées donc pas des conjonctions de base))
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
