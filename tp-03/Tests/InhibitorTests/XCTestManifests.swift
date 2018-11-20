import XCTest

extension SemaLibTests {
    static let __allTests = [
        ("testDividerInitialMarking", testDividerInitialMarking),
        ("testDividerStructure", testDividerStructure),
        ("testDivision", testDivision),
        ("testDivisionWithRemainder", testDivisionWithRemainder),
        ("testFire", testFire),
        ("testIsFireable", testIsFireable),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SemaLibTests.__allTests),
    ]
}
#endif
