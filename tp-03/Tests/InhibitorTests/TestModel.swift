import Inhibitor

enum TestPlaceSet: CaseIterable {

  case p1, p2

}

func createTestModel() -> InhibitorNet<TestPlaceSet> {
  return InhibitorNet(
    places: Set(TestPlaceSet.allCases),
    transitions: [
      InhibitorNet.Transition(
        name: "t1", pre: [.p1: 1, .p2: .inhibitor], post: [.p1: 1, .p2: 1]),
      ])
}
