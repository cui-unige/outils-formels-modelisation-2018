import XCTest
import PropositionalLogic

class EquivalenceTests: XCTestCase {

  func testEquivalence() {
    let a: Formula = "a"
    let b: Formula = "b"
    let c: Formula = "c"

    // Identity
    XCTAssert(a.isSemanticallyEquivalent(to: a))
    XCTAssert((a || false).isSemanticallyEquivalent(to: a))
    XCTAssert((a && true).isSemanticallyEquivalent(to: a))

    // Domination
    XCTAssert((a || true).isSemanticallyEquivalent(to: true))
    XCTAssert((a && false).isSemanticallyEquivalent(to: false))

    // Idempotence
    XCTAssert((a || a).isSemanticallyEquivalent(to: a))
    XCTAssert((a && a).isSemanticallyEquivalent(to: a))

    // Negation
    XCTAssert((a || !a).isSemanticallyEquivalent(to: true))
    XCTAssert((a && !a).isSemanticallyEquivalent(to: false))

    // Double negation
    XCTAssert(a.isSemanticallyEquivalent(to: !(!a)))

    // Commutativity
    XCTAssert((a || b).isSemanticallyEquivalent(to: b || a))
    XCTAssert((a && b).isSemanticallyEquivalent(to: b && a))

    // Associativity
    XCTAssert(((a || b) || c).isSemanticallyEquivalent(to: a || (b || c)))
    XCTAssert(((a && b) && c).isSemanticallyEquivalent(to: a && (b && c)))

    // Distributivity
    XCTAssert((a || (b && c)).isSemanticallyEquivalent(to: (a || b) && (a || c)))
    XCTAssert((a && (b || c)).isSemanticallyEquivalent(to: (a && b) || (a && c)))

    // De Morgan's laws
    XCTAssert(!(a || b).isSemanticallyEquivalent(to: !a && !b))
    XCTAssert(!(a && b).isSemanticallyEquivalent(to: !a || !b))

    // Absorption
    XCTAssert((a || (a && b)).isSemanticallyEquivalent(to: a))
    XCTAssert((a && (a || b)).isSemanticallyEquivalent(to: a))

    // Implication
    XCTAssert((a => b).isSemanticallyEquivalent(to: !a || b))

    // Inequivalence
    XCTAssertFalse(a.isSemanticallyEquivalent(to: b))
    XCTAssertFalse((a || b).isSemanticallyEquivalent(to: a && b))
  }

  func testIsTautology() {
    let a: Formula = "a"
    let b: Formula = "b"

    XCTAssert(Formula.constant(true).isTautology)
    XCTAssert((a || !a).isTautology)

    XCTAssertFalse(Formula.constant(false).isTautology)
    XCTAssertFalse((a && b).isTautology)
  }

  func testIsContradiction() {
    let a: Formula = "a"
    let b: Formula = "b"

    XCTAssert(Formula.constant(false).isContradiction)
    XCTAssert((a && !a).isContradiction)

    XCTAssertFalse(Formula.constant(true).isContradiction)
    XCTAssertFalse((a || b).isContradiction)
  }

}
