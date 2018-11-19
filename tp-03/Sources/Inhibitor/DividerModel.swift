/// This function creates the model of a natural divider.
public func createDividerModel() -> InhibitorNet<DividerPlaceSet> {
  
  let inhib = Arc.inhibitor
  let poids = Arc.regular(1)

  let opa_ = DividerPlaceSet.opa
  let opb_ = DividerPlaceSet.opb
  let res_ = DividerPlaceSet.res
  let stock_opb_ = DividerPlaceSet.stock_opb
  let return_opb_ = DividerPlaceSet.return_stock

  let places: Set<DividerPlaceSet> = [opa_,opb_,res_,stock_opb_,return_opb_]
  let t1 = transition("t1",[opa_: poids, opb_: poids , return_opb: inhib],[stock_opb_: poids])
  let t2 = transition("t2",[opb_: inhib,return_opb_: inhib],[res_: poids])
  let t3 = transition("t3",[stock_opb_: poids],[return_opb_: poids])
  let t4 = transition("t4",[return_opb_: poids],[opb_:poids])
  let transitions: Set = [t1,t2,t3,t4]
  return InhibitorNet(places, transitions)
}

/// This function returns the initial marking corresponding to the model of your divider, for two
/// operands `lhs` and `rhs` such that the model will compute `lhs / rhs`.
public func createDividerInitialMarking(opa: Int, opb: Int) -> [DividerPlaceSet: Int] {

 let opa_ = DividerPlaceSet.opa
  let opb_ = DividerPlaceSet.opb
  let res_ = DividerPlaceSet.res
  let stock_opb_ = DividerPlaceSet.stock_opb
  let return_opb_ = DividerPlaceSet.return_stock  

  return [opa_: opa, opb_:opb,res_:0,stock_opb_:0,return_opb_:0]
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
  case stock_opb // garde en mémoire le diviseur
  case return_opb // empêche la division tant que opb ne retrouve le bon nombre
}
