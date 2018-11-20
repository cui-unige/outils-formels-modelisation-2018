import XCTest
@testable import PetriKit

class RandomTests: XCTestCase {

  func testRandint() {
    for _ in 0 ..< 1000 {
      let x = Random.randint(0, 1000)
      XCTAssert(x >= 0 && x <= 1000)
    }

    for _ in 0 ..< 1000 {
      let x = Random.randint(-1000, 0)
      XCTAssert(x >= -1000 && x <= 0)
    }

    for _ in 0 ..< 1000 {
      let x = Random.randint(-1000, 1000)
      XCTAssert(x >= -1000 && x <= 1000)
    }
  }

  func testChooseIndex() {
    let arr = Array(0 ... 1000)
    for _ in 0 ..< 100 {
      let index = Random.chooseIndex(from: arr)
      XCTAssert(index >= 0 && index < arr.count)
    }
  }

  func testChoose() {
    let arr = Array(0 ... 1000)
    for _ in 0 ..< 100 {
      XCTAssert(arr.contains(Random.choose(from: arr)))
    }

    let set = Set(Array(0 ... 1000))
    for _ in 0 ..< 100 {
      XCTAssert(set.contains(Random.choose(from: set)))
    }
  }

  func testSample() {
    let arr = Array(0 ... 1000)
    for _ in 0 ..< 100 {
      let chosen = Random.sample(arr, k: 10)
      XCTAssertEqual(chosen.count, 10)
      for element in chosen {
        XCTAssert(arr.contains(element))
      }
    }
  }

  static var allTests = [
    ("testRandint"    , testRandint),
    ("testChooseIndex", testChooseIndex),
    ("testChoose"     , testChoose),
    ("testSample"     , testSample),
  ]

}
