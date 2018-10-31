extension PetriNet {




  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>?
    // GRAPHE DE MARQUAGE

    {

      let root = MarkingNode<Place>(marking: initialMarking) // On crée un noeud avec le marking initial
      var created = [root] // On initie la racine

      var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])] // une racine sans prédécesseurs
      // La liste contient une liste de noeuds, donc ses prédécesseurs
      // On prend le noeud et les predecesseurs et on le retire des unprocessed

      while let (node, predecessors) = unprocessed.popLast() { // On prend le dernié noeud qui n'a pas été étudié

          for transition in self.transitions {  // Pour toutes les transitions qui existent dans le rdP
            // si la transition est tirable


            guard let nextMarking = transition.fire(from: node.marking) // regarde si la transition est tirée depuis le dernier marquage, Si la transition est fireable (tirable)

            else{ continue } // Si pas encore tirée, on continue

            if let successor = created.first(where : { other in other.marking == nextMarking }) {  // --> IF   // Si on trouve un successeur qui est exactement le meme, déjà dans les prédécesseurs

              // Tous les marking plus petit
            node.successors[transition] = successor

          } else if predecessors.contains(where: { other in nextMarking > other.marking }) {      // --> ELSE IF
            return nil
            // SINON, si contient un marquage plus grand, retourne NIL

          } else {                                                                                // --> ELSE
            let successor = MarkingNode<Place>(marking: nextMarking) // On crée un noeud avec ce marking, qu'on nomme successeur
            created.append(successor) // Création du successeur
            unprocessed.append((successor, predecessors + [node]))
            node.successors[transition] = successor
            //  On rajouter un lien entre le node et ce successeur
          }
        }
      }
    return root
  }






  public func computeCoverabilityGraph(from initialMarking: Marking<Place,Int>)
    -> CoverabilityNode<Place>?
  {


    let root = CoverabilityNode(marking: extend(initialMarking)) // On crée un noeud avec le marking initial
  var created = [root] // On crée la racine

  var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root,[])] // une racine sans prédécesseurs
  // La liste contient une liste de noeuds, donc ses prédécesseurs
  // On prend le noeud et les predecesseurs et on le retire des unprocessed

  while let (node, predecessors) = unprocessed.popLast(){// On prend le dernié noeud qui n'a pas été étudié

  for transition in transitions{   // Pour toutes les transitions qui existent dans le rdP

    guard var nextmarking = transition.fire(from : node.marking) // regarde si la transition est tirée depuis le dernier marquage, Si la transition est fireable (tirable)

    else {continue} // Si pas encore tirée, on continue

    if let Successor = predecessors.first(where: {other in other.marking < nextmarking})  {  // Si on trouve un successeur qui est exactement le meme, déjà dans les prédécesseurs


      for place in Place.allCases {       // Pour les places where: { other in !(nextMarking < other.marking) }
        if Successor.marking[place] < nextmarking[place]{ // Si la valeurs de la place du successeur est plus petite que la valeur de la place du prochain Marking
          nextmarking[place] = .omega // on met à jour la valeur à oméga
        }
      }
    }

    if node.marking < nextmarking{  // on regarde TOUS les prédécesseurs de newMarking
      for place in Place.allCases {
        if   node.marking[place] < nextmarking[place]{
          nextmarking[place] = .omega
        }
      }
    }

  if let successor = created.first(where: {other in other.marking == nextmarking})  {
    node.successors[transition] = successor
  }else{
let successor = CoverabilityNode(marking: nextmarking)
created.append(successor)
unprocessed.append((successor, predecessors + [node]))
node.successors[transition] = successor
}

}
}
return root


  }

// Convertit un marquage régulier en un marquage avec des entiers étendus.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}
