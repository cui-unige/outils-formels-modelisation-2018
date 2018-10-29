public struct PetriNet<Place> where Place: CaseIterable & Hashable {
    public init(transitions: Set<Transition<Place>>) {
        self.transitions = transitions
    }

    let transitions: Set<Transition<Place>>
}

public struct Transition<Place>: Hashable where Place: CaseIterable & Hashable {
    public init(pre: Set<Arc<Place>>, post: Set<Arc<Place>>) {
        preconditions = pre
        postconditions = post
    }

    let preconditions: Set<Arc<Place>>
    let postconditions: Set<Arc<Place>>

    public func isFireable(from marking: Marking<Place, Int>) -> Bool {
        return preconditions.allSatisfy { arc in arc.label <= marking[arc.place] }
    }

    public func isFireable(from marking: Marking<Place, ExtendedInt>) -> Bool {
        return preconditions.allSatisfy { arc in .concrete(arc.label) <= marking[arc.place] }
    }

    public func fire(from marking: Marking<Place, Int>) -> Marking<Place, Int>? {
        guard isFireable(from: marking) else {
            return nil
        }

        var result = marking
        for arc in preconditions {
            result[arc.place] -= arc.label
        }
        for arc in postconditions {
            result[arc.place] += arc.label
        }

        return result
    }

    public func fire(from marking: Marking<Place, ExtendedInt>) -> Marking<Place, ExtendedInt>? {
        guard isFireable(from: marking) else {
            return nil
        }

        var result = marking
        for arc in preconditions {
            result[arc.place] -= .concrete(arc.label)
        }
        for arc in postconditions {
            result[arc.place] += .concrete(arc.label)
        }

        return result
    }
}

extension Transition: CustomStringConvertible {
    public var description: String {
        let pre = preconditions.map({ $0.description }).joined(separator: ", ")
        let post = postconditions.map({ $0.description }).joined(separator: ", ")
        return "\(pre) -> [] -> \(post)"
    }
}

public struct Arc<Place>: Hashable where Place: Hashable {
    public init(place: Place, label: Int = 1) {
        self.place = place
        self.label = label
    }

    public let place: Place
    public let label: Int
}

extension Arc: CustomStringConvertible {
    public var description: String {
        return "(\(place), \(label))"
    }
}
