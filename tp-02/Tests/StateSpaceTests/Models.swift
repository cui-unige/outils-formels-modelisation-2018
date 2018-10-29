import StateSpace

enum BoundedPlace: CaseIterable {
  case r, p, t, m, w1, s1, w2, s2, w3, s3
}

func boundedModel() -> (PetriNet<BoundedPlace>, Marking<BoundedPlace, Int>) {
  let net = PetriNet<BoundedPlace>(transitions: [
    Transition(
      pre : [Arc(place: .r)],
      post: [Arc(place: .p), Arc(place: .t)]),
    Transition(
      pre : [Arc(place: .r)],
      post: [Arc(place: .p), Arc(place: .m)]),
    Transition(
      pre : [Arc(place: .r)],
      post: [Arc(place: .t), Arc(place: .m)]),
    Transition(
      pre : [Arc(place: .p), Arc(place: .t), Arc(place: .w1)],
      post: [Arc(place: .r), Arc(place: .s1)]),
    Transition(
      pre : [Arc(place: .p), Arc(place: .m), Arc(place: .w2)],
      post: [Arc(place: .r), Arc(place: .s2)]),
    Transition(
      pre : [Arc(place: .t), Arc(place: .m), Arc(place: .w3)],
      post: [Arc(place: .r), Arc(place: .s3)]),
    Transition(
      pre : [Arc(place: .s1)],
      post: [Arc(place: .w1)]),
    Transition(
      pre : [Arc(place: .s2)],
      post: [Arc(place: .w2)]),
    Transition(
      pre : [Arc(place: .s3)],
      post: [Arc(place: .w3)]),
  ])

  let initialMarking: Marking<BoundedPlace, Int> =
    [.r: 1, .p: 0, .t: 0, .m: 0, .w1: 1, .s1: 0, .w2: 1, .s2: 0, .w3: 1, .s3: 0]
  return (net, initialMarking)
}

enum UnboundedPlace: String, CaseIterable, CustomStringConvertible {
  case p0, p1

  var description: String { return self.rawValue }
}

func unboundedModel() -> (PetriNet<UnboundedPlace>, Marking<UnboundedPlace, Int>) {
  let net = PetriNet<UnboundedPlace>(transitions: [
    Transition(
      pre:  [Arc(place: .p0, label: 2)],
      post: [Arc(place: .p1)]),
    Transition(
      pre : [Arc(place: .p1, label: 6)],
      post: [Arc(place: .p1, label: 6), Arc(place: .p0)]),
    Transition(
      pre : [Arc(place: .p0, label: 2)],
      post: [Arc(place: .p0), Arc(place: .p1, label: 4)]),
    ])

  let initialMarking: Marking<UnboundedPlace, Int> = [.p0: 3, .p1: 2]
  return (net, initialMarking)
}
