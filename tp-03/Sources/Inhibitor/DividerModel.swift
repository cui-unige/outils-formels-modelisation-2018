/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
	// InhibitorNet<DividerPlaceSet>  fait de places et transitions (voir inhibitor init)
  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases), // on garde toutes les places (les mêmes)
    transitions: [
      InhibitorNet.Transition(
        // on enlève n de m
        name: "add", pre: [.opa: 1, .opb: 1, .ena: .inhibitor], post: [.sto: 1]),
				// on re-repli opb à n (à l'aide de sto dans lequel on a stocké n durant add)
        // quand on décrémentait n de m, en même temps on remplissait sto
      InhibitorNet.Transition(
        name: "rfl", pre: [.ena: 1, .sto: 1], post: [.ena: 1, .opb: 1]), // (ne change pas)
				// Activates the refilling of `opa`.
      InhibitorNet.Transition(
        // on met ena à 1, pour pouvoir reremplir opb au bon nombre (à l'aide de sto qui le contient)
        name: "ch1", pre: [.opb: .inhibitor, .ena: .inhibitor], post: [.ena: 1]), // (ne change pas)
        // on a enlevé n de m et "n de nouveau à n" : res = res + 1
      InhibitorNet.Transition(
        name: "ch2", pre: [.ena: 1, .sto: .inhibitor], post: [.res: 1]),
    ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa / opb`.
  case res
	/// A flag that enables the refilling of `opa`.
	case ena
  /// Store the tokens to refill in `opa`.
  case sto
  // Add your additional places here, if any.

}
