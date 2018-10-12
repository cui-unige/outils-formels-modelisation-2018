import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(outils_formels_modelisation_2018Tests.allTests),
    ]
}
#endif