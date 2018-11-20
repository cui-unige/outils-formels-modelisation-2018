# PetriKit

## Getting started

> Note this tutorial assumes you are using Swift 4 on a unix-like machine.

### Installing PetriKit

You use PetriKit with the [Swift Package Manager](https://swift.org/package-manager/).
Create an empty directory for your application,
open a terminal inside and create a new Swift command line tool:

```bash
mkdir /some/path/to/your/app
cd /some/path/to/your/app
swift package init --type executable
```

You'll have to add PetriKit as a dependency to your application.
Open the generated file `Package.swift` and edit its content as follows:

```swift
// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "MyApp",
  dependencies: [
    .package(url: "https://github.com/kyouko-taiga/PetriKit.git", from: "2.0.0")
  ],
  targets: [
    .target(
      name: "MyApp",
      dependencies: ["PetriKit"]),
  ])
```

This will let you import PetriKit in your sources.
Add the following statement at the beginning of `Sources/MyApp/main.swift`:

```swift
import PetriKit
```

And you can now use PetriKit.

### Creating a Place/Transition Net

Petri nets in PetriKit are described by the means of two protocols:
`Transition` and `PetriNet`.
Those protocols only describe the minimum requirements for a type
to represent a transition (resp. a petri net).
They can be seen as an abstract description of the structure of a Petri net.
Hence, they can't be used *as is*,
but rather should be implemented for a particular type of Petri net.

PetriKit comes with such an implementation for
[Place/Transition nets](https://en.wikipedia.org/wiki/Petri_net) (or P/T-nets).
Those are one of the most simple variant of Petri nets.
You can create a P/T-net as follows:

```swift
enum Place {
  case p0, p1
}

let t0 = PTTransition<Place>(
  named         : "t0",
  preconditions : [PTArc(place: .p0)],
  postconditions: [PTArc(place: .p1)])
let t1 = PTTransition<Place>(
  named         : "t1",
  preconditions : [PTArc(place: .p1)],
  postconditions: [PTArc(place: .p0)])

let pn = PTNet(transitions: [t0, t1])
```

The above code create a P/T-net `pn` composed of two places and two transitions.

### Simulating Place/Transition Nets

You can simulate the firing of a transition as follows:

```swift
let m = t0.fire(from: [.p0: 1, .p1: 1])
```

The above code assigns to `m` the marking obtained after firing the transition `t0`
from the marking `[.p0: 1, .p1: 1]` (i.e. one token in each place).
Note that the method `fire(from:)` of the `TransitionProtocol` protocols returns an optional.
That's because if the transition is not fireable from the given marking,
the method should return `nil`.

You can also simulate the execution of a P/T-net from a given initial marking:

```swift
let m = pn.simulate(steps: 4, from: [.p0: 1, .p1: 0])
```

The above code simulate 4 steps of execution,
randomly choosing one fireable transition at each step,
or stops prematurely if the simulation reaches a deadlock.

### Visualizing Place/Transition Nets

The type `PTNet` comes with a special method `saveAsDot`
that outputs the given P/T-net as a [Graphviz](http://www.graphviz.org/content/dot-language) file.
Note that this will require you to import the Foundation library as well.

```swift
import Foundation

// ...

try pn.saveAsDot(to: URL(fileURLWithPath: "pn.dot"), withMarking: [.p0: 1, .p1: 2])
```

The above code will output the P/T-net `pn` with marking `[.p0: 1, .p1: 2]`
to a file named `pn.dot`.
