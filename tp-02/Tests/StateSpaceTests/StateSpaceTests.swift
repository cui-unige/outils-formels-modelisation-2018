import XCTest
@testable import StateSpace

final class StateSpaceTests: XCTestCase {

  func testBoundedMarkingCount() {
    // Create a bounded model.
    let (model, initialMarking) = boundedModel()

    let exp = expectation(description: "Will compute the marking graph")
    var graph: MarkingNode<BoundedPlace>? = nil
    DispatchQueue.main.async {
      // Compute the marking graph of the model.
      graph = model.computeMarkingGraph(from: initialMarking)
      exp.fulfill()
    }

    // Wait for the marking graph to be created, with a timeout of 1.0s.
    wait(for: [exp], timeout: 1.0)

    // Since the model's bounded, the marking graph shouldn't be nil.
    guard graph != nil else {
      XCTFail("couldn't compte the marking graph of a bounded model")
      return
    }

    // Check the number of states in the model.
    XCTAssertEqual(graph!.count, 32)
  }

  func testBoundedMarkingReachability() {
    // Create a bounded model.
    let (model, initialMarking) = boundedModel()

    let exp = expectation(description: "Will compute the marking graph")
    var graph: MarkingNode<BoundedPlace>? = nil
    DispatchQueue.main.async {
      // Compute the marking graph of the model.
      graph = model.computeMarkingGraph(from: initialMarking)
      exp.fulfill()
    }

    // Wait for the marking graph to be created, with a timeout of 1.0s.
    wait(for: [exp], timeout: 1.0)

    // Since the model's bounded, the marking graph shouldn't be nil.
    guard graph != nil else {
      XCTFail("couldn't compte the marking graph of a bounded model")
      return
    }

    // The marking graph should contain the following markings.
    let markings: Set<Marking<BoundedPlace, Int>> = [
      [.t: 0, .w1: 1, .p: 0, .m: 0, .s1: 0, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 1],
      [.t: 1, .w1: 1, .p: 0, .m: 1, .s1: 0, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 0],
      [.t: 0, .w1: 1, .p: 0, .m: 0, .s1: 0, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 1],
      [.t: 1, .w1: 1, .p: 0, .m: 1, .s1: 0, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 1, .p: 1, .m: 1, .s1: 0, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 1, .p: 0, .m: 0, .s1: 0, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 1],
      [.t: 0, .w1: 1, .p: 0, .m: 0, .s1: 0, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 1],
      [.t: 1, .w1: 1, .p: 0, .m: 1, .s1: 0, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 0],
      [.t: 0, .w1: 1, .p: 1, .m: 1, .s1: 0, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 0],
      [.t: 1, .w1: 1, .p: 1, .m: 0, .s1: 0, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 0],
      [.t: 0, .w1: 0, .p: 0, .m: 0, .s1: 1, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 1],
      [.t: 1, .w1: 0, .p: 0, .m: 1, .s1: 1, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 0],
      [.t: 1, .w1: 0, .p: 0, .m: 1, .s1: 1, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 0],
      [.t: 0, .w1: 0, .p: 0, .m: 0, .s1: 1, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 1],
      [.t: 1, .w1: 0, .p: 0, .m: 1, .s1: 1, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 0, .p: 1, .m: 1, .s1: 1, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 0, .p: 1, .m: 1, .s1: 1, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 0],
      [.t: 1, .w1: 0, .p: 1, .m: 0, .s1: 1, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 0],
      [.t: 1, .w1: 0, .p: 1, .m: 0, .s1: 1, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 0],
      [.t: 0, .w1: 0, .p: 0, .m: 0, .s1: 1, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 1],
      [.t: 1, .w1: 0, .p: 0, .m: 1, .s1: 1, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 0, .p: 1, .m: 1, .s1: 1, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 0],
      [.t: 1, .w1: 0, .p: 1, .m: 0, .s1: 1, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 0, .p: 1, .m: 1, .s1: 1, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 0],
      [.t: 1, .w1: 0, .p: 1, .m: 0, .s1: 1, .w2: 0, .s2: 1, .s3: 0, .w3: 1, .r: 0],
      [.t: 0, .w1: 0, .p: 0, .m: 0, .s1: 1, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 1],
      [.t: 1, .w1: 1, .p: 0, .m: 1, .s1: 0, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 1, .p: 1, .m: 1, .s1: 0, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 0],
      [.t: 1, .w1: 1, .p: 1, .m: 0, .s1: 0, .w2: 0, .s2: 1, .s3: 1, .w3: 0, .r: 0],
      [.t: 1, .w1: 1, .p: 1, .m: 0, .s1: 0, .w2: 1, .s2: 0, .s3: 1, .w3: 0, .r: 0],
      [.t: 0, .w1: 1, .p: 1, .m: 1, .s1: 0, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 0],
      [.t: 1, .w1: 1, .p: 1, .m: 0, .s1: 0, .w2: 1, .s2: 0, .s3: 0, .w3: 1, .r: 0],
    ]
    XCTAssertEqual(Set(graph!.map({ $0.marking })), markings)
  }

