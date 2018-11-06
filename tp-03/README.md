# Homework \#3

In this homework, you implement the firing semantics of Petri nets extended with inhibitor arcs,
and design a small model to test it.

The submission deadline is set on November the 19th, at 23:59 Geneva local time.

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

## Firing semantics

The firing semantics of Petri nets extended with inhibitor arcs is described in your lecture notes.
In this homework, you will transcribe the formal description available in your notes
into a working Swift implementation.

In the file `Sources/Inhibitor/Inhibitor.swift`,
fill out the missing implementation for the methods `isFireable(_:from:)` and `fire(_:from:)`.
There are usage examples for both these methods in the executable of the project,
that is the file named `Sources/structext/main.swift`.

## Natural Divider Model

You will design the model of an natural divider,
able to divide any natural (i.e. positive integer) *m* by another *n*.
In the file `Sources/Inhibitor/Divider.swift`,
fill out the missing implementation for the functions `createDividerModel()` and `createDividerInitialMarking()`.

### `createDividerModel()`

This function creates the model of a natural divider.
The created model **must** feature at least three places, named `opa`, `opb` and `res`,
which respectively will represent the first operand,
the second operand and the result of the division.

In the initial marking, `opa` must contain *m* tokens and `opb` *n*.
Your model must then be able to eventually compute the result of *m/n*,
encoded as the number of token in `res`.

The computation is expected to be completed when there are no more transition to fire.
This means your model **must** be blocked after some finite number of transition firings.
Places `opa`, `opb` and `res` may have any number of token during all the intermediary steps.

You can take inspiration from the model of a multiplier
created in the file `Sources/structext/main.swift`.

## Package organization

This homework is organized as a standard Swift package.
Sources are available in the folder `Sources/<Target>`,
where `<Target>` is the name of a particular target.

For the sake of this homework,
you will only need to work on the sources inside `Sources/Inhibitor`,
but are encouraged to take a look at other the sources.
In particular, `Sources/structext/main.swift` shows various usage example of the library.
You can run the code of this file with the command `swift run`.
Don't hesitate to play with it.
Its content won't be part of the final evaluation **as long as it compiles**.
Remember that a submission that doesn't compile cannot pass any test.

Tests are located in the folder `Tests/InhibitorTests`.
Don't hesitate to take a look, especially if your code fails to pass them.
However, remember that you **must not** modify those tests.
You can run the tests with the command `swift test`.
