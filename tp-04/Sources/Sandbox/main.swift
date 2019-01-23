import PropositionalLogic

let p: Formula = "p"
let q: Formula = "q"
let r: Formula = "r"
let s: Formula = "s"
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"

let formula = (p || q || r) && (!p || q)
let test = !(true || q )
let test2 = (p && q )


let formula2 = (p || (q || r)) && (p || q)
print("formula2 : \(formula2)")
print("formula2 minterms : \(formula2.minterms)")

print("formula : \(formula)")
print("formula negation : \(test.nnf)" )

let  testminterms = (a || (a && b) || (a && c))
print("testMINTERMS : \(testminterms)")
print("formula: \(testminterms.minterms)" )


let f = !Formula.constant(true)
print("formula : \(f)")
print("f negation : \(f.nnf)" )

let testDNF = ((a && a) || (a && b) || (a && c) || (b && c) || (a && b && c))
print("testDNF : \(testDNF)")
print("testDNF : \(testDNF.dnf)" )


let testCNF = [a,b,a]
print("testCNF : \(testCNF)")
//print("testCNF : \(testCNF.cnf)" )

print(testCNF.reduce(with: ||))
