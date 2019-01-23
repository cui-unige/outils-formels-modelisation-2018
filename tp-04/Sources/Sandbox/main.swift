import PropositionalLogic

let p: Formula = "p"
let q: Formula = "q"
let r: Formula = "r"
let s: Formula = "s"

let formula = (p || q || r) && (!p || q)
print("formula : \(formula)")
print(formula.nnf)

let a: Formula = "a"
let b: Formula = "b"
let f = !((a || b) && !(a && b))
print(f.nnf)
