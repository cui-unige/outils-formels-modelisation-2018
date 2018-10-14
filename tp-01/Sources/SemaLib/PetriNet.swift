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
    var reslutIntermediaire = false
    for p in places { // on itère sur les p
    var x = pre(p, transition)  // pour chaque p on trouve la matrice d'entrée
    switch x { // on pose la condition de tirable ou pas
    case let m where m < marking(p):  // la valeur des jeton dans la matrice d'entrée est <- que le marquage alors ok
          reslutIntermediaire = true  // c'est la transition est tirable
    case let m where m == marking(p): //idem on si c'est égale c'est tirable
    reslutIntermediaire = true // on retourne le résultat

  default:
    reslutIntermediaire = false //on rappel reslutIntermediaire pour eviter qu'on retourn true sur si le
                              // premier cas est vrai mais pas le deuxième
    break // une des valeur pour pre(p, t) est fausse alors le résultat sera false

    // fin des condition pour switch pour eviter les cas non mentionnés
  }
  }
    return reslutIntermediaire //resultat intermédiaire est initialiser à false, le break guide au résultat final
  }

  /// A method that fires a transition from a given marking.
  ///
  /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
  /// otherwise it returns the new marking.
  public func fire(_ transition: Transition, from marking: @escaping Marking) -> Marking? {
    // Write your code here.
    //ajout de fonction à la struct petrinet*****************************************************
   /// The incidence matrix of the Petri net.





  func initialMarking(_ place: Place) -> Nat {
   switch place {
   case Place("p1"): return 2
   case Place("p2"): return 2
   default: return 0
   }
   }
   func testOptionel(_ optional: Marking?) -> Marking? {
     if let retour = optional, retour != nil {return retour}
     return nil
   }

   let petrinet = PetriNet(
     places      : [Place("p1"), Place("p2")],
     transitions : [Transition("t1"), Transition("t2")],
     pre         : pre,
     post        : post)

     //*******************************************************************************************



   /// Returns a marking as a vector.

    let c  = petrinet.incidenceMatrix
    let s  = petrinet.characteristicVector(of: [transition]) // peut être a changer
    let m0 = petrinet.markingVector(initialMarking)
    //var m1: Marking?  = nil
    let m1 = m0 + c * s
    func finalmarking(_ place: Place) -> Nat {
     switch place {
     case Place("p1"): return Nat(m1[0])
     case Place("p2"): return Nat(m1[1])
     default: return 0
     }
     }
    let m2: Marking? = finalmarking
      return testOptionel(m2)


}


  /// A helper function to print markings.
  public func print(marking: Marking) {
    for place in places.sorted() {
      Swift.print("\(place.name) → \(marking(place))")
    }
  }

  func markingVector(_ marking: Marking) -> [Int] {
   return places.sorted().map { Int(marking($0)) }
  }


  func characteristicVector<S>(of sequence: S) -> [Int] where S: Sequence, S.Element == Transition {
     let index: [Transition: Int] = Dictionary(
     uniqueKeysWithValues: transitions.sorted().enumerated().map({ ($1, $0) })) // transition est un set on trie les transition est on les map pour le dictionnaire
     var result: [Int] = Array(repeating: 0, count: transitions.count) // on crée une array avec les zéros

     for transition in sequence {
       result[index[transition]!] += 1 // on ajoute 1 à la place de la transition la valeur de l'index est un optionnel
     }
     return result
     }




  public var incidenceMatrix: [[Int]] {
       var matrix: [[Int]] = Array(
       repeating: Array(repeating: 0, count: transitions.count),
       count: places.count)

       for (p, place) in places.sorted().enumerated() {
       for (t, transition) in transitions.sorted().enumerated() {
       matrix[p][t] = Int(post(place, transition)) - Int(pre(place, transition))
       }
     }

     return matrix
   }

} //struct fin du PetriNet





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
