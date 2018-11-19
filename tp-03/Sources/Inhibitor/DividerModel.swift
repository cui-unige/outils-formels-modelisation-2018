/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {

  return InhibitorNet(places: Set(DividerPlaceSet.allCases) , transitions: [
    InhibitorNet.Transition(
        // take coins from opa and opb until one of both is empty and fullfill the coins
        name: "retirer", pre: [ .opa: 1, .opb: 1, .enable: .inhibitor ], post: [ .coins: 1 ]
    ),
    InhibitorNet.Transition(
        // fullfill opb, take and add one coin into enable for setting the transision fireable
        name: "remplit", pre: [ .enable: 1, .coins: 1 ], post: [.opb: 1, .enable: 1 ]
    ),
    InhibitorNet.Transition(
        // add coin into enable and make add 'remplis' fireable
        name: "enable remplit", pre: [ .opb: .inhibitor, .enable: .inhibitor], post: [.enable: 1]
    ),
    InhibitorNet.Transition(
        // process the result, remove enable coin and make "retirer" fireable
        // number of coins into result represent the number of opb into opa
        name: "remplit res", pre: [.enable: 1, .coins: .inhibitor], post: [.res: 1]
    )
  ]);
}

  /// This function returns the initial marking corresponding to the model of your divider, for two
  /// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // Write your code here.
  return [.opa: opa, .opb: opb, .res: 0, .enable: 0, .coins: 0]
}

  /// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {

  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res
  // if empty pop coins, otherwise add coins
  case enable
  // number of coins into res represent the number of opb into opa
  // used for refilling opb with the correct amount of coins (temporary storage)
  case coins
}
