extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking)
//****************** my test **************************************
var created = [root]
  var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // les visités

  while let (node, predecessors) = unprocessed.popLast() { // on sort le visité pour l'analyser
    for transition in self.transitions { // on regarde les transitions du visité
      guard let nextMarking = transition.fire(from: node.marking) // on regarde si un maquage depuis le visité existe
        else { continue } // sinon : nil , on continue            // on crée également le nouveau marquage
      if let successor = created.first(where : { other in other.marking == nextMarking }) { // on prend le premier de liste créé on le compare entre le marquage initiale et le nouveau
        node.successors[transition] = successor// si oui on a trouver un successeur  sinon ce n'est pas un successeur , si oui on l'ajoute à la liste des successeurs
      } else if predecessors.contains(where: { other in nextMarking > other.marking }) { // si le nouveou marquage est plus grand que l'encien d'un appartenant à la liste de prédecesseur alors on arrive en fin de branche
        return nil // le chemin se termine
      } else { // evaluation terminer pour un état on passe au prochains mais en répertoriant nos découvertes
        let successor = MarkingNode<Place>(marking: nextMarking) // on créer un graphe successor pour l'ajouter au graphe le marquage initial devient nextmarking
        created.append(successor)// on ajoute notre nouveau graphe au graphe successor
        unprocessed.append((successor, predecessors + [node])) // on ajoute notre successor au noeud visité pour le prochain pas
        node.successors[transition] = successor // on ajoute à l'index des successor ,associer à notre transition le successeur
      }
    }
  }

// en retournant la racine on retourne tout le graphe procédé itératif implique dfs recherche en profondeur



//******************************************************************
    return root
  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
    {
      // TODO: Replace or modify this code with your own implementation.
      let root = CoverabilityNode(marking: extend(initialMarking)) // on créer notre racine
      var created = [root] // on stock la racine dans les élément déja crée et indexé
      var unprocessed : [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])] // on crée un tableau d'éléments pas encore crée

      while let (node, predecessor) = unprocessed.popLast() // tant qu'il reste des élément à dépoper on continue
      {// on récupérer le noeud courant et les précedents
        for transition in self.transitions // on parcourt toutes les transitions pour tout le processus
        {
          if var nextMarking = transition.fire (from: node.marking) // on crée un marquage pour le noeud suivant
          {                                                         // il nous aide à savoir si on est borné
            if let unbounded = predecessor.first(where: {element in element.marking < nextMarking})
            { // on trouve tous les précédents qui n'ont pas été bornés
              for place in Place.allCases
              {    // la boucle va chercher les index existant des dictionnaire avec la métode allCase
                if unbounded.marking[place] < nextMarking[place] // on compare pour savoir si nextMarking à l'index courrant borne le précédent courrant
                {
                  nextMarking[place] = .omega // si c'est le cas on remplace le label précédemment crée par omega
                }
              }
            }

            if node.marking < nextMarking   // on effectuer le même procecessus pour le noeud qui n'est pas dans les précédent pour s'assurer d'obtenir tous les cas
            {
              for place in Place.allCases //
              {
                if (node.marking[place] < nextMarking[place])
                {
                  nextMarking[place] = .omega
                }
              }
            }

            if let successor = created.first(where: {element in element.marking == nextMarking}) //dans le cas ou le marquage lié à la transition courrante existe déja dans les noeud déja traité on le stocke

            {
              node.successors[transition] = successor // sotckage du successor on ne crée pas de coverabilityNode<Place>(marking: nextMarking) mais on aurait pu
            }                                         // car succerssor contient le type adéquat récupérer du  created qui est lui même du type Coverability<Place>(marking: ...)
            else
            {
              let successor = CoverabilityNode(marking: nextMarking) // dans tous les cas on crée notre type pour le stockage
              created.append(successor) // on stock notre nouveau marquage en fonction des transition dans created
              unprocessed.append((successor, predecessor + [node])) // on ajoute le noeud suivant comme prochain noeud à visité
              node.successors[transition] = successor // on ajoute à notre noeud courrant le successeur
            }
          }
        }
      }
      return root // on retourne tout le graphe en retournant la racine
    }


  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }
}
// on ajoute cette fonction dans PetriNet après fire
  /*
  public func creatNewMarking(from marking: Marking<Place, ExtendedInt>, _ otherMarking: Marking<Place, ExtendedInt>) -> Marking<Place, ExtendedInt>? {
    guard self.isFireable(from: marking) else {
      return nil // ce n'est pas tirable on obtiendra pas de marquage
    }
  var Ind: Array<Place> = [] // array pour stocker les indexation
    var counterfalse = 0 // variable pour stocker le nombre d'élément différent
    var counterIdentical = 0 // variable pour compter le nombre d'élément identique
    var marking1 = marking // le marquage du visité
    var marking2 = otherMarking // le marquage des déjà  visité
    for arc in self.preconditions { // on var chercher les arc pour calculer le marquage
      marking1[arc.place] -= .concrete(arc.label) // on soustrait pour les deux marquages les entrés en fonction de la transition donnée implicitement
      marking2[arc.place] -= .concrete(arc.label)
    }
    for arc in self.postconditions { // idem qu'avant mais on additionne pour obtenir les sorties
      marking1[arc.place] += .concrete(arc.label)
      marking2[arc.place] += .concrete(arc.label)
    }
    for arc in self.postconditions { // on verifie que les valeur des jetons des deux nouveaux marquages correspondent
      if marking1[arc.place] != marking2[arc.place]{  // on compare les valeus, si différentes on ajoute une valeur à notre variable qui compte les différences
        counterfalse = counterfalse + 1
        if marking1[arc.place] > marking2[arc.place]{ // une fois qu'on sait que les valeurs sont différentes, donc une plus grande que l'autre
          Ind.append(arc.place) // on peut ajouter l'index de changement dans notre tableau d'index
        }
      }
    }
    if counterfalse < 2 { // on change un omega à la fois donc les différence entre les marquage doit être que de 1
      for arc in self.postconditions{  // on reparcourt le tableau et on insert omega à l'index désiré
      if let placebis =  Ind.first { // est un optionnel il faut le tester
        if arc.place == Ind.first{
      marking1[arc.place] += .omega // la valeur omega est déja existante dans la librerie du tp-02
      return marking1 // on retourne le nouveau marquage
    }
    }
    }
 }
    return nil // on ne veut pas ajouter de marquage qui n'est pas nécessaire donc selon les différences on affichera pas de nouveau marquage
  }
}
*/
