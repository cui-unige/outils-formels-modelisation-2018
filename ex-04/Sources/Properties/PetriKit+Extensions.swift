import PetriKit

extension PTTransition {

  init(named name: String, pre: Set<Place>, post: Set<Place>) {
    self.init(
      named: name,
      preconditions: Set(pre.map({ PTArc(place: $0) })),
      postconditions: Set(post.map({ PTArc(place: $0) })))
  }

}
