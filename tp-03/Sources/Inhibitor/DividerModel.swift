// Fonction crée un modèle de diviseur naturel

  public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] { // Initial marking qui prend en entrée l'opérande a et b

       let initialMarking: [DividerPlaceSet: Int] = [.opa: opa, .opb: opb, .res: 0, .ena: 0, .sto: 0]

       return initialMarking
       /// This function returns the initial marking corresponding to the model of your divider, for two
       /// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
}

public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {

   let net = InhibitorNet(
     places: Set(DividerPlaceSet.allCases),
     transitions: [

       // Add tokens in `sto` as long as there are some to consume in `opa` and `opb`.
       InhibitorNet.Transition(
         name: "add",
                      pre: [.opa: 1, .opb: 1, .ena: .inhibitor],
                      post: [.sto: 1]),

       // Refills the tokens of `opb`.
       InhibitorNet.Transition(
         name: "rfl",
                      pre: [.ena: 1, .sto: 1],
                      post: [.ena: 1, .opb: 1]),


       // Activates the refilling of `opb` and add 1 to 'res'.
       InhibitorNet.Transition(
         name: "ch1",
                      pre: [.opb: .inhibitor, .ena: .inhibitor],
                      post: [.ena: 1, .res: 1]),

       // Deactivates the refilling of `opb`.
       InhibitorNet.Transition(
         name: "ch2",
                      pre: [.ena: 1, .sto: .inhibitor],
                      post: [:]),
     ])
   return net
 }

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa

  /// The second operand
  case opb

  /// The result of `opa / opb`.
  case res

  ///A flag that enables the refilling of `opa`.
  case ena

  /// Store the tokens to refill in 'opa'
  case sto


}
