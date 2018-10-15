# Homework \#1

In this homework, you implement the firing semantics of Petri nets in Swift,
and design a small model to test it.

The submission deadline is set on October the 15th, at 23:59 Geneva local time.

## Firing semantics

The firing semantics of Petri nets is described in your lecture notes.
In this homework, you will transcribe the formal description available in your notes
into a working Swift implementation.

In the file `Sources/SemaLib/PetriNet.swift`,
fill out the missing implementation for the methods `isFireable(_:from:)` and `fire(_:from:)`.

### `isFireable(_:from:)`

This method returns whether a transition is fireable from a given marking.
Here is a usage example:

```swift
let model = PetriNet(
  places     : [Place("p1")],       // `P = { p1 }`
  transitions: [Transition("t1")],  // `T = { t1 }`
  pre        : { _, _ in 1 },       // `pre(p1, t1) = 1`
  post       : { _, _ in 1 })       // `post(p1, t1) = 1`.

// Is the transition fireable from the marking [p1 → 1]? Yes it is!
func m0(_ place: Place) -> Nat {
  return place == Place("p1") ? 1 : 0
}
print(model.isFireable(Transition("t1"), from: m0))

// Is the transition fireable from the marking [p1 → 0]? No it isn't!
func m1(_ place: Place) -> Nat {
  return place == Place("p1") ? 0 : 2
}
print(model.isFireable(Transition("t1"), from: m1))
```

### `fire(_:from:)`

This method computes the new marking obtained by firing a transition in a given marking,
if such transition is fireable.
If the transition isn't fireable from the given marking, the method returns `nil`.
Here's a usage example:

```swift
let model = PetriNet(
  places     : [Place("p1")],       // `P = { p1 }`
  transitions: [Transition("t1")],  // `T = { t1 }`
  pre        : { _, _ in 1 },       // `pre(p1, t1) = 1`
  post       : { _, _ in 0 })       // `post(p1, t1) = 0`.

// Compute the new marking after firing t1 from [p1 → 1].
func m0(_ place: Place) -> Nat {
  return place == Place("p1") ? 1 : 0
}
let m1 = model.fire(Transition("t1"), from: m0)

// Prints "0".
print(m1!(Place("p1")))

// Try to compute the marking obtained by firing t1 from [p1 → 0].
let m2 = model.fire(Transition("t1"), from: m1!)
if m2 == nil {
  print("The transition was not fireable.")
}
```

## Binary counter model

You will design the model of a binary counter on three bits.
In the file `Sources/SemaLib/CounterModel.swift`,
fill out the missing implementation for the functions `createCounterModel()` and `createCounterInitialMarking()`.

### `createCounterModel()`

This function creates the model of a binary counter on three bits.
The created model **must** feature at least three places, named `b2`, `b1` and `b0`,
which respectively will represent the bits 2, 1 and 0 of the counter.
In other words, `b0` represents the *least significant bit*.
For instance, if place `b2` and `b1` contain and token, while place `b0` doesn't,
the counter encodes the value 6 (i.e. `110` in binary).
You can add as many transitions and/or additional places as you need.

Your counter must start at 0,
increase by 1 every time a transition is fired,
and **must not** have any intermediate state,
For example, from a state that encodes the value 5,
the next state **must** encode the value 6.
Once you reach 7, your counter must reinitialize to 0 on the next transition firing.
In other words, your model must be completely reinitialized
after exactly 8 transition firings.

You can take inspiration from the model of the Petri net
created in the file `Sources/Sema/main.swift`,
as well as that in the tests for good examples of model definitions.

### `createCounterInitialMarking()`

This function returns the initial marking corresponding to the model of your binary counter.
In other words, it must return a function `(Place) -> Nat` that encodes your initial marking.

As per the requirements of the binary counter model described above,
you already know the returned marking must return the value 0 for the places `b2`, `b1` and `b0`.
That is:

```swift
let initialMarking = createCounterInitialMarking()
print(initialMarking(Place("b2")))  // Prints "0"
print(initialMarking(Place("b1")))  // Prints "0"
print(initialMarking(Place("b0")))  // Prints "0"
```

You can take inspiration from the model of the Petri net
created in the file `Sources/Sema/main.swift`,
as well as that in the tests for good examples of marking definitions.

## Package organization

This homework is organized as a standard Swift package.
Sources are available in the folder `Sources/<Target>`,
where `<Target>` is the name of a particular target.

For the sake of this homework,
you will only need to work on the sources inside `Sources/SemaLib`,
but are encouraged to take a look at other the sources.
In particular, `Sources/Sema/main.swift` shows various usage example of the library.
You can run the code of this file with the command `swift run`.
Don't hesitate to play with it.
Its content won't be part of the final evaluation **as long as it compiles**.
Remember that a submission that doesn't compile cannot pass any test.

Tests are located in the folder `Tests/SemaLibTests`.
Don't hesitate to take a look, especially if your code fails to pass them.
However, remember that you **must not** modify those tests.
You can run the tests with the command `swift test`.
