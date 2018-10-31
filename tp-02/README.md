# Homework \#2

In this homework, you implement the marking and coverability graph algorithms.

The submission deadline is set on October the 29th, at 23:59 Geneva local time.

**Important note about submissions**

As written in the course's README,
submissions must be made by pull request, **on the branch named after your GitHub username**.
If such branch does not exists,
email the course's assistant ([Dimitri Racordon](mailto:dimitri.racordon@unige.ch))
with your last name, first name and GitHub username **immediately**.

As a reminder, the submission process is described below:
1. Test your code!
2. Make sure to commit all your files on your GitHub repository.
   You will be evaluated on the last commit you've made before the deadline of the homework!
3. On GitHub, click on the New pull request button.
   This will lead you to a page where you can review your changes.
4. Be sure to select `cui-unige/outils-formels-modelisation-2018`
   and the `<your-github-username>` as the branch.
   Your homework will not be considered submitted if you submit a pull request to another base!
5. If everything looks good, click on the Create pull request button.

## Marking Graph

The marking graph of a Petri net is a structure where nodes represent accessible markings,
and links the transition that, when fired, update one marking to another.
The marking graph represents the complete state space of a Petri net.

In the file `Sources/StateSpace/PetriNet+Graphs.swift`,
fill out the missing implementation for the method `computeMarkingGraph(from:)`.

### `computeMarkingGraph(from:)`

This method returns the marking graph of a given Petri net.
If the model is unbounded, the method returns `nil`.
Here is a usage example:

```swift
// Create a simple Petri net model, with a single place and a single transition.
enum Place: CaseIterable {
  case p1
}
let model = PetriNet<Place>(transitions: [
  Transition(pre: [Arc(place: .p1, label: 2)], post: [Arc(place: .p1, label: 1)]),
])
let m0: Marking<Place, Int> = [.p1: 3]

// Try to compute the marking graph of the Petri net.
let graph = model.computeMarkingGraph(from: m0)
if graph != nil {
  print("The model has \(graph.count) states.")
}
```

## Coverability graph

The coverability graph of a Petri net is a structure where nodes represent covered markings,
and links the transition that, when fired, update one marking to another.
Unlike marking graphs, coverability graphs can represent unbounded Petri net,
but at the cost of a loss of information.

In the file `Sources/StateSpace/PetriNet+Graphs.swift`,
fill out the missing implementation for the method `computeCoverabilityGraph(from:)`.

### `computeCoverabilityGraph(from:)`

This method returns the coverability graph of a given Petri net.
Here is a usage example:

```swift
// Create a simple Petri net model, with a single place and a single transition.
enum Place: CaseIterable {
  case p1
}
let model = PetriNet<Place>(transitions: [
  Transition(pre: [Arc(place: .p1, label: 1)], post: [Arc(place: .p1, label: 2)]),
])
let m0: Marking<Place, Int> = [.p1: 3]

// Compute the coverability graph of the Petri net.
let graph = model.computeCoverabilityGraph(from: m0)
```

## Package organization

This homework is organized as a standard Swift package.
Sources are available in the folder `Sources/<Target>`,
where `<Target>` is the name of a particular target.

For the sake of this homework,
you will only need to work on the sources inside `Sources/StateSpace`,
but are encouraged to take a look at other the sources.
Remember that a submission that doesn't compile cannot pass any test.

Tests are located in the folder `Tests/StateSpaceTests`.
Don't hesitate to take a look, especially if your code fails to pass them.
However, remember that you **must not** modify those tests.
You can run the tests with the command `swift test`.
