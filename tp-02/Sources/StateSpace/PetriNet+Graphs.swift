extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    let root = MarkingNode(marking: initialMarking) //Type de root (Marking, Successor)
    var created = [root] //cree une liste des marquages qui existe
    var unprocessed : [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root,[])] //Type (Node, Predecessor <- list de markingNode), Ce quil reste a explorer
    while let (node, predecessors) = unprocessed.popLast() {//Si je peux, prendre le dernier et le mettre dans node et predecessors, sinon sortir du while
        for transition in transitions { //Declare dans PetriNet
            guard let nextmarking = transition.fire(from: node.marking) //Si je peux, tirer la transition depuis le marquage du noeud sinon revenir au for
            else{continue}
            if let successor = created.first(where: {other in other.marking == nextmarking}) {  //Si je peux, cree la variable, sortir le premier de la liste created qui aura le meme marquage que nextmarking, iterations dans marking, other est comme un i dans un for
                node.successors[transition] = successor //Si cest le cas on lajoute au successor pas besoin dexplorer car on connait deja les maraquages atteignables
            }
            else if predecessors.contains(where: {other in other.marking < nextmarking}) { //Sinon si dans les predecessor il y a un marquage plus petit sarreter car non borne
                return nil
            }
            else {
                let successor = MarkingNode(marking: nextmarking) //type MarkingNode
                created.append(successor) //On l'ajoute a la liste des marquages existant
                unprocessed.append((successor, predecessors + [node])) //On ajoute a unprocessed le successeur pour lexplorer par la suite, on ajoute a tout les predecessor le noeud qu'on visite actuellement
                node.successors[transition] = successor //On ajoute  la liste des successeur du noeud le successeur quon a reussi a tirer
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
      let root = CoverabilityNode(marking: extend(initialMarking))
      var created = [root]
      var unprocessed : [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [(root, [])]
      while let (node, predecessors) = unprocessed.popLast(){
          for transition in transitions{
              guard var nextmarking = transition.fire(from : node.marking) //Si on peut, on definit nextmarking comme etant le marquage apres le tir
              else{continue} //sinon on retourne au for
                if let greatSuccessor = predecessors.first(where: {other in other.marking < nextmarking}) { //Si on peut, on crée greatSuccessor comme etant le premier predecessor a avoir un marquage plus petit pour chaque palce
                    for place in Place.allCases { //Place genre p1,p2,p3,... Iterations sur tout les éléments du type, allcases sert a pouvoir iterier uniqueemnt sur le type place
                        if greatSuccessor.marking[place] < nextmarking[place]{ //Comparer si le predecesseur a une des places (p1,p2,..) plus petit que le nextmarking du noeud
                            nextmarking[place] = .omega //dans le cas ou il y en a plus petit remplacer cette place par omega ex  : (1,5,8) compare a (1,6,8) devient (1,omega, 8)
                        }
                    }
                }
                if node.marking < nextmarking { //on a pas encore compare le node en cours car on compare son fire(successor) avec son predecessors
                    for place in Place.allCases {
                        if node.marking[place] < nextmarking[place]{
                            nextmarking[place] = .omega
                        }
                    }
                }
            if let successor = created.first (where: {other in other.marking == nextmarking}) { //si le marquage existe deja
                node.successors[transition] = successor //ajouter comme successeur du Node
            } else { //Si le marquage existe pas
                let successor = CoverabilityNode(marking: nextmarking)
                created.append(successor) //ajoute au marquage existatn
                unprocessed.append((successor, predecessors + [node])) //on ajoute le successeur au noed a explorer, on ajoute tout les predecessor au noeud actuel
                node.successors[transition] = successor //On ajoute au noeud son suscceseur
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
