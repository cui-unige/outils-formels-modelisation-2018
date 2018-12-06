import XCTest

extension EquivalenceTests {
    static let __allTests = [
        ("testEquivalence", testEquivalence),
        ("testIsContradiction", testIsContradiction),
        ("testIsTautology", testIsTautology),
    ]
}

extension NormalFormTests {
    static let __allTests = [
        ("testConjunctiveNormalForm", testConjunctiveNormalForm),
        ("testDisjunctiveNormalForm", testDisjunctiveNormalForm),
        ("testMaxterms", testMaxterms),
        ("testMinterms", testMinterms),
        ("testNegationNormalForm", testNegationNormalForm),
        ("testReducedForms", testReducedForms),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EquivalenceTests.__allTests),
        testCase(NormalFormTests.__allTests),
    ]
}
#endif
