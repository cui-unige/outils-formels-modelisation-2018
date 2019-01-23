extension Formula {

  /// The negation normal form of the formula.
  public var nnf: Formula {
    // Write your code here
     switch (self) {
     case .negation(let c):
    /*   if type(of: c) == .constant {
         return .negation(c)
       }
       else{ */
      switch(c){
          case .negation(c):
            return .negation(c)
          case .constant:
            return .negation(c)
          case .conjunction(let a, let b):
            return .disjunction( (!a).nnf , (!b).nnf)
          case .disjunction(let a, let b):
            return .conjunction( (!a).nnf, (!b).nnf)
          case .implication(let a, let b):
            return .conjunction( a.nnf, (!b).nnf)
          case .proposition:
            return .negation(c)
          default:
            return self
          }
      case .disjunction(let a, let b):
      return .disjunction( a.nnf, b.nnf)
      case .conjunction(let a, let b):
      return .conjunction( a.nnf, b.nnf)
      case .implication(let a, let b):
      return .disjunction(  (!a).nnf, b.nnf);
      case .constant(let c):
      return .constant(c);
      case .proposition(let p):
      return .proposition(p)
    //  default:
    //  return self
      }
    }


  /// The disjunctive normal form (DNF) of the formula.
  public var dnf: Formula {
    // Write your code here.
    var resultatInter : Formula? = nil // retoure d'une formula en optionnel pour les résultats intermédiaires

    switch (self.nnf) { // on fait premier trie avec la fonction nnf normalement pour rentrer les négations
    case .conjunction:
      var clauseDisjonctive = self.nnf.conjunctionOperands // on met de côter dans un set les clause disjunctive
      //Swift.print("La clauseDisjonctive \(clauseDisjonctive)")
      //Swift.print(" la clause de base\(self)")
      if let clauseOne = clauseDisjonctive.first // on recupère la première clause disjunctive
     {
         if case let .disjunction( a, b) = clauseOne { // on sait que c'est une disjunction alors
                                                      // on attribue les valeur de la première clause à a et b pattern matching
            clauseDisjonctive.remove(clauseOne) // on enlève la clause pour la construction du resultat
            let reste = clauseDisjonctive.first // on recupère les autres clause, ici les autres clauses ou l'autre clause
            //Swift.print("ClauseDisjunctive Restante: \(clauseDisjonctive))");// en retourne une restante pour chaque cas

            return (a.dnf && reste!.dnf) || (b.dnf && reste!.dnf) // on veut une forme disjonctive en retour pour dnf ce qui explique ||
            // pour continuer à traiter tous les cas on renvoi une conjunction entre le paramètre et le resultat
            //le reste étant disjonctif mais ne sachant pas ce qu'il possède est renvoyer en dnf. les paramètre a et b également
            // et on renvoi les paramètres de la disjunction en récursion
         }
       }

       return self.nnf // retour par défaut

       case .disjunction: // pas réellement nécessaire à part pour la réduction
       var clauseConjonctive = self.disjunctionOperands // on extraît les conjunction des disjonctions
       for clause in clauseConjonctive {  //  on compare pour les disjonciton de notre set
          for other in clauseConjonctive { // avec toutes les autre disjunction de notre set
            if clause.conjunctionOperands.isSubset(of: other.conjunctionOperands) && other != clause {
                 // si une sous conjonction apartenant  à nos conjonctions existe déja dans une autre conjonction apartenant à nos conjonctions
                 // et que c'est autre conjonction de notre set est différente de la conjonction  comparé de notre set, alors on l'enlève: la conjonction other
                  clauseConjonctive.remove(other) // on enlève les conjonction equivalente
                }
              }
           }
       resultatInter = clauseConjonctive.first // on initialise notre variable avec la première conjonction de notre set
       clauseConjonctive.remove(resultatInter!) // on enleve la clause ajouter pour l'initialisation du resultat intermédiaire

       for clause in clauseConjonctive { // on parcourt toutes les conjonction contenue dans notre set de conjonction
         resultatInter = resultatInter! || clause // on crée une disjonction de conjonction
         }
       return resultatInter! // on retourne notre disjonction de conjunction

      default :
      return self.nnf //retour par défaut du switch ni disjunction ni conjunction
                      // mais doit tout de même passer dans le filtre négative normale forme
    }
  }


  /// The conjunctive normal form (CNF) of the formula.
  public var cnf: Formula {

    var resultatInter : Formula? = nil // retoure d'une formula en optionnel pour les résultats intermédiaires

    switch (self.nnf) { // on fait premier trie avec la fonction nnf normalement pour rentrer les négations
    case .disjunction:
      var clauseConjonctive = self.nnf.disjunctionOperands // on met de côter dans un set les clause disjunctive
      //Swift.print("La clauseConjonctive \(clauseConjonctive)")
      //Swift.print(" la clause de base\(self)")
      if let clauseOne = clauseConjonctive.first // on recupère la première clause disjunctive
      {
      if case let .conjunction( a, b) = clauseOne { // on sait que c'est une disjunction alors
                                                  // on attribue les valeur de la première clause à a et b pattern matching
        clauseConjonctive.remove(clauseOne) // on enlève la clause pour la construction du resultat
        let reste = clauseConjonctive.first // on recupère les autres clause, ici les autres clauses ou l'autre clause
        //Swift.print("clauseConjontive Restante: \(clauseConjonctive))");// en retourne une restante pour chaque cas

        return (a.dnf || reste!.cnf) && (b.cnf || reste!.cnf) // on veut une forme conjonctive en retour pour dnf ce qui explique le &&
        // pour continuer à traiter tous les cas on renvoi une disjuncition entre le paramètre et le resultat
        //le reste étant conjunctif mais ne sachant pas ce qu'il possède est renvoyer en dnf. les paramètre a et b également
        // et on renvoi les paramètres de la disjunction en récursion
        // nnf fait le reste en appel recursif
      }
   }

   return self.nnf // si on a pas rencontrer un des cas mentionné plus haut alors par défaut on renvoi la formula en nnf pour
                    // trouver d'autre cas

    case .conjunction:
    var clauseDisjonctive = self.conjunctionOperands // on extraît les disjunction des conjunction
    // on élimine les répétitions pour passer le test de réduction
    for clause in clauseDisjonctive {  //  on compare pour les disjonciton de notre set
          for other in clauseDisjonctive { // avec toutes les autre disjunction de notre set
             if clause.disjunctionOperands.isSubset(of: other.disjunctionOperands) && other != clause {
              // si une sous disjunction apartenant  à nos conjonctions existe déja dans une autre disjunction apartenant à disjunction
              // et que c'est autre disjunction de notre set est différente de la disjunction  comparé de notre set, alors on l'enlève: la disjonction other
              // apartenant à notre set
               clauseDisjonctive.remove(other) // on enlève les disjunction equivalante
             }
           }
        }

    resultatInter = clauseDisjonctive.first // on initialise notre variable avec la première disjunction de notre set
    clauseDisjonctive.remove(resultatInter!) // on enleve la clause ajouter pour l'initialisation du resultat intermédiaire

    for clause in clauseDisjonctive { // on parcourt toutes les conjonction contenue dans notre set de conjonction
      resultatInter = resultatInter! && clause // on crée une conjunction de disjonction
      }
    return resultatInter! // on retourne notre conjunction de disjunction

  default :
  return self.nnf //retour par défaut du switch ni disjunction ni conjunction
                  // mais doit tout de même passer dans le filtre négative normale forme
                  // pour trouver autre chose
  }
}


  /// The minterms of a formula in disjunctive normal form.
  public var minterms: Set<Set<Formula>> {
    // Write your code here.
    var resultat : Set<Set<Formula>> = []
         let clauseConjonctive = self.disjunctionOperands // on récupère les conjonction
         for clause in clauseConjonctive { // pour chaque conjonction on fait correspondre un sous set
         resultat.insert(clause.conjunctionOperands) // pour chaque sous set on insert les valeur entre l'opérateur de disjonction
         }
         return resultat // on retourn notre set de Set de valeur se trouvant entre disjonction
    }


  /// The maxterms of a formula in conjunctive normal form.
  public var maxterms: Set<Set<Formula>> {
    // Write your code here.
    var resultat : Set<Set<Formula>> = []
         let clauseDisjonctive = self.conjunctionOperands // on construit un set de disjonction avec la formula
         for clause in clauseDisjonctive { // pour chaque disjunction de notre set on l'insert dans le resultat
         resultat.insert(clause.disjunctionOperands) // on insert chaque valeurs des conjunctions des disjonctions dans un tableau
                                                    // les valeurs sont regroupée par l'opérateur des conjonction pour l'insertion
         }
         return resultat // on retourne le Set de Set si self n'était pas vide
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
