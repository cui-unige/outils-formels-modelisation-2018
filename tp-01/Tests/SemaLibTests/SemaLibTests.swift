import XCTest
import class Foundation.Bundle

import SemaLib

final class SemaLibTests: XCTestCase {

  func testIsFireable() {
    // Create an instance of a test model.
    let model = createTestModel()

    // The transition `t1` is fireable from the marking [p1 → 3, p2 → 3].
    XCTAssert(model.isFireable(Transition("t1"), from: { _ in 3 }))
    // The transition `t1` is *not* fireable from the marking [p1 → 0, p2 → 0].
    XCTAssertFalse(model.isFireable(Transition("t1"), from: { _ in 0 }))

    // The transition `t2` is fireable from the marking [p1 → 6, p2 → 6].
    XCTAssert(model.isFireable(Transition("t2"), from: { _ in 6 }))
    // The transition `t2` is *not* fireable from the marking [p1 → 3, p2 → 3].
    XCTAssertFalse(model.isFireable(Transition("t2"), from: { _ in 3 }))
  }

  func testFire() {
    // Create an instance of a test model.
    let model = createTestModel()

    // Firing the transition `t1` from the marking [p1 → 3, p2 → 3] produces [p1 → 6, p2 → 10].
    if let m = model.fire(Transition("t1"), from: { _ in 3 }) {
      XCTAssertEqual(m(Place("p1")), 6)
      XCTAssertEqual(m(Place("p2")), 10)
    } else {
      XCTFail("Transition 't1' should be fireable from [p1 → 3, p2 → 3].")
    }

    // Firing the transition `t1` from the marking [p1 → 0, p2 → 0] fails.
    if model.fire(Transition("t1"), from: { _ in 0 }) != nil {
      XCTFail("Transition 't1' shouldn't be fireable from [p1 → 0, p2 → 0].")
    }

    // Firing the transition `t2` from the marking [p1 → 6, p2, 6] produces [p1 → 5, p2 → 3].
    if let m = model.fire(Transition("t2"), from: { _ in 6 }) {
      XCTAssertEqual(m(Place("p1")), 5)
      XCTAssertEqual(m(Place("p2")), 3)
    } else {
      XCTFail("Transition 't2' should be fireable from [p1 → 6, p2 → 6].")
    }
  }

  func testCounterStructure() {
    // Create an instance of your counter model.
    let counter = createCounterModel()

    // Test whether your counter model contains the places `b0`, `b1` and `b2`.
    XCTAssert(counter.places.contains(Place("b0")))
    XCTAssert(counter.places.contains(Place("b1")))
    XCTAssert(counter.places.contains(Place("b2")))
  }

  func testCounterInitialMarking() {
    // Create the initial marking of your counter model.
    let initialMarking = createCounterInitialMarking()

    // Test whether your initial marking encodes the correct value (i.e. zero).
    XCTAssertEqual(initialMarking(Place("b2")), 0)
    XCTAssertEqual(initialMarking(Place("b1")), 0)
    XCTAssertEqual(initialMarking(Place("b0")), 0)
  }

  func testCounterReachability() {
    // Create an instance of your counter model, with its initial marking.
    let counter = createCounterModel()
    let initialMarking = createCounterInitialMarking()

    // Compute the state space of your model.
    guard let state = computeGraph(of: counter, from: initialMarking) else {
      XCTFail("Your counter model is unbounded model.")
      return
    }

    // Check whether all states of the counter can be reached.
    for b0 in [0, 1] {
      for b1 in [0, 1] {
        for b2 in [0, 1] {
          XCTAssert(state.contains(where: { node in
            node.marking(Place("b0")) == b0 &&
            node.marking(Place("b1")) == b1 &&
            node.marking(Place("b2")) == b2
          }), "Your counter cannot reach '\(b2)\(b1)\(b0)'")
        }
      }
    }
  }

  func testCounterExtraStates() {
    // Create an instance of your counter model, with its initial marking.
    let counter = createCounterModel()
    let initialMarking = createCounterInitialMarking()

    // Compute the state space of your model.
    guard let state = computeGraph(of: counter, from: initialMarking) else {
      XCTFail("Your counter model is unbounded model.")
      return
    }

    // Your counter should have only 8 states, encoding each possible value on 3 bits.
    XCTAssertEqual(Array(state).count, 8, "Your counter has unwanted states.")
  }

  static var allTests = [
    ("testIsFireable", testIsFireable),
    ("testFire", testFire),
    ("testCounterStructure", testCounterStructure),
    ("testCounterInitialMarking", testCounterInitialMarking),
    ("testCounterReachability", testCounterReachability),
    ("testCounterExtraStates", testCounterExtraStates),
  ]

}
