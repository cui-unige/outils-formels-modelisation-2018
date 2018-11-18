public protocol PetriNet {

  associatedtype Transition: TransitionProtocol

  typealias Place = Transition.Place
  typealias PlaceContent = Transition.PlaceContent
  typealias MarkingType = Transition.MarkingType

  var transitions: Set<Transition> { get }

  func simulate(steps: Int, from: MarkingType) -> MarkingType

}

extension PetriNet {

  public func simulate(steps: Int, from marking: MarkingType) -> MarkingType {
    var m = marking

    for _ in 0 ..< steps {
      let fireable = self.transitions.filter{ $0.isFireable(from: m) }
      if fireable.isEmpty {
        return m
      }
      m = Random.choose(from: fireable).fire(from: m)!
    }

    return m
  }

}

// ---------------------------------------------------------------------------

public protocol TransitionProtocol: Hashable {

  associatedtype Arc: ArcProtocol
  associatedtype PlaceContent

  typealias Place = Arc.Place
  typealias MarkingType = Marking<Place, PlaceContent>

  var preconditions : Set<Arc> { get }
  var postconditions: Set<Arc> { get }

  func isFireable(from marking: Marking<Arc.Place, PlaceContent>) -> Bool
  func fire(from marking: Marking<Arc.Place, PlaceContent>) -> Marking<Arc.Place, PlaceContent>?

}

// ---------------------------------------------------------------------------

public protocol ArcProtocol: Hashable {

  associatedtype Place: CaseIterable & Hashable
  associatedtype Label

  var place: Place { get }
  var label: Label { get }

}
