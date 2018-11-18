import XCTest
@testable import PetriKit

class PTNetTests: XCTestCase {

  func testIsFireable() {
    let pn = self.createPTNet()
    let t0 = pn.transitions.first{ $0.name == "t0" }!
    let t1 = pn.transitions.first{ $0.name == "t1" }!

    XCTAssertTrue (t0.isFireable(from: [.p0: 1, .p1: 0]))
    XCTAssertTrue (t0.isFireable(from: [.p0: 2, .p1: 0]))

    XCTAssertFalse(t1.isFireable(from: [.p0: 1, .p1: 0]))
    XCTAssertFalse(t1.isFireable(from: [.p0: 2, .p1: 0]))
  }

  func testFire() {
    let pn = self.createPTNet()
    let t0 = pn.transitions.first{ $0.name == "t0" }!
    let t1 = pn.transitions.first{ $0.name == "t1" }!

    XCTAssert(t0.fire(from: [.p0: 1, .p1: 0])! == [.p0: 0, .p1: 1])
    XCTAssert(t1.fire(from: [.p0: 1, .p1: 0])  == nil)

    XCTAssert(t0.fire(from: [.p0: 0, .p1: 1])  == nil)
    XCTAssert(t1.fire(from: [.p0: 0, .p1: 1])! == [.p0: 1, .p1: 0])

    XCTAssert(t0.fire(from: [.p0: 1, .p1: 1])! == [.p0: 0, .p1: 2])
    XCTAssert(t1.fire(from: [.p0: 1, .p1: 1])! == [.p0: 2, .p1: 0])
  }

  func testSimulate() {
    let pn = self.createPTNet()

    XCTAssert(pn.simulate(steps: 0, from: [.p0: 1, .p1: 0]) == [.p0: 1, .p1: 0])
    XCTAssert(pn.simulate(steps: 1, from: [.p0: 1, .p1: 0]) == [.p0: 0, .p1: 1])
    XCTAssert(pn.simulate(steps: 2, from: [.p0: 1, .p1: 0]) == [.p0: 1, .p1: 0])
    XCTAssert(pn.simulate(steps: 3, from: [.p0: 1, .p1: 0]) == [.p0: 0, .p1: 1])
    XCTAssert(pn.simulate(steps: 4, from: [.p0: 1, .p1: 0]) == [.p0: 1, .p1: 0])

    XCTAssert([[.p0: 2, .p1: 0], [.p0: 0, .p1: 2]].contains{
      $0 == pn.simulate(steps: 1, from: [.p0: 1, .p1: 1])
    })
  }

  private func createPTNet() -> PTNet<Place> {
    let t0 = PTTransition(
      named         : "t0",
      preconditions : [PTArc(place: Place.p0)],
      postconditions: [PTArc(place: Place.p1)])
    let t1 = PTTransition(
      named         : "t1",
      preconditions : [PTArc(place: Place.p1)],
      postconditions: [PTArc(place: Place.p0)])

    return PTNet(transitions: [t0, t1])
  }

  static var allTests = [
    ("testIsFireable", testIsFireable),
    ("testFire"      , testFire),
    ("testSimulate"  , testSimulate),
  ]

}

private enum Place: CaseIterable {

  case p0, p1

}
