import PropositionalLogic

let p: Formula = "p"
let q: Formula = "q"
let r: Formula = "r"
let s: Formula = "s"

let formula = (p || q || r) && (!p || q)
//let tauto = !(p&&(!p))
//let formula1 = !(p&&(!q)&&r)
//let formula2 = !(!(q))
//let formula3 = formula1.isSemanticallyEquivalent(to:formula2)
//let formula4 = !(p=>q=>r)
//let formula5 = (p || q || r) && (!p || q) && !(p=>q=>r) || !(s=>p) || (s||r) && (r)
//let value = formula4.eval(with: ["p": true, "q": false,"r":true] )
//let formula3 = formula1.isSemanticallyEquivalent(to:formula2)
print("formula : \(formula)")
