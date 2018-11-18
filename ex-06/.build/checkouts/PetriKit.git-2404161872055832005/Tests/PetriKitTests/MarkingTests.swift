import XCTest
@testable import PetriKit

class MarkingTests: XCTestCase {

  func testInit() {
    let mapping: [Place: Int] = [.p: 0, .q: 0, .r: 2]

    let m0 = Marking(uniquePlacesWithValues: mapping.map { ($0.key, $0.value) })
    XCTAssertEqual(m0.count, 3)
    let m1 = Marking(fromMapping: mapping)
    XCTAssertEqual(m1.count, 3)
    let m2: Marking = [Place.p: 0, Place.q: 1, Place.r: 2]
    XCTAssertEqual(m2.count, 3)
  }

  func testSubscript() {
    var m: Marking = [Place.p: 0, Place.q: 1, Place.r: 2]
    XCTAssertEqual(m[.p], 0)
    XCTAssertEqual(m[.q], 1)
    XCTAssertEqual(m[.r], 2)

    m[.p] = 3
    XCTAssertEqual(m[.p], 3)
    XCTAssertEqual(m[.q], 1)
    XCTAssertEqual(m[.r], 2)
  }

  func testIter() {
    let m0: Marking<Empty, Int> = [:]
    XCTAssert(Array(m0).isEmpty)

    let m1: Marking = [Place.p: 0, Place.q: 1, Place.r: 2]
    XCTAssertEqual(Array(m1).map { $0.place }, [.p, .q, .r])
  }

  func testAdd() {
    let m0: Marking = [Place.p: 0, Place.q: 1, Place.r: 2]
    let m1: Marking = [Place.p: 2, Place.q: 1, Place.r: 0]
    let m2 = m0 + m1

    XCTAssertEqual(m2[.p], 2)
    XCTAssertEqual(m2[.q], 2)
    XCTAssertEqual(m2[.r], 2)
  }

  func testSub() {
    let m0: Marking = [Place.p: 0, Place.q: 1, Place.r: 2]
    let m1: Marking = [Place.p: 2, Place.q: 1, Place.r: 0]
    let m2 = m0 - m1

    XCTAssertEqual(m2[.p], -2)
    XCTAssertEqual(m2[.q], 0)
    XCTAssertEqual(m2[.r], 2)
  }

  func testComparable() {
    let m0: Marking = [Place.p: 1, Place.q: 1, Place.r: 1]
    let m1: Marking = [Place.p: 1, Place.q: 1, Place.r: 0]

    XCTAssertEqual   (m0, m0)
    XCTAssertLessThan(m1, m0)
  }

  static var allTests = [
    ("testInit"      , testInit),
    ("testSubscript" , testSubscript),
    ("testIter"      , testIter),
    ("testAdd"       , testAdd),
    ("testSub"       , testSub),
    ("testComparable", testComparable),
  ]

}

private enum Place: CaseIterable {

  case p, q, r

}

private enum Empty: CaseIterable, Hashable {
}

extension Int: Group {

  public static var identity: Int { return 0 }

}
