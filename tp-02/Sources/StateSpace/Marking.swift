/// Structure that represents a Petri net marking.
public struct Marking<Place, Value>: Hashable
  where Place: CaseIterable & Hashable,
        Value: Comparable & Hashable
{

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

extension Marking: Comparable {

  public static func < (lhs: Marking, rhs: Marking) -> Bool { // prend 2 marking
    var existsSmaller = false
    for place in Place.allCases { // pour toutes les places
      existsSmaller = existsSmaller || (lhs[place] < rhs[place])  // dès que 1 fois existsSmaller devient Structure
      // devient true jus'qua la fin
      guard lhs[place] <= rhs[place] // dès que une place contient moins de jeton à gauche que a droite
        else { return false }
    }
    return existsSmaller
  }

}

extension Marking: CustomStringConvertible {

  public var description: String {
    return storage.description
  }

}
