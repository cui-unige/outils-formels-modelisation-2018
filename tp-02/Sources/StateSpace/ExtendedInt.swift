/// Define the integers, extended with ω.
public enum ExtendedInt: Comparable, Hashable {
    /// Case representing a concrete integer value.
    case concrete(Int)
    /// Case representing ω.
    case omega

    public static func + (lhs: ExtendedInt, rhs: ExtendedInt) -> ExtendedInt {
        switch (lhs, rhs) {
        case let (.concrete(n), .concrete(m)): return .concrete(n + m)
        default: return .omega
        }
    }

    public static func += (lhs: inout ExtendedInt, rhs: ExtendedInt) {
        lhs = lhs + rhs
    }

    public static func - (lhs: ExtendedInt, rhs: ExtendedInt) -> ExtendedInt {
        switch (lhs, rhs) {
        case let (.concrete(n), .concrete(m)): return .concrete(n - m)
        case (.omega, _): return .omega
        default: fatalError("undefined operation")
        }
    }

    public static func -= (lhs: inout ExtendedInt, rhs: ExtendedInt) {
        lhs = lhs - rhs
    }

    public static func == (lhs: ExtendedInt, rhs: ExtendedInt) -> Bool {
        switch (lhs, rhs) {
        case let (.concrete(n), .concrete(m)): return n == m
        case (.omega, .omega): return true
        default: return false
        }
    }

    public static func == (lhs: Int, rhs: ExtendedInt) -> Bool {
        return .concrete(lhs) == rhs
    }

    public static func == (lhs: ExtendedInt, rhs: Int) -> Bool {
        return lhs == .concrete(rhs)
    }

    // MARK: Conformance to comparable.

    public static func < (lhs: ExtendedInt, rhs: ExtendedInt) -> Bool {
        switch (lhs, rhs) {
        case let (.concrete(n), .concrete(m)): return n < m
        case (_, .omega): return true
        default: return false
        }
    }
}

extension ExtendedInt: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .concrete(value)
    }
}

extension ExtendedInt: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .concrete(n): return n.description
        case .omega: return "ω"
        }
    }
}
