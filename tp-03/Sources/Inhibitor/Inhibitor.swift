public struct InhibitorNet<Place> where Place: Hashable {

  /// Struct that represents an transition of a Petri net extended with inhibitor arcs.
  public struct Transition: Hashable {

    public init(name: String, pre: [Place: Arc], post: [Place: Arc]) {
      for (_, arc) in post {
        guard case .regular = arc
          else { preconditionFailure() }
      }

      self.name = name
      self.preconditions = pre
      self.postconditions = post
    }

    public let name: String
    public let preconditions: [Place: Arc]
    public let postconditions: [Place: Arc]

// la fonction getArcValue permet d'extraire les valeurs wrapper dans le .regular
    private func getArcValue(_ arc: InhibitorNet<Place>.Arc)-> Int { // on prend en paramètre normalement les valeurs associées au index des map préconditions et postconditions
        switch arc {  // ici on fait passer les test à notre paramètre avec la fonction switch
        case .regular(let val): return val // si on tombe sur un regular on deWrappe la valeur associé qui est un int
        case .inhibitor: return 0         // si on tombe sur un inhibitor, alors on retourne zéro
        default: // par défault il faut retourner tous les cas possible avec un switche alors on affiche qu'il y eu une erreur, si on est pas tomber dans les cas précédents
        print("erreur getArcValue") //
        return 0; // on retourne 0 car le type de retour est un int

      }
    }

    /// A method that returns whether a transition is fireable from a given marking.
    public func isFireable(from marking: [Place: Int]) -> Bool {
      // Write your code here.
    for (place, arc) in preconditions { // on va chercher les places et les valeur des préconditions de notre place
    if arc == .inhibitor { // pour chaque arc de la place on regarde si elle contient un inhibiteur
                          // si c'est le cas la transition est tirable que si la valeur du marquage est zéro
    if let valeur1 = marking[place], valeur1 != 0 { return false } // // le marquage est différent de zéro alors ce n'est pas tirable
    }
    else { // l'arc qui part de la place ne contient pas d'inhibiteur, alors on revient au condition d'un Rdp sans inhibiteur
    if let valeur2 = marking[place], getArcValue(arc)  > valeur2 { return false }// la valeur du marquage est plus grande que la valeur contenu dans
    // la fonciton getArcValue() est décrite plus haut avant isfirable             // le wrapping de .regular alors la transition est tirable
    }
    }
    return true // si la transition est tirable on retourn true
}

    /// A method that fires a transition from a given marking.
    ///
    /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
    /// otherwise it returns the new marking.

    public func fire(from marking: [Place: Int]) -> [Place: Int]? {
      // Write your code here.
    guard self.isFireable(from: marking) else { //  on test si on peut tirer depuis le marquage initial
    return nil // si on peut pas on retourne un marquage vide
    }
    // rappel: on fait le nouveau marquage = le marquage initial +( les Sorties - les Entrées)
    var result = marking // on initialise notre nouveau marquage avec les valeurs du marquage initiale
    for (place, arc) in preconditions { // on va chercher les index et les valeur des préconditons du marquage
    result[place]! -= getArcValue(arc) // pour chaque valeur du marquage on met à jour avec la nouvelle valeur de l'arc allant à la transition répertorier dans le marquage
    }
    for (place, arc) in postconditions { // idem que en haut : rappel la fonction getArcValue est décrite plus haut avant isfirebale
    result[place]! += getArcValue(arc) // ici en revanche on ajoute la valeur car c'est l'arc sortant
    }
    return result // on retourne le résultat
    }



}

  /// Struct that represents an arc of a Petri net extended with inhibitor arcs.
  public enum Arc: Hashable {

    case inhibitor
    case regular(Int)

  }

  public init(places: Set<Place>, transitions: Set<Transition>) {
    self.places = places
    self.transitions = transitions
  }

  public let places: Set<Place>
  public let transitions: Set<Transition>

}
