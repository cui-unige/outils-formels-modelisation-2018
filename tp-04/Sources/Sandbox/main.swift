import PropositionalLogic

let p: Formula = "p"
let q: Formula = "q"
let r: Formula = "r"
let s: Formula = "s"

let formula = (p || q || r) && (!p || q)
print("formula : \(formula)")
