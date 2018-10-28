extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking)

      var nodesG: [MarkingNode<Place>] = [root] // colection des nodes pour garder les nodes du graphe

      var pasVU: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // Dictionaire pour garder les nodes et ses predeceseur pour chauqe node du graphe

       while let (nodeHabille,predecessors) = pasVU.popLast(){ // bucle pour explorer les nodes du graphe depuis la razine
        for transition in transitions{ // il parcourt l'ensamble des transitions de la rexeau

          if let MarkingSuc = transition.fire(from: nodeHabille.marking){ // la transition est tirable ? -> depuis le marcage actuelle
            if let successors = nodesG.first(where: {$0.marking == MarkingSuc}){ // si le marcage resultant a été deja evalué, on ne le refera plus.
            nodeHabille.successors[transition] = successors
          } else if (predecessors.contains(where: { $0.marking < MarkingSuc})){// Si il existe un marcage predeceseur plus petit dasn le chemin que le marcage successor cette reseaux n'est pas bornét
              return nil
            } else{
              // un nouvelle node va etre enrregistre, il sera nu pendant ça naissance
              let nodeNu = MarkingNode(marking: MarkingSuc) //ceci garde le marcage de le node nu
              pasVU.append((nodeNu, predecessors + [nodeHabille])) // on garde le nouveau node nu, et on garde ses predeceseurs (habillé)
              nodesG += nodeNu // on garde le nuveau node nu dans la colection des nodes
              nodeHabille.successors[transition] = nodeNu // on ajoute le node nu dans la liste des successors du node habillé
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
    //root represente le node avec le marcage initial(la racine)
    let root = CoverabilityNode(marking: extend(initialMarking)) //aqui se guardan todos los nodos, comenzamos con raiz porque es el primer nodo
    // nodesG est une colection des nodes pour garder les nodes du graphe
    var nodesG: [CoverabilityNode<Place>] = [root]
    //pasVU represente un colection des noeudes(nodesG), que on doit explorer
    var pasVU: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]

     while let (nodeHabille,predecessors) = pasVU.popLast(){ // bucle pour explorer les nodes du graphe depuis la razine
       for transition in transitions{ // il parcourt l'ensamble des transitions de la rexeau

        //-----------
        //on tire de la transitions en cours et on regarde le marcage successor,
        if var MarkingSuc = transition.fire(from: nodeHabille.marking){ // on tire la transition et on la garde dans MarkingSuc
          if let predecessor = predecessors.first(where: {$0.marking < MarkingSuc}){ // on garde le premier marcage predecesseur plus petite que le successor
            for place in Place.allCases{
              if(MarkingSuc[place] > predecessor.marking[place]){ //Si il y a  plus de jetons dans la place de successor que dans predecessor
                MarkingSuc[place] = .omega //On met un oméga dans la place de successor
              }
            }
          }
      //------------
      //Si le marquage successor est plus grande que le marquage du nodeHabille(actuelle)
           if MarkingSuc > nodeHabille.marking{
            for place in Place.allCases{
              if(MarkingSuc[place] > nodeHabille.marking[place]){ //Si il y a  plus de jetons dans la place de successor que dans nodeHabille
                MarkingSuc[place] = .omega //On met un oméga dans la place de successor
              }
            }
          }
     //------------
     //Si on a déjà vu le prochain marquage, s'il existe déjà
           if let successors = nodesG.first(where: {$0.marking == MarkingSuc}){ //après la transition ceci deviene successor, si existe deja on ne va pas l'explorer
            nodeHabille.successors[transition] = successors
          }else{
            // un nouvelle node va etre enrregistre, il sera nu pendant ça naissance
            let nodeNu = CoverabilityNode(marking: MarkingSuc) //ceci garde le marcage de le node nu
            pasVU.append((nodeNu, predecessors + [nodeHabille])) // on garde le nouveau node nu, et on garde ses predeceseurs (habillé)
          nodesG += nodeNu // on garde le nuveau node nu dans la colection des nodes
            nodeHabille.successors[transition] = nodeNu // on ajoute le node nu dans la liste des successors du node habillé
          }
     //-----------

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
