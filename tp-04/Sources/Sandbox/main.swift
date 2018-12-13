import PropositionalLogic

let p: Formula = "p"
let q: Formula = "q"
let r: Formula = "r"
let s: Formula = "s"

let formula = (p || q || r) && (!p || q)
print("formula : \(formula)")


Swift.print("\n Test pour les differentes fonctions: \n ")
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"

Swift.print("Test pour la fonction nnf de negation:  ")
print((!(a || b)).nnf)

Swift.print("\n Test pour la fonction dnf:  ")
print((!(a => b => c)).dnf)

Swift.print("\n Test pour la fonction cnf: ")
print((!(a => b => c)).cnf)

Swift.print("\n Test pour la fonction minterms: ")
print((a || (a && b) || (a && c)).minterms)

Swift.print("\n Test pour la fonction maxterms: ")
print((a && (a || b) && (a || c)).maxterms)


Swift.print("\n TEST POUR NEGATION NORMAL FORM\n")

Swift.print("\(Formula.constant(true).nnf)" )
Swift.print("\(a.nnf)" )
Swift.print("\((!Formula.constant(true)).nnf)" )
Swift.print("\((!a).nnf)" )
Swift.print("\((!(!a)).nnf)" )
Swift.print("\((!(a || b)).nnf)" )
Swift.print("\((!(a && b)).nnf)" )
Swift.print("\((!(a => b)).nnf)" )
Swift.print("\((a || b).nnf)" )
Swift.print("\((a && b).nnf)" )
Swift.print("\((a => b).nnf)" )
