public struct Random {

  /// Return a random integer.
  public static func random() -> Int {
    return Random.rand()
  }

  /// Return a random integer `i` such that `lowerBound <= i <= upperBound`.
  public static func randint(_ lowerBound: Int, _ upperBound: Int) -> Int {
    precondition(upperBound >= lowerBound)
    return Random.rand() % (upperBound - lowerBound + 1) + lowerBound
  }

  /// Return a random integer within the given range.
  public static func randint(_ range: Range<Int>) -> Int {
    return Random.randint(range.lowerBound, range.upperBound - 1)
  }

  /// Return a random integer within the given range.
  public static func randint(_ range: ClosedRange<Int>) -> Int {
    return Random.randint(range.lowerBound, range.upperBound)
  }

  /// Return a random valid index for the given collection.
  public static func chooseIndex<C: Collection>(from collection: C) -> C.Index {
    precondition(collection.startIndex != collection.endIndex)

    var index    = collection.startIndex
    let distance = Random.randint(0 ..< collection.underestimatedCount)
    for _ in 0 ..< distance {
      index = collection.index(after: index)
    }

    return index
  }

  /// Return a random valid index for the given collection.
  public static func choose<C: Collection>(from collection: C) -> C.Iterator.Element {
    return collection[Random.chooseIndex(from: collection)]
  }

  /// Return a k length list of unique elements chosen from the given
  /// collection.
  public static func sample<C: Collection>(_ collection: C, k: Int) -> [C.Iterator.Element] {
    guard k > 0 else {
      return []
    }
    precondition(k <= collection.underestimatedCount)

    var chosen: [C.Index] = []
    for _ in 0 ..< k {
      var index = Random.chooseIndex(from: collection)
      while chosen.contains(index) {
        index = collection.index(after: index)
        if index == collection.endIndex {
          index = collection.startIndex
        }
      }

      chosen.append(index)
    }

    return chosen.map { collection[$0] }
  }

  // NOTE: We provide our own implementation of glib's rand(), so that we
  // can run the same code under OSX and Linux.

  public static var seed: UInt = 5323

  private static func rand() -> Int {
    var result: UInt

    Random.seed = Random.seed &* 1103515245
    Random.seed = Random.seed &+ 12345
    result = (Random.seed / 65536) % 2048

    Random.seed = Random.seed &* 1103515245
    Random.seed = Random.seed &+ 12345
    result <<= 10
    result ^= (Random.seed / 65536) % 1024

    Random.seed = Random.seed &* 1103515245
    Random.seed = Random.seed &+ 12345
    result <<= 10
    result ^= (Random.seed / 65536) % 1024

    return Int(result)
  }

}
