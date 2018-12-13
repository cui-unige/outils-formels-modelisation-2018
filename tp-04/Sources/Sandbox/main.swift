import PropositionalLogic

// let p: Formula = "p"
// let q: Formula = "q"
// let r: Formula = "r"
// let s: Formula = "s"

// let formula = (p || q || r) && (!p || q)
// print("formula : \(formula)")

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"

let formula = ((a && a) || (a && b) || (a && c) || (b && c) || (a && b && c)).dnf
print("Formula : \(formula)")
// Output :   (((((a ∧ a) ∨ (a ∧ b)) ∨ (a ∧ c)) ∨ (b ∧ c)) ∨ ((a ∧ b) ∧ c))
// Output 2 : ((((a ∨ (a ∧ b)) ∨ (a ∧ c)) ∨ (b ∧ c)) ∨ ((a ∧ b) ∧ c))
// Output 3 : ((((a ∨ (a ∧ b)) ∨ (a ∧ c)) ∨ (b ∧ c)) ∨ ((a ∧ b) ∧ c))
