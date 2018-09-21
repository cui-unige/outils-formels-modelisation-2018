import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ex_00Tests.allTests),
    ]
}
#endif