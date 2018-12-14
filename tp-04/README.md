# Homework \#4

In this homework, you implement the transformations of propositional logic formulae.

The submission deadline is set on December the 14th, at 23:59 Geneva local time.

**Important note about submissions**

As written in the course's README,
submissions must be made by pull request, **on the branch named after your GitHub username**.
If such branch does not exists,
email the course's assistant ([Dimitri Racordon](mailto:dimitri.racordon@unige.ch))
with your last name, first name and GitHub username **immediately**.

As a reminder, the submission process is described below:
1. Test your code!
2. Make sure to commit all your files on your GitHub repository.
   You will be evaluated on the last commit you've made before the deadline of the homework!
3. On GitHub, click on the New pull request button.
   This will lead you to a page where you can review your changes.
4. Be sure to select `cui-unige/outils-formels-modelisation-2018`
   and the `<your-github-username>` as the branch.
   Your homework will not be considered submitted if you submit a pull request to another base!
5. If everything looks good, click on the Create pull request button.

## Preliminaries

Formulae are represented in the form of
[Abstract Syntax Trees (ASTs)](https://en.wikipedia.org/wiki/Abstract_syntax_tree).
As their name suggest, ASTs are a tree representation of an expression
(e.g. a formula of propositional logic).
For instance, the formula `a or b and c` can be represented by a tree `(or a (and b c)))`.

In the sources of the homework,
ASTs are encoded in the form of an
[enumeration](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html)
(a.k.a. [union type](https://en.wikipedia.org/wiki/Union_type))
As the documentation says:

> An enumeration defines a common type for a group of related values
> and enables you to work with those values in a type-safe way within your code.

For instance, the following is an enumeration
that represents the syntactic elements of first degree polynomials:

```swift
indirect enum Polynomial {

   case constant(Int)
   case indeterminate(coefficient: Int, variable: String)
   case add(Polynomial, Polynomial)
   case sub(Polynomial, Polynomial)

}
```

The above enumeration has four *cases*, respectively representing
* a constant value,
* an indeterminate (i.e. a variable and a coefficient),
* the addition of two polynomials, and
* the subtraction of two polynomials.

Notice also how values can be associated with the cases of an enumeration.
Those are called *associated values*,
as they allow the association of one or several values to a particular case.

Using our type, the AST of the polynomial `5x + 2x - 3` can be represented as follows:

```swift
let poly: Polynomial = .add(
   .indeterminate(coefficient: 5, variable: "x"),
   .sub(
      .indeterminate(coefficient: 2, variable: "x"),
      .constant(3)))
```

We use pattern matching to extract associated values.
For instance, one could define a nice string representation of a polynomial as follows:

```swift
extension Polynomial: CustomStringConvertible {
   var description: String {
      switch self {
      case .constant(let value):
         return "\(value)"
      case .indeterminate(let coefficient, let variable):
         return "\(coefficient)\(variable)"
      case .add(let lhs, let rhs):
         return "(\(lhs) + \(rhs))"
      case .sub(let lhs, let rhs):
         return "(\(lhs) - \(rhs))"
      }
   }
}

print(poly)
// Prints "(5x + (2x - 3))"
```

## Negation Normal Form

In the file `Sources/PropositionalLogic/Formula+Equivalence.swift`,
write the implementation of the property `nnf`.
It must return the Negation Normal Form of any formula.
Here is a usage example:

```swift
let a: Formula = "a"
let b: Formula = "b"
let f = !(a || b)
print(f.nnf)
// Prints "(¬a ∧ ¬b)"
```

## Disjunction Normal Norm

In the file `Sources/PropositionalLogic/Formula+Equivalence.swift`,
write the implementation of the property `dnf`.
It must return the Disjunction Normal Form of any formula.
Here is a usage example:

```swift
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
print((!(a => b => c)).dnf)
// Prints "((b ∧ ¬c) ∨ (¬a ∧ ¬c))"
```

You may use the helper `conjunctionOperands` to implement this property.

## Conjunction Normal Form

In the file `Sources/PropositionalLogic/Formula+Equivalence.swift`,
write the implementation of the property `cnf`.
It must return the Conjunction Normal Form of any formula.
Here is a usage example:

```swift
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
print((!(a => b => c)).cnf)
// Prints "(¬c ∧ (¬a ∨ b))"
```

You may use the helper `disjunctionOperands` to implement this property.

## Minterms

In the file `Sources/PropositionalLogic/Formula+Equivalence.swift`,
write the implementation of the property `minterms`.
It must return the minterms of any DNF formula.
Here is a usage example:

```swift
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
print((a || (a && b) || (a && c)).minterms)
// Prints ""[Set([a]), Set([a, b]), Set([c, a])]""
```

## Maxterms

In the file `Sources/PropositionalLogic/Formula+Equivalence.swift`,
write the implementation of the property `maxterms`.
It must return the maxterms of any CNF formula.
Here is a usage example:

```swift
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
print((a && (a || b) && (a || c)).maxterms)
// Prints ""[Set([a]), Set([a, b]), Set([c, a])]""
```

## Package organization

This homework is organized as a standard Swift package.
Sources are available in the folder `Sources/<Target>`,
where `<Target>` is the name of a particular target.

For the sake of this homework,
you will only need to work on the sources inside
`Sources/PropositionalLogic/Formula+Equivalence.swift`,
but are encouraged to take a look at other the sources.
In particular, `Sources/Sandbox/main.swift` shows various usage example of the library.
You can run the code of this file with the command `swift run`.
Don't hesitate to play with it.
Its content won't be part of the final evaluation **as long as it compiles**.
Remember that a submission that doesn't compile cannot pass any test.

Tests are located in the folder `Tests/PropositionalLogicTests`.
Don't hesitate to take a look, especially if your code fails to pass them.
However, remember that you **must not** modify those tests.
You can run the tests with the command `swift test`.
