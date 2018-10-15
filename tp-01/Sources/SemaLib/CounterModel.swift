/* Création des places
*/
let p0 = Place("p0")
let p1 = Place("p1")
let b0 = Place("b0")
let b1 = Place("b1")
let b2 = Place("b2")
/* Création des transitions
*/
let t0 = Transition("t0")
let t1 = Transition("t1")
let t2 = Transition("t2")
let t3 = Transition("t3")
let t4 = Transition("t4")

/* Fonction:
* Définition des préconditions d'un réseau de Pétri
*/
func pre(p: Place, t: Transition) -> Nat {
  switch (p, t) {

// 1 : 001
  case (p0, t0): return 1

// 2 : 010
  case (b0, t1): return 1

// 3 : 011
  case (p0, t0): return 1

// 4 : 100
  case (b0, t2): return 1
  case (b1, t2): return 1

// 5 : 101
  case (p1, t3): return 1

// 6 : 110
  case (b0, t1): return 1

// 7 : 111
  case (p0, t0): return 1

// Réinitialisation : 000
  case (b0, t4): return 1
  case (b1, t4): return 1
  case (b2, t4): return 1

  default: return 0
  }
}
/* Fonction:
* Définition des postconditions d'un réseau de Pétri
*/
func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {

// 1 : 001
  case (b0, t0): return 1

// 2 : 010
  case (b1, t1): return 1
  case (p0, t1): return 1

// 3 : 011
  case (b0, t0): return 1

// 4 : 100
  case (b2, t2): return 1

// 5 : 101
  case (b0, t3): return 1

// 6 : 110
  case (b1, t1): return 1
  case (p0, t1): return 1

// 7 : 111
  case (b0, t0): return 1

// Réinitialisation : 000
  case (p0, t4): return 1
  case (p1, t4): return 1

  default: return 0
  }
}

/* Fonction:
* Définition du marking initial d'un réseau de Pétri
*/
private func initialMarking(_ place: Place) -> Nat {
  switch place {
  case p0: return 1
  case p1: return 1
  default: return 0
  }
}

/* Fonction:
* Créer un odèée de conteur binaire à 3 bits
*/
public func createCounterModel() -> PetriNet {
  // Write your code here.

  return PetriNet(places: [p0, p1, b0, b1, b2], transitions: [t0, t1, t2, t3, t4], pre: pre, post: post)
}

/* Fonction:
* Retourne le marking du modèle de compteur binaire
*/
public func createCounterInitialMarking() -> Marking {
  // Write your code here.

  return initialMarking
}
