import XCTest
import PropositionalLogic

class NormalFormTests: XCTestCase {

  func testNegationNormalForm() {
    let a: Formula = "a"
    let b: Formula = "b"

    XCTAssert(Formula.constant(true)    .nnf.isSemanticallyEquivalent(to: true))
    XCTAssert(a                         .nnf.isSemanticallyEquivalent(to: a))
    XCTAssert((!Formula.constant(true)) .nnf.isSemanticallyEquivalent(to: false))
    XCTAssert((!a)                      .nnf.isSemanticallyEquivalent(to: !a))
    XCTAssert((!(!a))                   .nnf.isSemanticallyEquivalent(to: a))
    XCTAssert((!(a || b))               .nnf.isSemanticallyEquivalent(to: !a && !b))
    XCTAssert((!(a && b))               .nnf.isSemanticallyEquivalent(to: !a || !b))
    XCTAssert((!(a => b))               .nnf.isSemanticallyEquivalent(to: a && !b))
    XCTAssert((a || b)                  .nnf.isSemanticallyEquivalent(to: a || b))
    XCTAssert((a && b)                  .nnf.isSemanticallyEquivalent(to: a && b))
    XCTAssert((a => b)                  .nnf.isSemanticallyEquivalent(to: !a || b))
  }

  func testDisjunctiveNormalForm() {
    let a: Formula = "a"
    let b: Formula = "b"
    let c: Formula = "c"

    XCTAssert(Formula.constant(true)    .dnf.isSemanticallyEquivalent(to: true))
    XCTAssert(a                         .dnf.isSemanticallyEquivalent(to: a))
    XCTAssert((!Formula.constant(true)) .dnf.isSemanticallyEquivalent(to: false))
    XCTAssert((!a)                      .dnf.isSemanticallyEquivalent(to: !a))
    XCTAssert((!(!a))                   .dnf.isSemanticallyEquivalent(to: a))

    let f1 = ((a || b) && (a || c)).dnf
    switch f1 {
    case .disjunction: break
    default: XCTFail("Invalid DNF '\(f1)'")
    }
    XCTAssert(f1.isSemanticallyEquivalent(to: a || ((c && b))))

    let f2 = ((a && b) || (a && c)).dnf
    switch f2 {
    case .disjunction: break
    default: XCTFail("Invalid DNF '\(f2)'")
    }
    XCTAssert(f2.isSemanticallyEquivalent(to: (a && b) || (a && c)))

    let f3 = (((a => b) => (a => c)) && ((a => c) => (a => b))).dnf
    switch f3 {
    case .disjunction: break
    default: XCTFail("Invalid DNF '\(f3)'")
    }
    XCTAssert(f3.isSemanticallyEquivalent(to: !a || (b && c) || (a && !b && !c)))
  }

  func testConjunctiveNormalForm() {
    let a: Formula = "a"
    let b: Formula = "b"
    let c: Formula = "c"

    XCTAssert(Formula.constant(true)    .cnf.isSemanticallyEquivalent(to: true))
    XCTAssert(a                         .cnf.isSemanticallyEquivalent(to: a))
    XCTAssert((!Formula.constant(true)) .cnf.isSemanticallyEquivalent(to: false))
    XCTAssert((!a)                      .cnf.isSemanticallyEquivalent(to: !a))
    XCTAssert((!(!a))                   .cnf.isSemanticallyEquivalent(to: a))

    let f1 = ((a || b) && (a || c)).cnf
    switch f1 {
    case .conjunction: break
    default: XCTFail("Invalid CNF '\(f1)'")
    }
    XCTAssert(f1.isSemanticallyEquivalent(to: (a || c) && (a || b)))

    let f2 = ((a && b) || (a && c)).cnf
    switch f2 {
    case .conjunction: break
    default: XCTFail("Invalid CNF '\(f2)'")
    }
    XCTAssert(f2.isSemanticallyEquivalent(to: a && (b || c)))

    let f3 = (((a => b) => (a => c)) && ((a => c) => (a => b))).cnf
    switch f3 {
    case .conjunction: break
    default: XCTFail("Invalid CNF '\(f3)'")
    }
    XCTAssert(f3.isSemanticallyEquivalent(to: (!a || !b || c) && (!a || !c || b)))
  }

  func testMinterms() {
    let a: Formula = "a"
    let b: Formula = "b"
    let c: Formula = "c"

    let f1 = (a && a) || (a && b) || (a && c) || (b && c) || (a && b && c)
    XCTAssertEqual(f1.minterms, [[a], [a, b], [a, c], [b, c], [a, b, c]])
  }

  func testMaxterms() {
    let a: Formula = "a"
    let b: Formula = "b"
    let c: Formula = "c"

    let f1 = (a || a) && (a || b) && (a || c) && (b || c) && (a || b || c)
    XCTAssertEqual(f1.maxterms, [[a], [a, b], [a, c], [b, c], [a, b, c]])
  }

  func testReducedForms() {
    let a: Formula = "a"
    let b: Formula = "b"
    let c: Formula = "c"

    let f1 = ((a && a) || (a && b) || (a && c) || (b && c) || (a && b && c)).dnf
    if case .disjunction(let x, let y) = f1 {
      XCTAssert(
        x.isSemanticallyEquivalent(to: a) && y.isSemanticallyEquivalent(to: b && c) ||
        y.isSemanticallyEquivalent(to: a) && x.isSemanticallyEquivalent(to: b && c))
    } else {
      XCTFail("Invalid DNF '\(f1)'")
    }

    let f2 = ((a || a) && (a || b) && (a || c) && (b || c) && (a || b || c)).cnf
    if case .conjunction(let x, let y) = f2 {
      XCTAssert(
        x.isSemanticallyEquivalent(to: a) && y.isSemanticallyEquivalent(to: b || c) ||
        y.isSemanticallyEquivalent(to: a) && x.isSemanticallyEquivalent(to: b || c))
    } else {
      XCTFail("Invalid CNF '\(f2)'")
    }
  }

}
