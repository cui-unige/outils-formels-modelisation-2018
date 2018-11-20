extension PetriNet {

    /// TP par Arnaud Savary et Matthieu Vos

    /// Computes the marking graph of this Petri net, starting from the given marking.
    /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
    /// the root of the marking graph. If the model isunbounded, the function returns nil.
    public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
        // On commence par quelques déclarations :
        let root = MarkingNode(marking: initialMarking) // Ceci est notre racine, composée du marquage initial et de ses successeurs
        var noeuds: Array<MarkingNode<Place>> = [] // On va stocker dedans tous nos noeuds
        var aTraiter: [(MarkingNode<Place>, [MarkingNode<Place>])] = [] // Elements à traiter de la forme (noeud, predecesseur)

        // On les initialise avec root
        noeuds.append(root) // On rajoute root dans la liste de nos noeuds
        aTraiter.append((root, [])) // On rajoute root dans aTraiter

        while !aTraiter.isEmpty { // Boucle tant que nous n'avons pas tout traité
          let (noeud, predecesseur) = aTraiter.popLast()! // On récupère le dernier élément à traiter (le ! est un optionnel)
            for t in transitions { // Boucle parcourant toutes les transitions
                guard let markingSuccesseur = t.fire(from: noeud.marking) // Le marquage du successeur est obtenu grâce à la fonction fire
                else {
                    continue
                }
                if predecesseur.contains(where: { other in other.marking < markingSuccesseur }) { // Cas où nous ne sommes pas borné
                    return nil // Notre fonction n'a pas été crée pour ce genre de cas, on retourne nil comme demandé dans l'énoncé
                }
                else if let successeur = noeuds.first(where: { other in other.marking == markingSuccesseur }) { // Cas où notre marquage avait déjà été traité
                    noeud.successors[t] = successeur // On le rentre entant que successeur de notre noeud
                }
                else { // Cas où il s'agit d'un nouveau marquage
                    let successeur = MarkingNode(marking: markingSuccesseur) // On crée notre nouveau noeud
                    noeud.successors[t] = successeur // On le rentre entant que successeur de notre noeud
                    aTraiter.append((successeur, predecesseur + [noeud])) // On le rajoute dans notre liste aTraiter
                    noeuds.append(successeur) // On le rajoute à notre liste de noeuds
                }
            }
        }
        return root
    }

    /// Computes the coverability graph of this Petri net, starting from the given marking.
    ///
    /// This method computes the coverability graph of the Petri net, and returns its root. Note that
    /// if the model's bound, the coverability graph is actually equivalent to the marking one.
    public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>) -> CoverabilityNode<Place>? {
        // On déclare :
        let root = CoverabilityNode(marking: extend(initialMarking))// Ceci est notre racine, composée du marquage initial et de ses successeurs
        var noeuds: Array<CoverabilityNode<Place>> = [] // On va stocker dedans tous nos noeuds
        var aTraiter: [(CoverabilityNode<Place>, [CoverabilityNode<Place>])] = [] // Elements à traiter de la forme (noeud, predecesseur)

        // On initialise avec root :
        noeuds.append(root) // On rajoute root dans nos noeuds
        aTraiter.append((root, [])) // On rajoute root dans aTraiter

        while !aTraiter.isEmpty { // Boucle tant que nous n'avons pas tout traité
          let (noeud, predecesseur) = aTraiter.popLast()! // On récupère le dernier élément à traiter
            for t in transitions { // Boucle parcourant toutes nos transitions
                guard var markingSuccesseur = t.fire(from: noeud.marking) // Le marquage du successeur est obtenu grâce à la fonction fire
                else {
                    continue
                }
                // On compare les nombre de jetons, pour un cas où on ne serait pas borné :
                if let predecesseur = predecesseur.first(where: { other in other.marking < markingSuccesseur }) {
                    for p in Place.allCases { // Boucle parcourant les places
                        if markingSuccesseur[p] > predecesseur.marking[p] { // On compare le nombre de jetons
                            markingSuccesseur[p] = .omega // On est non borné dans ce cas, donc on utilise omega
                        }
                    }
                }

                if let successeur = noeuds.first(where: { other in other.marking == markingSuccesseur }) { // Cas où notre marquage avait déjà été traité
                    noeud.successors[t] = successeur // On le rentre entant que successeur de notre noeud
                }
                else { // Cas où il s'agit d'un nouveau marquage
                    let successeur = CoverabilityNode(marking: markingSuccesseur) // On crée notre nouveau noeud
                    noeud.successors[t] = successeur // On le rentre entant que successeur de notre noeud
                    aTraiter.append((successeur, predecesseur + [noeud])) // On le rajoute dans notre liste aTraiter
                    noeuds.append(successeur) // On rajoute notre noeud dans la liste des noeuds
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
            })
        )
    }
}
