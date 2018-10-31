import PetriKit

extension Marking {

  var values: [Value] {
    return map { $0.value }
  }

}

extension PTNet {

  func bound(withInitialMarking initialMarking: MarkingType) -> UInt? {
    return computeGraph(of: self, from: initialMarking)
      .map { $0.map({ state in state.marking.values.max()! }).max()! }
  }

  func isAlive(withInitialMarking initialMarking: MarkingType) -> Bool {
    guard let graph = computeGraph(of: self, from: initialMarking)
      else { preconditionFailure("unbounded model") }
    return transitions.allSatisfy { t in
      graph.allSatisfy { s in s.contains { t.isFireable(from: $0.marking) } }
    }
  }

  func isQuasiAlive(withInitialMarking initialMarking: MarkingType) -> Bool {
    guard let graph = computeGraph(of: self, from: initialMarking)
      else { preconditionFailure("unbounded model") }
    return transitions.allSatisfy { t in
      graph.contains { t.isFireable(from: $0.marking) }
    }
  }

  func isDeadlockFree(withInitialMarking initialMarking: MarkingType) -> Bool {
    guard let graph = computeGraph(of: self, from: initialMarking)
      else { preconditionFailure("unbounded model") }
    return graph.contains { $0.successors.isEmpty }
  }

  func isReversible(withInitialMarking initialMarking: MarkingType) -> Bool {
    guard let graph = computeGraph(of: self, from: initialMarking)
      else { preconditionFailure("unbounded model") }
    return graph.successors.values.contains { s in
      s.contains { $0.marking == initialMarking }
    }
  }

}

func check<Place>(
  _ property: (PTNet<Place>.MarkingType) -> Bool,
  withInitialMarking initialMarking: PTNet<Place>.MarkingType)
{
  assert(property(initialMarking))
}


func check<Place>(
  _ properties: [(PTNet<Place>.MarkingType) -> Bool],
  withInitialMarking initialMarking: PTNet<Place>.MarkingType)
{
  assert(properties.allSatisfy { $0(initialMarking) })
}
