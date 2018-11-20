public struct Marking<Place, Value> where Place: CaseIterable & Hashable {

  public init<S>(uniquePlacesWithValues placesAndValues: S)
    where S: Sequence, S.Element == (Place, Value)
  {
    storage = Dictionary(uniqueKeysWithValues: placesAndValues)
    precondition(Set(storage.keys) == Set(Place.allCases), "incomplete marking definition")
  }

  public init(fromMapping placesAndValues: [Place: Value]) {
    storage = placesAndValues
    precondition(Set(storage.keys) == Set(Place.allCases), "incomplete marking definition")
  }

  public subscript(place: Place) -> Value {
    get { return storage[place]! }
    set { storage[place] = newValue }
  }

  private var storage: [Place: Value]

}

extension Marking: ExpressibleByDictionaryLiteral {

  public init(dictionaryLiteral elements: (Place, Value)...) {
    self.init(uniquePlacesWithValues: elements)
  }

}

extension Marking: Collection {

  public typealias Index = Place.AllCases.Index
  public typealias Element = (place: Place, value: Value)

  public var startIndex: Index { return Place.allCases.startIndex }
  public var endIndex  : Index { return Place.allCases.endIndex }

  public func index(after i: Index) -> Index {
    return Place.allCases.index(after: i)
  }

  public subscript(i: Index) -> Element {
    let place = Place.allCases[i]
    return (place: place, value: storage[place]!)
  }

}

extension Marking where Value: Group {

  public static func + (lhs: Marking, rhs: Marking) -> Marking {
    return Marking(
      uniquePlacesWithValues: Place.allCases.map { place in (place, lhs[place] + rhs[place]) })
  }

  public static func - (lhs: Marking, rhs: Marking) -> Marking {
    return Marking(
      uniquePlacesWithValues: Place.allCases.map { place in (place, lhs[place] - rhs[place]) })
  }

}

extension Marking: Equatable where Value: Equatable {
}

extension Marking: Comparable where Value: Comparable {

  public static func < (lhs: Marking, rhs: Marking) -> Bool {
    var existsSmaller = false
    for place in Place.allCases {
      existsSmaller = existsSmaller || (lhs[place] < rhs[place])
      guard lhs[place] <= rhs[place]
        else { return false }
    }
    return existsSmaller
  }

}

extension Marking: Hashable where Value: Hashable {
}

extension Marking: CustomStringConvertible {

  public var description: String {
    return storage.description
  }

}
