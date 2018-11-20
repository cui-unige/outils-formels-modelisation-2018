/*
------------------------------------------------------------------------------
# NAME : DividerModel.swift
#
# PURPOSE : Implementation of a natural divider model and its initial marking
#
# AUTHOR : Benjamin Fischer
#
# CREATED : 16.11.2018
-----------------------------------------------------------------------------
*/
/*
# ------------------------------------------------------------------------------
# METHOD : createDividerModel() -> InhibitorNet<DividerPlaceSet>
#
# PURPOSE : Creates the model of a natural divider
#
# INPUT : -
#
# OUTPUT : InhibitorNet<DividerPlaceSet>
# -----------------------------------------------------------------------------
*/
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  return InhibitorNet(
    places: Set(DividerPlaceSet.allCases), // keep the same places
      transitions: [
        // store opb in sto
        // substraction : 'opa - opb'
        InhibitorNet.Transition(
          name: "sub", pre: [ .opa: 1, .opb: 1, .enb: .inhibitor], post: [.sto: 1]),
        // refill opb (from sto) for next substraction
        // empty sto for next substraction
        // enb allows to fire sub
        // once sto is empty, sub is not fireable anymore
        InhibitorNet.Transition(
          name: "rfl", pre: [ .sto: 1, .enb: 1], post: [ .enb: 1, .opb: 1]),
        // ch1 set rfl when enb and opb are empty (inhibitor arcs)
        // active enb
        // ch1 is fireable when opb is empty ===> increment of 1 in res
        // if opb is non-empty, there is no more incrementation and divider model will be blocked by opa
        InhibitorNet.Transition(
          name: "ch1", pre: [ .opb: .inhibitor, .enb: .inhibitor], post: [ .enb: 1, .res: 1]),
        // ch2 restarts a new substraction (fills enb)
        InhibitorNet.Transition(
          name: "ch2", pre: [ .enb: 1, .sto : .inhibitor], post: [:]),
    ])
}
/*
# ------------------------------------------------------------------------------
# METHOD : createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int]
#
# PURPOSE : Returns the initial marking corresponding to the model of the natural divider,
#           for two operands 'opa' and 'opb' such that the model computes 'opa / opb'
#
# INPUT : opa: Int, opb: Int
#
# OUTPUT : [DividerPlaceSet: Int]
# -----------------------------------------------------------------------------
*/
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {
  // divider's initial marking
  return [.opa: opa, .opb: opb, .res: 0, .enb: 0, .sto:0 ]
}

/// This enumeration represents the different places of your natural divider.
public enum DividerPlaceSet: CaseIterable {
  /// The first operand.
  case opa
  /// The second operand
  case opb
  /// The result of `opa * opb`.
  case res
  /// A flag that enables the refilling of `opb`.
  case enb
  /// Store the tokens to refill in `opb`.
  case sto
}
