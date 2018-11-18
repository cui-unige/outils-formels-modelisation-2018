/// A type that is a group in the mathematical sense.
///
/// A group is a set of elements (say `G`) equipped with a binary operation (say `+`) that produces
/// elements in the same set, whitch together satisfy the four fundamental properties of closure,
/// associativity, identity and invertibility:
/// - **closure**:
///   let `a` and `b` be two elements of `G`, then `a + b` is in `G`.
/// - **associativity**:
///   let `a`, `b` and `c` be elements of `G`, then `(a + b) + c` is equal to `a + (b + c)`.
/// - **identity**:
///   there exists `i` in `G` such that for any `a` in `G`, `a + i = i + a = a`.
/// - **invertibility**:
///   for each element `a` in `G`, there exists an element `b` in `G` such that
///   `a + b = b + a = i`.
///
/// For instance, integers (i.e. the type `Int`) is a group.
public protocol Group {

  static func + (lhs: Self, rhs: Self) -> Self

  static prefix func - (operand: Self) -> Self

  static var identity: Self { get }

}

extension Group {

  static func - (lhs: Self, rhs: Self) -> Self {
    return lhs + -rhs
  }

}
