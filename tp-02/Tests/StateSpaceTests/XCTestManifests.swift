import XCTest

extension StateSpaceTests {
    static let __allTests = [
        ("testBoundedCoverabilityCount", testBoundedCoverabilityCount),
        ("testBoundedMarkingCount", testBoundedMarkingCount),
        ("testBoundedMarkingReachability", testBoundedMarkingReachability),
        ("testUnboundedCoverabilityCount", testUnboundedCoverabilityCount),
        ("testUnboundedCoverabilityReachability", testUnboundedCoverabilityReachability),
        ("testUnboundedMarkingFailure", testUnboundedMarkingFailure),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StateSpaceTests.__allTests),
    ]
}
#endif
