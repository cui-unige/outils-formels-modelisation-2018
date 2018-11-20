# Representing places

If you look closely at the definition of the PetriNet protocol,
you'll see that `Place` is an abstract type that's required to be `CaseIterable` and `Hashable`.
The latter requirement is there to ensure places can be placed in sets,
while the former ensures there's a finite (and iterable) number of place instances.
That way, it's possible to *statically* know for what places a marking should be defined.

The easies way to create a type that respect the constraints we just mentioned
is to represent places as an enumeration without associated values,
and let Swift's compiler synthetize most of the heavy lifting.
Here's an example:

```swift
enum P: CaseIterable {
  case p0, p1
}
```

And that's it!
Now `P` is a `CaseIterable` and `Hashable` type that's ready to be used to define a petri net:

```swift
let pn = PTNet<P>(
  transitions: [
    PTTransition(
      named: "t",
      preconditions: [PTArc(place: .p0)],
      postconditions: [PTArc(place: .p1)]),
  ])
```

# Representing markings

Petri net markings are represented with a mapping of the form `Place -> Content`,
where `Place` is the type representing the places of the petri net (as explained above),
and `Content` is the type that represent token containers (e.g. the content of a place).

Markings resemble a lot like Swift's dictionaries.
But because we know statically what places should be present in a petri net,
subscripting them (i.e. using `[]`) with a place doesn't return an optional.
Therefore, you can write the following (assuming the existence of a type `P`):

```swift
let marking: Marking<P, Int> = [.p0: 1, .p1: 7]
print(marking[.p1]) // Prints '7' and not 'Optional(7)'
```

> Note that attempting to build a marking without defining a value for each place
  will result in an unrecoverable error!

Markings are `Equatable` if `Comparable` and even `Hashable` if `Content` is.
Moreover, if `Content` is a group
(in the [mathematical sense](https://en.wikipedia.org/wiki/Group_(mathematics))),
markings will also support addition and subtraction:

```swift
extension Int: Group {
  public static var identity: Int { return 0 }
}

let marking: Marking<P, Int> = [.p0: 1, .p1: 7]
print(marking + [.p0: 2, .p1: 3]) // Prints '[Place.p0: 3, Place.p1: 10]'
```

> Notice the extension to `Int` in the above example.
  This lets PetriKit understand that `Int` does indeed behave like a group.
  It's kind of obvious, but unfortunately Swift doesn't export extensions beyond module boundaries,
  meaning that you need to provide the conformance yourself.

> Why not having used a built-in protocol that would have ensured the existence of an infix `+`
  and a prefix `-` rather than a custom one (e.g. `Numeric`)?
  The reason is that not only numbers may be used as place content,
  and it wouldn't make sense to force such types to respect `Numeric`
  just to get the full markings algebra.
