/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet(places: [], transitions: [])
}

/// This function returns the initial marking corresponding to the model of your divider.
public func createDividerInitialMarking() -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [:]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res

  // Add your additional places here, if any.

}
