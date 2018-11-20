/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  // Write your code here.
  return InhibitorNet (places: Set(DividerPlaceSet.allCases), transitions: [
    // Etape "sub" : tant que des jetons sont presents dans "opb" et "opa", et qu'il n'y a pas dans "enb", on supprime un jeton 
    // de "opa" et de "opb", et on ajoute un dans "sto"
    InhibitorNet.Transition(
        name: "sub", pre: [ .opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),
    
    // Etape "rfl" : tant que des jetons sont presents dans "enb" et dans "sto", on supprime un jeton de "sto" et on ajoute un dans "opb"
    InhibitorNet.Transition(
        name: "rfl", pre: [ .sto: 1, .enb: 1], post: [ .enb: 1, .opb: 1]),
    
    // Etape "ch1" : s'il n'y a plus de jetons dans "opb" et dans "enb", on ajoute un jeton dans "enb" et dans "res"
    InhibitorNet.Transition(
        name: "ch1", pre: [ .opb: .inhibitor, .enb: .inhibitor], post: [ .enb: 1, .res: 1]),
    
    // Etape "ch2" : si "enb" contient un jeton et que "sto" est vide, on vide "enb" pour relancer "sub" si c'est possible
    InhibitorNet.Transition(
        name: "ch2", pre: [ .enb: 1, .sto : .inhibitor], post: [:]),
  ])
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto:0]
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
  // A flag that enables the refilling of `opb`.
  case enb
  // Store the tokens to refill in `opb`.
  case sto

}
