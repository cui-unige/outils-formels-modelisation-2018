// MARK: This file simply contains extensions that make the InhibitorNet API a little bit nicer.

extension InhibitorNet.Arc: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self = .regular(value)
  }

}
