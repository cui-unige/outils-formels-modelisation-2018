import XCTest

class Expectation {

  init(description: String) {
    self.description = description
    self.isFulfilled = false
  }

  var description: String
  private(set) var isFulfilled: Bool

  func fulfill() {
    self.isFulfilled = true
  }

}

extension XCTestCase {

  func wait(for expectations: [Expectation], timeout: TimeInterval) {
    Thread.sleep(forTimeInterval: 1.0)
    for expectation in expectations {
      guard expectation.isFulfilled else {
        XCTFail("Unfulfilled expectation: \(expectation.description)")
        continue
      }
    }
  }

  #if os(macOS)
  func createExpectation(description: String) -> XCTestExpectation {
    return expectation(description: description)
  }
  #else
  func createExpectation(description: String) -> Expectation {
    return Expectation(description: description)
  }
  #endif

}
