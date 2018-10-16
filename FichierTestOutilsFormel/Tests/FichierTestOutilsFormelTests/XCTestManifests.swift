import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FichierTestOutilsFormelTests.allTests),
    ]
}
#endif