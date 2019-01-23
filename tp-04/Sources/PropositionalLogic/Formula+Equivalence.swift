extension Formula {

  /// Returns whether this formula is semantically equivalent to the given one.
  public func isSemanticallyEquivalent(to other: Formula) -> Bool {
    return (self == other) ||
      Valuations(propositions.union(other.propositions)).allSatisfy {
        eval(with: $0) == other.eval(with: $0)
    }
  }

  /// Whether or not the formula is a tautology.
  public var isTautology: Bool {
    return Valuations(propositions).allSatisfy(eval)
  }

  /// Whether or not the formula is a contradiction.
  public var isContradiction: Bool {
    return !Valuations(propositions).contains(where: eval)
  }

  /// Evaluates the formula, with a given valuation of its propositions.
  ///
  ///     let f: Formula = (.proposition("p") || .proposition("q"))
  ///     let value = f.eval(with: ["p": true, "q": false])
  ///     // 'value' == true
  ///
  /// - Warning: The provided valuation should be defined for each proposition name the formula
  ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
  ///
  /// - Parameters:
  ///   - valuation: A function that maps proposition names to a boolean value.
  /// - Returns: The evaluation of the formula for the given valuation.
  public func eval(with valuation: [String: Bool]) -> Bool {
    switch self {
    case .constant(let c):
      return c
    case .proposition(let p):
      return valuation[p]!
    case .negation(let a):
      return !a.eval(with: valuation)
    case .disjunction(let a, let b):
      return a.eval(with: valuation) || b.eval(with: valuation)
    case .conjunction(let a, let b):
      return a.eval(with: valuation) && b.eval(with: valuation)
    case .implication(let a, let b):
      return !a.eval(with: valuation) || b.eval(with: valuation)
    }
  }

  /// The propositions of the formula.
  ///
  ///     let f: Formula = .conjunction("a", .conjunction("b", .negation("c")))
  ///     print(propositions)
  ///     // Prints "[a, b, c]"
  ///
  private var propositions: Set<String> {
    switch self {
    case .constant:
      return []
    case .proposition(let p):
      return [p]
    case .negation(let a):
      return a.propositions
    case .disjunction(let a, let b):
      return a.propositions.union(b.propositions)
    case .conjunction(let a, let b):
      return a.propositions.union(b.propositions)
    case .implication(let a, let b):
      return a.propositions.union(b.propositions)
    }
  }

}

/// A sequence that generates all possible boolean valuations of a set of propositional variables.
fileprivate struct Valuations: IteratorProtocol, Sequence {

  fileprivate typealias Element = [String: Bool]

  fileprivate init<S>(_ variables: S) where S: Sequence, S.Element == String {
    self.variables = Array(variables)
    self.values = Array(repeating: false, count: self.variables.count)
  }

  private let variables: [String]
  private var values: [Bool]
  private var isDone: Bool = false

  public mutating func next() -> [String: Bool]? {
    guard !isDone
      else { return nil }
    let nextElement = Dictionary(uniqueKeysWithValues: zip(variables, values))

    for i in 0 ..< variables.count {
      if !values[i] {
        values[i] = true
        break
      } else {
        values[i] = false
      }
    }
    isDone = values.allSatisfy { !$0 }

    return nextElement
  }

}
