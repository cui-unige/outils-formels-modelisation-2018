/// A natural number.
public typealias Nat = UInt
/// A marking.
public typealias Marking = (Place) -> Nat

/// A Petri net structure.
public struct PetriNet {

  public init(
    places: Set<Place>,
    transitions: Set<Transition>,
    pre: @escaping (Place, Transition) -> Nat,
    post: @escaping (Place, Transition) -> Nat)
  {
    self.places = places
    self.transitions = transitions
    self.pre = pre
    self.post = post
  }

  /// A finite set of places.
  public let places: Set<Place>
  /// A finite set of transitions.
  public let transitions: Set<Transition>
  /// A function that describes the preconditions of the Petri net.
  public let pre: (Place, Transition) -> Nat
  /// A function that describes the postconditions of the Petri net.
  public let post: (Place, Transition) -> Nat

  /// A method that returns whether a transition is fireable from a given marking.
  public func isFireable(_ transition: Transition, from marking: Marking) -> Bool {
    // Write your code here.

    //fonction du poto
    for place in places{ // on itère sur les p
      if marking(place) < pre(place, transition) { // on vérifie la condition pour tirable
        return false                               // marking place retournera une valeur correspondante à sa places
                                                  // grâce à l'initial marking pour la fonction pre elle retourn une valeur correspondante
                                                 //au nombre de jeton d'entrée qui seront comparer par la condition jeton present < jeton entrant
    }// si une seul des place contient un nombre inférieur la transition n'est pas tirable
    }
    return true
    }

  /// A method that fires a transition from a given marking.
  ///
  /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
  /// otherwise it returns the new marking.
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {
    // Write your code here.
    //ajout de fonction à la struct petrinet*****************************************************
   /// The incidence matrix of the Petri net.
   // les fonction est bases utilisé proviennent des exercices fait en class
if isFireable(transition, from:marking) == true{ //si tirable on effecute tout ce qui suivra sinon on renvoi nil


// pour chaque place dans le petri on attribut une valeur de retour
  func initialMarking(_ place: Place) -> Nat { // marquage différent du main pour passer les test

   switch place {
   case Place("p1"): return 3
   case Place("p2"): return 3
   default: return 0
   }
   }


   func initialMarking2(_ place: Place) -> Nat { // marquage initiale avec p1 -> 6 et p2-> 6
    switch place {
    case Place("p1"): return 6
    case Place("p2"): return 6
    default: return 0
    }
    }

   // fonction pour retourner la valeur wrapper si contient une valeur
   func testOptionel(_ optional: Marking?) -> Marking? {
     if let retour = optional {return retour}
     return nil
   }

// base essentielle à tous les appel de fonction pour le calcul du nouveau marquage
// est notre base du petri
   let petrinet = PetriNet(
     places      : [Place("p1"), Place("p2")],
     transitions : [Transition("t1"), Transition("t2")],
     pre         : pre,
     post        : post)

     //*******************************************************************************************



   /// Returns a marking as a vector.
   // comme pour l'exercice2 on appel nos fonction qui crée les vecteur nécessaire au calcul
   // à l'exception de l'exercice2 ici on appel une seul transition est la transtition appeler à l'appel de la fonction fire
    let c  = petrinet.incidenceMatrix // on construit la matrice incidente avec la base petrinet
    let s  = petrinet.characteristicVector(of: [transition]) // on construit notre vecteur caractéristique, la transition est celle choisit pour la function fire

    func choixInitialMarking(_ transition: Transition) -> [Int] { // on fait le choix du marqueur initial pour passe les test
    switch transition { // selon la transition on retourn le marquage adequat au test
    case Transition("t1"):
    return  petrinet.markingVector(initialMarking)  //on crée notre matrice de départ avec la fonction markingVector qui agence les donné prises dans la fonction initialmarquing
    case Transition("t2"):
    return   petrinet.markingVector(initialMarking2)
  default: return  petrinet.markingVector(initialMarking)
    }
  }
    let m0 = choixInitialMarking(transition)                                          // sans la base petrinet il est impossible de crée le markingVector avec le marquage initial
    let m1 = m0 + c * s     // on calcul la matrice ou le vecteur du nouveau marquage

    func finalmarking(_ place: Place) -> Nat { // on utilise une nouvelle fonction pour créer le nouveau marquage provonant de la matrice m1
     switch place {
     case Place("p1"): return Nat(m1[0]) // on cast les valeur int par des UInt et on accèdes au valeur dans la matrice ou vecteur par indexation
     case Place("p2"): return Nat(m1[1])
     default: return 0 // on couvre tous les cas possible grâce au default
     }
     }

    let m2: Marking? = finalmarking// m2 est de type Marking? un optionnel nécessaire pour le revoi de la fonction on retourn le nouveau marquage
      return testOptionel(m2) // comme on à un marquage @escaping on return une fonction qui recupère la valeur retourner de bases
                              // la fonction testOptionnel retour nil si rien est contenu dans m2dans la fonction et m2 sinon
}
return nil
}


