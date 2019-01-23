infix operator => : LogicalDisjunctionPrecedence

/// A formula of propositional logic.
public enum Formula: Hashable {

  /// true or false
  case constant(Bool)

  /// p
  case proposition(String)

  /// ¬a
  indirect case negation(Formula)

  public static prefix func ! (formula: Formula) -> Formula {
    return .negation(formula)
  }

  /// a ∨ b
  indirect case disjunction(Formula, Formula)

  public static func || (lhs: Formula, rhs: Formula) -> Formula {
    return .disjunction(lhs, rhs)
  }

  /// a ∧ b
  indirect case conjunction(Formula, Formula)

  public static func && (lhs: Formula, rhs: Formula) -> Formula {
    return .conjunction(lhs, rhs)
  }

  /// a → b
  indirect case implication(Formula, Formula)

  public static func => (lhs: Formula, rhs: Formula) -> Formula {
    return .implication(lhs, rhs)
  }

}

extension Formula: ExpressibleByStringLiteral {

  /// Creates a proposition from a String literal.
  public init(stringLiteral value: String) {
    self = .proposition(value)
  }

}

extension Formula: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: Bool) {
    self = .constant(value)
  }

}

extension Formula: CustomStringConvertible {

  /// The textual representation of a formula.
  public var description: String {
    switch self {
    case .constant(let c):
      return c ? "true" : "false"
    case .proposition(let p):
      return p
    case .negation(let a):
      return "¬\(a)"
    case .disjunction(let a, let b):
      return "(\(a) ∨ \(b))"
    case .conjunction(let a, let b):
      return "(\(a) ∧ \(b))"
    case .implication(let a, let b):
      return "(\(a) → \(b))"
    }
  }

}
