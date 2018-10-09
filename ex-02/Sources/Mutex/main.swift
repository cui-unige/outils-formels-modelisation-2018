/*private func pre(p: Place, t: Transition) -> Nat { //encode les arcs des transition
  switch (p, t) {
  case (Place("p1"), Transition("t1")): return 2 //Réseaux p.11 Formalisme
  case (Place("p1"), Transition("t2")): return 1
  case (Place("p1"), Transition("t3")): return 0
  case (Place("p2"), Transition("t1")): return 0
  case (Place("p2"), Transition("t2")): return 6
  case (Place("p2"), Transition("t3")): return 4
  default: return 0
  }
}

private func post(p: Place, t: Transition) -> Nat {
  switch (p, t) {
  case (Place("p1"), Transition("t1")): return 5
  case (Place("p1"), Transition("t2")): return 0
  case (Place("p1"), Transition("t3")): return 1
  case (Place("p2"), Transition("t1")): return 7
  case (Place("p2"), Transition("t2")): return 3
  case (Place("p2"), Transition("t3")): return 0
  default: return 0
  }
}

func initialMarking(_ place: Place) -> Nat {//Marquage intiale => Fonction vers places  -> naturels.
  switch place {
  case Place("p1"): return 2
  case Place("p2"): return 3
  default: return 0
  }
}

let model = PetriNet(
  places     : [Place("p1"), Place("p2")],
  transitions: [Transition("t1"), Transition("t2"), Transition("t3")],
  pre        : pre,
post       : post)//Fonctions.
*/



//print(initialMarking(Place("p2"))) //Valeur de la marque pour la valeur initiale.

/*
let c  = model.incidenceMatrix
//print(c) //=> [[3, -1, 1], [7, -3, -4]]
let s = model.characteristicVector(of: [Transition("1"), [Transition("")]]) //[[2, 3], [7, 14]]
let m0 = model.markingVector(initialMarking)
let m1 = m0 + c * s

print(m0, m1)*/








/////=============CORRECTION=========/////////////////
/////refaire.
private func pre(p: Place, t: Transition) -> Nat { //encode les arcs des transition
  switch t {
  case Transition("t0"):
    switch p {
    case Place("s0"), Place("s4"), Place("c")
      return 1
    default:
      return 0
    }/*
  case Transition("t2"):
    switch p {
    case Place("s2"), Place("s4"), Place("c")
      return 1
    default:
      return 0
    }
  case Transition("t0"):
    switch p {
    case Place("s0"), Place("s4"), Place("c")
      return 1
    default:
      return 0
    }
  case Transition("t0"):
      switch p {
      case Place("s0"), Place("s4"), Place("c")
        return 1
      default:
        return 0
      }*/
  }

  /*
  switch (p, t) {
  case (Place("s0"), Transition("t0")): return 1 //Exercice avec nouveau réseau de Petri
  case (Place("s1"), Transition("t1")): return 1
  case (Place("s2"), Transition("t2")): return 1
  case (Place("s3"), Transition("t3")): return 1
  case (Place("s4"), Transition("t0"), Transition("t2")): return 1
  case (Place("c"), Transition("t0")): return 1
  case (Place("b"), Transition("t2")): return 1
  default: return 0
  }*/
  private func post(p: Place, t: Transition) -> Nat {
    switch t {
      case Transition("t0"):
        switch p {
          case Place("s1"), Place("b")
            return 1
          default:
            return 0
        }
      case Transition("t1"):
        switch p {
          case Place("s0"), Place("s4")
            return 1
          default:
            return 0
        }
      case Transition("t2"):
        switch p {
          case Place("s3"), Place("c")
            return 1
          default:
            return 0
        }
      }
  }

  func initialMarking(_ place: Place) -> Nat {//Marquage intiale => Fonction vers places  -> naturels.
    switch place {
    case Place("s0"): return 1
    case Place("s2"): return 1
    case Place("s4"): return 1
    case Place("c"): return 3
    default: return 0
    }
  }

  let model = PetriNet(
    places     : [Place("s0"), Place("s1"), Place("s2"), Place("s3"), Place("s4"), Place("b"), Place("c")],
    transitions: [Transition("t0"), Transition("t1"), Transition("t2"), Transition("t3")],
    pre        : pre,
    post       : post)//Fonctions.
//  func incidenceMatrix....

  let c  = model.incidenceMatrix
  let s = model.characteristicVector(of: [Transition("t0"), [Transition("t1")], Transition["t3"]])
  let m0 = model.markingVector(initialMarking)
  let m1 = m0 + c * s
//////////////////////======CORRECTION================/////////////////////
//[0, 3, 1, 0, 1, 0, 1] [1, 2, 0, 1, 1, 0, 0] //ordre pas forcément les

//
func next(_ marking: (Place) -> Nat) -> (Place) -> Nat) -> Nat {
  return {//closure
    return marking(s0) + 1
  } //Retourne une nouvelle fonction, retourne une nouvelle closure de marquage.
}
let mk = next(initialMarking)
print(initialMarking(Place("b")), mk(Place("b")))
