extension Collection {

  /// Returns the result of combining the elements of the sequence using the given closure.
  ///
  /// This method should be used to reduce collections with binary operators which combine any two
  /// elements to form a third of the same type, such as the integer addition for instance. Unlike
  /// Swift's `reduce(_:_:)` and `reduce(into:_:)`, this method does not require an initial result,
  /// but will return `nil` for empty collections.
  ///
  ///     let values = [1, 2, 3]
  ///     if let sum = values.reduce(with: +) {
  ///       print(sum)
  ///     }
  ///     // Prints "6"
  ///
  /// - Parameters:
  ///   - reducer: A closure that combines two elements to form a third.
  /// - Returns: The final accumulated value, or `nil` if the collection is empty.
  public func reduce(with reducer: (Self.Element, Self.Element) throws -> Self.Element)
    rethrows -> Self.Element?
  {
    guard let initialResult = first
      else { return nil }
    return try dropFirst().reduce(initialResult, reducer)
  }

}
