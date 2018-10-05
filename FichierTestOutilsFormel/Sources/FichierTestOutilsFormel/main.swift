struct Point: Equatable  Comparable {// ajout de protocole

init(x: Int, y: Int){
self.x = x
self.y = y
}

let x: Int
let y: Int


func norm() -> Double {

  return Double((self.x * self.x) + (self.y * self.y)).squareRoot()

}

}

func f(pta: Point, ptb: Point)

let a = Point(x: 1 , y: 2)
let b = a //swift ne réussit pas à comparer

print(a == b)
