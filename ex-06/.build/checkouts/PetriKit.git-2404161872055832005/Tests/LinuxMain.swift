import XCTest
@testable import PetriKitTests

XCTMain([
  testCase(MarkingTests.allTests),
  testCase(PTNetTests.allTests),
  testCase(RandomTests.allTests),
])