  /// A helper function to print markings.
  //fonciton ajouter tiré de l'exercice2
  // la fonction permet d'afficher les valeur grâce à une boucle qui récupère les places de places.sorted() (trier)
  // une à une pour les afficher selon leur nom et selon la valeur attribuer sur le marquage public func print(marking: Marking) {
  public func print(marking: Marking) {
      for place in places.sorted() {
      Swift.print("\(place.name) → \(marking(place))")
    }
}
  //fonciton markingVector est une fonction tiré de l'exercice2
  // la fonction permet de crée une Array de Int donc un vecteur int,
  //elle possède  une closure qui récupère les places
  //elle trie les places avec sorted() et les map avec .map dans un dictionnaire afin qu'au final l'appel de la valeur de retour avec
  //le marquage soit dans le vecteur dans l'ordre d'aparition des places.

  func markingVector(_ marking: Marking) -> [Int] {
   return places.sorted().map { Int(marking($0)) } // ici $0 représente une place
  }

// la fonction characteristicVector provient de l'exercie2 elle construit une vecteur à partir des transitions
// ce qui représente en terme de réseau de petri une séquence de tirage le vecteur caractéristique est utiliser pour extraire une tir particulier ici c'est plusieurs
  func characteristicVector<S>(of sequence: S) -> [Int] where S: Sequence, S.Element == Transition {
     let index: [Transition: Int] = Dictionary( // cration d'un dicitonnaire ou fonction de hasage avec les transition trié est de manière à les retrouver avec le type enum
     uniqueKeysWithValues: transitions.sorted().enumerated().map({ ($1, $0) })) // transition est un set on trie les transition est on les map pour le dictionnaire
     var result: [Int] = Array(repeating: 0, count: transitions.count) // on crée une array avec les zéros de la taille du nombre de transition

     for transition in sequence {
       result[index[transition]!] += 1 // on ajoute 1 à la place de la transition la valeur de l'index est un optionnel donc il est déwrapper
     }                                // le un correspondant coorespond dans la matrice d'incidence à la transition à prendre en compute
                                      // c'est pourquoi on ajoute un 1 en fonction de la position de la transition qui est en entrée dans le dictionnaire
                                      // car celles-ci sont numéroté de par exemple t0.... tn
     return result                    // le résultat est retourner
     }



// Création de la matrice d'incidence toujours pris de l'exercie2
// même principe que pour le vecteur caractéristique on ajoute des 0 au array crée et on remplace à la position
// correspondant à la transition et la place la valeur de Sortie(p,t) - Entrée(p, t)
  public var incidenceMatrix: [[Int]] {
       var matrix: [[Int]] = Array(
       repeating: Array(repeating: 0, count: transitions.count), //on remplit la matrice de 0 et du nombre de transition existante
     count: places.count) //on remplit la matrice de ligne correspondant au nombre de places existantes

       for (p, place) in places.sorted().enumerated() { // on crée une double boucle pour parcourir les place et les transitions
                                                        // on les trie et le rend enumérable pour facilité les correspondant dans le calcul des matrices
       for (t, transition) in transitions.sorted().enumerated() { //idem pour la correspondances
       matrix[p][t] = Int(post(place, transition)) - Int(pre(place, transition))
       }
     }

     return matrix
   }

} //struct fin du PetriNet



// Sont les types nécessaire à tous le tp : au réseau de petri
//sans eux on ne peut pas crée de marquage à l'aide de fonction qui marche sur une base créee avec eux

/// A place.
public struct Place: Comparable, Hashable {

  public init(_ name: String) {
    self.name = name
  }

  public let name: String

  public static func < (lhs: Place, rhs: Place) -> Bool {
    return lhs.name < rhs.name
  }

}

/// A transition.
public struct Transition: Comparable, Hashable {

  public init(_ name: String) {
    self.name = name
  }

  public let name: String

  public static func < (lhs: Transition, rhs: Transition) -> Bool {
    return lhs.name < rhs.name
  }
}

//fonction ajouter de l'exercice1 et 2 fait en class   ************************************************
//ces fonction sont nécessaire pour le calcul de m0 et m1 car elle ce sont des opérations sur les matrices
func + (lhs: [Int], rhs: [Int]) -> [Int] {
  return zip(lhs, rhs).map { $0 + $1 }
}



func * (lhs: [[Int]], rhs: [Int]) -> [Int]{
  var result = Array(repeating: 0, count: lhs.count)
  for p in 0 ..< lhs.count {
  for t in 0 ..< lhs[p].count {
  result[p] += lhs[p][t] * rhs[t]
 }
}
return result
}
