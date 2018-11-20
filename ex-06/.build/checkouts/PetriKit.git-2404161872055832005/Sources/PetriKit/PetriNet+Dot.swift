import Foundation

extension PetriNet {

  public func saveAsDot(to url: URL, withMarking: MarkingType? = nil) throws {
    var output = "digraph G {\n"

    // Place subgraph ...
    output += "subgraph place {\n"
    output += "node [shape=circle, width=.5];\n"
    for place in Place.allCases {
      var label = ""
      if let tokens = withMarking?[place] {
        label = String(describing: tokens)
      }

      output += "\"\(place)\" [label=\"\(label)\", xlabel=\"\(place)\"];\n"
    }
    output += "}\n"

    // Transition subgraph ...
    output += "subgraph transitions {\n"
    output += "node [shape=rect, width=.5, height=.5];\n"
    for transition in self.transitions {
      output += "\"\(transition)\";\n"
    }
    output += "}\n"

    // Arcs definitions ...
    for transition in self.transitions {
      for arc in transition.preconditions {
        output += "\"\(arc.place)\" -> \"\(transition)\""
        output += " [label=\(arc.label)];\n"
      }

      for arc in transition.postconditions {
        output += "\"\(transition)\" -> \"\(arc.place)\""
        output += " [label=\(arc.label)];\n"
      }
    }

    output += "}\n"
    try output.write(to: url, atomically: true, encoding: String.Encoding.utf8)
  }

}
