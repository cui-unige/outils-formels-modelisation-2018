extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.




  /*
  Principe :
  On ajoute le marking initial à l'array
  On tire la transition
  Si c'est 0 y a pas de successeurs donc continue
  - Si le successeur = root alors on fait rien car sinon on répète le même schéma
  - Si le next marking (marquage suivant) est plus grand qu'un prédécesseurs,
  c'est non borné donc return nil
  - Sinon on ajoute les marquages successeurs à l'array pour pouvoir les comparer après
  (pour comparer les marquages actuels de ceux passés)
  */
  // Fonctions issues de l'exercice 4 du séminaire



  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.

    /*BEGIN modify--------------------------------------------------*/

    /*
    * Initialisation du marquage initial
    */
    let root = MarkingNode(marking: initialMarking)

    /*
    * Initialisation de la liste de vecteur parcourus dans le but de pouvoir
    * déterminer si le graphe est borné
    */
    var browesedVectors = [root]

    /*
    * Initialisation de la liste des marquages parcourus dans le but de pourvoir
    * comparer les marqueurs successeurs aux précédents
    */
    var unprocessed : [(MarkingNode<Place>,[MarkingNode<Place>])] = [(root, [])]

    /*
    * On compare les marquages passés à ceux dans (unprocessed)
    *
    * On prend le dernier élément de la liste et le supprime
    */
    while let (node, predecessors) = unprocessed.popLast() {

      //On parcourt toutes les transitions
      for transition in transitions{

        //On controle si la transition est tirable; Oui : on continue ; Non : la boucle s'incrémente
        guard let nextmarking = transition.fire(from: node.marking) else {
          continue
        }

        /*
        * Si le marquage successeur (nextmarking) est égal à un précédent
        * marquage (other), alors on connaît la séquence et donc le graphe
        * de marquage: on continue à itérer
        *
        * METHOD: first permet de retrouver le premier marquage respectant
        * la condition dans la liste
        *
        * Si le marquage successeur (nextmarking) est plus grand qu'un pécédent
        * marquage, alors le réseau est non-borné : on retourne null
        *
        * Sinon on ajoute le marquage suivant à la liste browesedVectores
        * et unprocessed avec les marquage précédents comprenant
        * le marquage actuel puis on continue à itérer
        */

        if let successor = browesedVectors.first(where: {other in other.marking == nextmarking}){
          node.successors[transition] = successor

        } else if predecessors.contains(where : {other in other.marking < nextmarking}){
          return nil

        } else {
          let successor = MarkingNode(marking: nextmarking)
          browesedVectors.append(successor)
          unprocessed.append((successor, predecessors + [node]))
          node.successors[transition] = successor

        }
      }
    }

    /*END modify--------------------------------------------------*/

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

    /*BEGIN modify--------------------------------------------------*/

    /*
    * Initialisation du marquage initial
    */
    let root = CoverabilityNode(marking: extend(initialMarking))

    /*
    * Initialisation de la liste de vecteur parcourus dans le but de pouvoir
    * déterminer si le graphe est borné
    */
    var browesedVectors = [root]

    /*
    * Initialisation de la liste des marquages parcourus dans le but de pourvoir
    * comparer les marqueurs successeurs aux précédents
    */
    var unprocessed : [(CoverabilityNode<Place>,[CoverabilityNode<Place>])] = [(root, [])]

    /*
    * On compare les marquages passés à ceux dans (unprocessed)
    *
    * On prend le dernier élément de la liste et le supprime
    */
    while let (node, predecessors) = unprocessed.popLast() {

      //On parcourt toutes les transitions
      for transition in transitions{

        //On controle si la transition est tirable; Oui : on continue ; Non : la boucle s'incrémente
        guard var nextmarking = transition.fire(from: node.marking) else {
          continue
        }

        // Si le premier marquage déjà tiré est < que le marquage successeur (nextmarking) : On itère dans les places
        if let predecessor = predecessors.first(where : {other in other.marking < nextmarking}){

          // On parcourt la liste de place
          for place in Place.allCases{
            /*
            * Si le marquace précédent (predecessor) est < que le successeur (nextmarking), donc non borné
            * Alors on attribue la valeur "omega" au marquage et ainsi la branche est terminée
            */
            if predecessor.marking[place] < nextmarking[place]{
              nextmarking[place] = .omega
            }
          }
        }

        // Si le marquage actuel est < que le marquage sucesseur (nextmarking)
        if node.marking < nextmarking{

          for place in Place.allCases {
            //On attribue "omega" au marquage de la place qui a le plus de jetons
            if node.marking[place] < nextmarking[place] {
              nextmarking[place] = .omega
            }
          }
        }

        /*Si le marquage sucesseur (nextmarking) est égal à un marquage précédent (other)
        * Cela implique qu'on connaît déjà la séquence: On l'ajoute à la liste des successeurs
        */
        if let successor = browesedVectors.first(where: {other in other.marking == nextmarking}){
          node.successors[transition] = successor
        } else {  // Si le marquage est plus petit que les marquages déjà calculer, on ajoute le marquage suivant à la lite created et on l'ajoute aussi à unprocessed avec avec les marquage précédents comprenant le marquage actuael pour continuer la branche
          /*
          * Sinon on ajoute le marquage suivant à la liste browesedVectores
          * et unprocessed avec les marquage précédents comprenant
          * le marquage actuel puis on continue à itérer
          */
          let successor = CoverabilityNode(marking: nextmarking)
          browesedVectors.append(successor)
          unprocessed.append((successor, predecessors + [node]))
          node.successors[transition] = successor
        }
      }
    }

    /*END modify--------------------------------------------------*/

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
