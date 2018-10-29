extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    //fonctionnement comme une pile
    let root = MarkingNode(marking: initialMarking)
    //creation d'un noeud avec initialMarking -> comme son nom l'indique ce sera la racine
    var created = [root]
     //creation d'un array avec comme seul valeur à l'intérieur la ''racine''
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root, [])]
    //creation d'un array où chaque element sur une paire de noeuds
    //le premier element de unprocessed est le noeud de marquage où on fera nos opération sur le moment
    //le second est une liste de noeuds de marquage qui "amène" a ce noeud de marquage
    while let (node, predecessors) = unprocessed.popLast() {
    //tant le dernier elememnt de la liste n'est pas vide, c'est a dire le noeuds et sa liste de noeuds
      for transition in transitions {
      //on parcourt les transitions
        guard let nextMarking = transition.fire(from: node.marking)
        //on crée une constante qui prends le tirage du noeud courrant
        //ou il y  a la condition que si ce tirage n'est pas possible on itère sur une autre transition
          else { continue }

        if let successor = created.first(where : { other in other.marking == nextMarking }) {
        //on assigne a successor le premier element dans l'Array de noeud 'created' qui à la même valeur que nextMarking si celui la existe
          node.successors[transition] = successor
        //on lie le noeud au nouveau marquage
        } else if predecessors.contains(where: { other in other.marking < nextMarking }) {
          return nil
        //si en parcourant la liste des noeuds de marquage, il y a une tirage ou les "jetons" augmente, alors elle n'est pas bornée et on retorune nil

        } else {
          let successor = MarkingNode(marking: nextMarking)
          created.append(successor)
          unprocessed.append((successor, predecessors + [node]))
          node.successors[transition] = successor
        }
      }
    }
    return root
   }
  //   let root = MarkingNode(marking: initialMarking)
  //   var created = [root]
  //   var list : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root,[])]
  //
  //       var number = 0;
  //       for element in created { //listeDeNoeudsMarquage{ //On parcourt MarkingNode qui augmentera au fur et a mesure. Si elle s'arrête seule, c'est qu'il y a un puit si elle continue elle est vivant
  //         //et peut dans ce cas etre bornée
  //           var temp = created
  //           for transition in transitions {
  //             if(transition.isFireable(from: element.marking)){
  //             var check = true;
  //             let mark = transition.fire(from: element.marking)!
  //             let t = MarkingNode(marking: mark)
  //             for duplicate in root{
  //               if((duplicate.marking==mark)){
  //                 check = false
  //               }
  //             }
  //             if predecessors.contains(where : {other in other.marking < t}) {
  //               return nil
  //             }
  //               if(check){
  //                 created.append(t)
  //                 node.successors[transition]=t
  //               }
  //
  //             }
  //           }
  //         }
  //
  //
  //   return root
  // }



  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    let root = CoverabilityNode(marking: extend(initialMarking))
    //creation d'un noeud avec initialMarking -> comme son nom l'indique ce sera la racine
    var created = [root]
     //creation d'un array avec comme seul valeur à l'intérieur la ''racine''
    var p : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root, [])]
    while let (n,L) = p.popLast(){
      for t in transitions{
        guard var a = t.fire(from: n.marking)
          else{continue}
          //if (L.contains(where: { other in other.marking < a })) {
          if let big = L.first(where : {other in other.marking < a}){
            for place in Place.allCases {
              if (big.marking[place] < a[place]){
                a[place] = .omega
              }
            }
          }
          if (n.marking < a){
            for place in Place.allCases {
              if (n.marking[place] < a[place]){
                a[place] = .omega
              }
            }
          }
        //  if (L.contains(where: { other in other.marking == a })){
          if let successor = created.first(where : {other in other.marking == a}){
            n.successors[t] = successor
          }
          else{
            let successor = CoverabilityNode(marking: a)
            created.append(successor)
            p.append((successor, L + [n]))
            n.successors[t] = successor
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
