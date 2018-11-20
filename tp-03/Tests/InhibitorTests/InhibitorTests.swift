import XCTest
import class Foundation.Bundle

import Inhibitor

final class SemaLibTests: XCTestCase {

  func testIsFireable() {
    // Create an instance of a test model.
    let model = createTestModel()
    let t1 = model.transitions.first { $0.name == "t1" }!

    // Check transition fireability.
    XCTAssert(t1.isFireable(from: [.p1: 1, .p2: 0]))
    XCTAssert(t1.isFireable(from: [.p1: 10, .p2: 0]))
    XCTAssertFalse(t1.isFireable(from: [.p1: 1, .p2: 1]))
    XCTAssertFalse(t1.isFireable(from: [.p1: 0, .p2: 0]))
  }

  func testFire() {
    // Create an instance of a test model.
    let model = createTestModel()
    let t1 = model.transitions.first { $0.name == "t1" }!

    // Check transition firing.
    if let m = t1.fire(from: [.p1: 1, .p2: 0]) {
      XCTAssertEqual(m[.p1], 1)
      XCTAssertEqual(m[.p2], 1)
    } else {
      XCTFail("Transition 't1' should be fireable from [p1 → 1, p2 → 0].")
    }

    // Firing the transition `t1` from the marking [p1 → 0, p2 → 0] fails.
    if t1.fire(from: [.p1: 1, .p2: 1]) != nil {
      XCTFail("Transition 't1' shouldn't be fireable from [p1 → 1, p2 → 1].")
    }
  }

  func testDividerStructure() {
    // Create an instance of your divider model.
    let divider = createDividerModel()

    // Test whether your divider model contains the places `opa`, `opb` and `res`.
    XCTAssert(divider.places.contains(.opa))
    XCTAssert(divider.places.contains(.opb))
    XCTAssert(divider.places.contains(.res))
  }

  func testDividerInitialMarking() {
    // Create the initial marking of your divider model.
    let initialMarking = createDividerInitialMarking(opa: 6, opb: 2)

    // Test whether your initial marking encodes the correct value (i.e. zero).
    XCTAssertEqual(initialMarking[.opa], 6)
    XCTAssertEqual(initialMarking[.opb], 2)
    XCTAssertEqual(initialMarking[.res], 0)
  }

  func testDivision() {
    // Create an instance of your divider model, with an initial marking.
    let divider = createDividerModel()
    let initialMarking = createDividerInitialMarking(opa: 6, opb: 2)

    // There should be only a single sink state, representing the result of the division.
    let states = divider.computeMarkingGraph(from: initialMarking)
    let sinks = states.filter { $0.successors.isEmpty }
    XCTAssertEqual(sinks.count, 1)
    if let sink = sinks.first {
      XCTAssertEqual(sink.marking[.res], 3)
    }
  }

  func testDivisionWithRemainder() {
    // Create an instance of your divider model, with an initial marking.
    let divider = createDividerModel()
    let initialMarking = createDividerInitialMarking(opa: 9, opb: 2)

    // There should be only a single sink state, representing the result of the division.
    let states = divider.computeMarkingGraph(from: initialMarking)
    let sinks = states.filter { $0.successors.isEmpty }
    XCTAssertEqual(sinks.count, 1)
    if let sink = sinks.first {
      XCTAssertEqual(sink.marking[.res], 4)
    }
  }

}
