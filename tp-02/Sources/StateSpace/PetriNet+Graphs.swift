extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.

    let root = MarkingNode(marking: initialMarking)

    //noeuds déjà crées
    var crees: [MarkingNode<Place>] = [root]

    //noeuds à visiter
    var aVisiter: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]

    //exploration des noeuds du graphes depuis la racine
    while let (noeud,precedents) = aVisiter.popLast(){
      for transition in self.transitions{

        //on teste si la transition est tirable depuis le marquage courant
        if let marquageSuivant = transition.fire(from: noeud.marking){

          //on cherche le marque suivant dans les noeuds déja crées
          if let successeur = crees.first(where: {$0.marking == marquageSuivant}){

            //s'il a déjà été évalué, on le lie au noeud courant
            noeud.successors[transition] = successeur
          }
          //si le marquage n'a pas déjà été évalué, mais que celui-ci est plus grand qu'un marquage précédement évalué,
          //celà signifie que le modèle n'est pas borné
          else if (precedents.contains(where: { $0.marking < marquageSuivant})){
            return nil
          }
          //si le marquage n'a pas déjà été visité et que celui-ci ne fait pas croitre le modèle de manière non-borné
          else{
            //on crée un nouveau marquage
            let successeur = MarkingNode(marking: marquageSuivant)

            //on l'ajoute à la collection des noeuds crées
            crees.append(successeur)

            //on l'ajoute aux noeuds à visiter ce dernier ainsi que ses précédents noeuds
            aVisiter.append((successeur, precedents + [noeud]))

            //on crée la transition entre le noeud courant et le nouveau noeud
            noeud.successors[transition] = successeur
          }
        }
      }
    }

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
    let root = CoverabilityNode(marking: extend(initialMarking))

    //noeuds déjà crées
    var crees: [CoverabilityNode<Place>] = [root]

    //noeuds à visiter
    var aVisiter: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

    //exploration des noeuds du graphes depuis la racine
    while let (noeud,precedents) = aVisiter.popLast(){
      for transition in self.transitions{

        //on teste si la transition est tirable depuis le marquage courant
        if var marquageSuivant = transition.fire(from: noeud.marking){

          //si un précédent marquage est plus petit que le prochain marquage
          if let precedentPlusPetit = precedents.first(where: {$0.marking < marquageSuivant}){

            //pour toutes les places concernées
            for place in Place.allCases{

              //s'il y a plus de jetons dans la place du prochain marquage que dans la place du précédent marquage
              if(marquageSuivant[place] > precedentPlusPetit.marking[place]){

                //on insert un oméga dans la place du prochain marquage
                marquageSuivant[place] = ExtendedInt.omega
              }
            }
          }

          //si le marquage courant est plus petit que le prochain marquage on reproduit le même comportement ci-dessus
          if marquageSuivant > noeud.marking{
            for place in Place.allCases{

              if(marquageSuivant[place] > noeud.marking[place]){

                marquageSuivant[place] = ExtendedInt.omega
              }
            }
          }

          //si le prochain marquage figure déjà dans les noeuds créés
          if let successeur = crees.first(where: {$0.marking == marquageSuivant}){

            //on le lie au noeud courant
            noeud.successors[transition] = successeur
          }
          else{
            //on crée un nouveau marquage
            let successeur = CoverabilityNode(marking: marquageSuivant)

            //on l'ajoute à la collection des noeuds crées
            crees.append(successeur)

            //on l'ajoute aux noeuds à visiter ce dernier ainsi que ses précédents noeuds
            aVisiter.append((successeur, precedents + [noeud]))

            //on crée la transition entre le noeud courant et le nouveau noeud.
            noeud.successors[transition] = successeur
          }
        }
      }
    }

    return root
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