  func testUnboundedMarkingFailure() {
    // Create an unbounded model.
    let (model, initialMarking) = unboundedModel()

    let exp = expectation(description: "Will not compute the marking graph")
    var graph: MarkingNode<UnboundedPlace>? = nil
    DispatchQueue.main.async {
      // Compute the marking graph of the model.
      graph = model.computeMarkingGraph(from: initialMarking)
      exp.fulfill()
    }

    // Wait for the marking graph to be created, with a timeout of 1.0s.
    wait(for: [exp], timeout: 1.0)

    // Since the model's unbounded, the marking graph shouldn't be nil.
    XCTAssertNil(graph)
  }

  func testBoundedCoverabilityCount() {
    // Create a bounded model.
    let (model, initialMarking) = boundedModel()

    let exp = expectation(description: "Will compute the coverability graph")
    var graph: CoverabilityNode<BoundedPlace>? = nil
    DispatchQueue.main.async {
      // Compute the coverability graph of the model.
      graph = model.computeCoverabilityGraph(from: initialMarking)
      exp.fulfill()
    }

    // Wait for the coverability graph to be created, with a timeout of 1.0s.
    wait(for: [exp], timeout: 1.0)

    // Check the number of states in the model.
    XCTAssertEqual(graph!.count, 32)
  }

  func testUnboundedCoverabilityCount() {
    // Create an unbounded model.
    let (model, initialMarking) = unboundedModel()

    let exp = expectation(description: "Will compute the coverability graph")
    var graph: CoverabilityNode<UnboundedPlace>? = nil
    DispatchQueue.main.async {
      // Compute the coverability graph of the model.
      graph = model.computeCoverabilityGraph(from: initialMarking)
      exp.fulfill()
    }

    // Wait for the coverability graph to be created, with a timeout of 1.0s.
    wait(for: [exp], timeout: 1.0)

    // Check the number of states in the model.
    XCTAssertEqual(graph!.count, 7)
    for state in graph! {
      print(state.marking)
    }
  }

  func testUnboundedCoverabilityReachability() {
    // Create an unbounded model.
    let (model, initialMarking) = unboundedModel()

    let exp = expectation(description: "Will compute the coverability graph")
    var graph: CoverabilityNode<UnboundedPlace>? = nil
    DispatchQueue.main.async {
      // Compute the coverability graph of the model.
      graph = model.computeCoverabilityGraph(from: initialMarking)
      exp.fulfill()
    }


    // Wait for the coverability graph to be created, with a timeout of 1.0s.
    wait(for: [exp], timeout: 1.0)

    // The coverability graph should contain the following markings.
    let markings: Set<Marking<UnboundedPlace, ExtendedInt>> = [
      [.p1: 2     , .p0: 3     ],
      [.p1: 6     , .p0: 2     ],
      [.p1: 10    , .p0: 1     ],
      [.p1: .omega, .p0: .omega],
      [.p1: 7     , .p0: 0     ],
      [.p1: 7     , .p0: .omega],
      [.p1: 3     , .p0: 1     ],
    ]
    XCTAssertEqual(Set(graph!.map({ $0.marking })), markings)
  }

  static var allTests = [
    ("testBoundedMarkingCount"              , testBoundedMarkingCount),
    ("testBoundedMarkingReachability"       , testBoundedMarkingReachability),
    ("testUnboundedMarkingFailure"          , testUnboundedMarkingFailure),
    ("testBoundedCoverabilityCount"         , testBoundedCoverabilityCount),
    ("testUnboundedCoverabilityCount"       , testUnboundedCoverabilityCount),
    ("testUnboundedCoverabilityReachability", testUnboundedCoverabilityReachability),
  ]

}
