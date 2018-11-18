public struct PTNet<Place>: PetriNet where Place: CaseIterable & Hashable {

  public let transitions: Set<PTTransition<Place>>

  public init(transitions: Set<PTTransition<Place>>) {
    self.transitions = transitions
  }

}

// ---------------------------------------------------------------------------

public class PTPlace {

  public let name: String

  public init(named name: String) {
    self.name = name
  }

}

extension PTPlace: Hashable {

  public var hashValue: Int {
    return self.name.hashValue
  }

  public static func == (lhs: PTPlace, rhs: PTPlace) -> Bool {
    return lhs === rhs
  }

}

extension PTPlace: CustomStringConvertible {

  public var description: String {
    return self.name
  }

}

// ---------------------------------------------------------------------------

public struct PTTransition<Place>: TransitionProtocol where Place: CaseIterable & Hashable {

  public typealias PlaceContent = UInt
  public typealias Arc = PTArc<Place>

  public let name: String
  public let preconditions: Set<Arc>
  public let postconditions: Set<Arc>

  public init(named name: String, preconditions: Set<Arc>, postconditions: Set<Arc>) {
    self.name           = name
    self.preconditions  = preconditions
    self.postconditions = postconditions
  }

  public func isFireable(from marking: MarkingType) -> Bool {
    return preconditions.allSatisfy { arc in marking[arc.place] >= arc.label }
  }

  public func fire(from marking: MarkingType) -> MarkingType? {
    guard self.isFireable(from: marking) else {
      return nil
    }

    var result = marking
    for arc in self.preconditions {
      result[arc.place] -= arc.label
    }
    for arc in self.postconditions {
      result[arc.place] += arc.label
    }

    return result
  }

}

extension PTTransition: CustomStringConvertible {

  public var description: String {
    return self.name
  }

}

// ---------------------------------------------------------------------------

public struct PTArc<Place>: ArcProtocol where Place: CaseIterable & Hashable {

  public let place: Place
  public let label: UInt

  public init(place: Place, label: UInt = 1) {
    self.place = place
    self.label = label
  }

}
