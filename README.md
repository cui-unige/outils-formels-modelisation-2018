# Outils formels de modélisation @ University of Geneva

This page contains important information about the course.

## Work environment for the exercise sessions

A significant part of the exercise sessions will be conducted on a computer.
Therefore, each student will be required to have access to the following work environment:

* A computer installed with Ubuntu 18.04 or macOS 10.13 (High Sierra).
* A `git` client, accessible from the command line.
* The latest version of the [Atom](https://atom.io) editor installed on your machine.
* A [GitHub](https://github.com) account.

> Note that you can ask GitHub for a Student Pack to obtain free private repositories.

You are free to choose another operating system, but note that
**you won't receive support from the course's assistant for any system-related issue**
if you chose to do so.

### Setup your SSH keys on GitHub

So as to be able to clone, pull and push updates to GitLab repositories,
you'll need GitLab to know your identity.
The best way to do so is to [register your SSH keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

1. Generate a new SSH key
2. Add your SSH key to the ssh-agent
3. Add your SSH key to your GitHub account

### Troubleshooting

If you get any error regarding the setup of your work environment,
make sure to follow these steps to try solving your problem:

1. Read the error message,
   there's a good chance it'll give you a **very** accurate explanation of the problem.
2. Search information about your error message.
   On Google, you can surround terms with double quotes (`"`) to search their exact occurence.
   There's a good chance someone else already got the problem.
3. Ask your classmates/friends about your problem.
   There's a good chance they also met similar issues.
4. Check or even ask on [https://stackoverflow.com](StackOverflow).
   There's a good chance someone have answered (or will) your question.
4. Post an issue on this repository,
   detailing *all* the things you have tried and that failed.

## Get and submit homeworks

In order to get the necessary files for your homeworks, and also to submit them,
you will have to fork this repository.
Proceed as follows:

1. Click on the **Fork** button at the top of the repository homepage on GitHub.
   This will create a fork (or copy) if the repository on your own account.
2. Clone **your own** repository (that is the one you just forked) on your machine:
   `git clone git@github.com:<your-username>/outils-formels-modelisation-2018.git`.

This will create a local copy of **your own** repository on your machine.
You can freely work on this local copy,
and update any file you like,
including, of course, those required to complete your homeworks.

The repository will be updated regularly to add new course documents and homeworks,
or fix issues in the homework sources.
You will need to "import" those updates to your own repository by merging them.
In order to do so,
un the following command in your local repository (the one you cloned from your fork):

```bash
git pull https://github.com/cui-unige/outils-formels-modelisation-2018.git master
```

**Never ever** copy the new or update files from the base repository manually into your own!

Submissions must be made by pull request.
Proceed as follows:

1. Test your code!
2. Make sure to commit all your files on your GitHub repository.
   You will be evaluated on the last commit you've made before the deadline of the homework!
3. On GitHub, click on the **New pull request** button.
   This will lead you to a page where you can review your changes.
4. Be sure to select `cui-unige/outils-formels-modelisation-2018`
   and the `<your-github-username>` as the branch.
   Your homework will not be considered submitted if you submit a pull request to another base!
4. If everything looks good, click on the **Create pull request** button.

## Managing your repository (git crashcourse)

Git is a collaboration tool that excels at keeping tracks of changes over time,
and dealing with asynchronous updates.
But this requires a little more discipline than when working on your own without versioning.

### Committing your work

Any update, that is any file modification, addition or deletion,
constitute a modification that has to be put in a commit,
via the commands `git add`, `git mv` and `git rm`, e.g.:

```bash
git add SomeUpdatedFile.swift
git rm SomeRemovedFile.swift
git mv OldName.swift NewName.swift
```

You can see all changes marked for commit with the command `git status`,
which will print something like:

```
On branch master
Your branch is up to date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

  modified:   SomeUpdatedFile.swift
  removed:    SomeRemovedFile.swift
  renamed:    OldName.swift -> NewName.swift

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

  modified:   ModifiedFile.swift

Untracked files:
  (use "git add <file>..." to include in what will be committed)

  UntrackedFile.md
```

When you're satisfied with your changes, you can commit them with the command `git commit`.
Aim at keeping your commits relatively small.
In other words, avoid adding all your changes in a single monolithic commit.

### Keeping your work in sync with the server

Your commits are kept local,
meaning that after `git commit` your changes won't yet be updated on the server (i.e. GitHub).
You can do that with the command `git push`.

If you work on multiple machines,
you can keep your local repositories in sync by pulling the updates from the server.
You can do that with the command `git pull`.

### Dealing with conflicts

If two updates on the same file are made asynchronously in separate commits,
you may encounter a *merge conflict*.

Git will ask you to solve those conflict,
that is editing the files to specify to updates to keep and the ones to discard.
Once your conflict resolved,
add the files you've modified with `git add` and use `git commit` to complete the merge.

If things don't work as expected,
don't panic and read the messages!
**Never ever** force git to accept your changes with the `-f` flag.

## Getting started with Swift

Homeworks and exercises will be written in [Swift](https://swift.org).
You may find a lot of online information about the language,
including:

* The official [language guide](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html),
  the absolute reference for Swift's syntax.
* A more gentle [Introduction to Swift](https://kyouko-taiga.github.io/swift-thoughts/tutorial/)
  that is more suitable for people with less prior programming experience.
* [StackOverflow](https://stackoverflow.com),
  a Q&A forum filled with insider information about Swift and other programming languages.
* [Google](https://google.ch)

Don't hesitate to get information from these sources if you stumble on any problem.

## How you'll be evaluated

Your homework submissions will be mostly evaluated automatically with the tests that accompany them.
There will always be at least 6 tests with each homework,
each one accounting for 1 point.
An additional half point can be added or subtracted from your score,
depending on the quality of your code.

You may run the tests yourself with the command `swift test`.
This system means you can accurately estimate your grade yourself!

You are free and even encouraged to work in group.
However, each student must have a full understanding of the code he/she submits,
and will be invited 2 or 3 times to explain his/her code in private to the assistant.
**Failure to explain properly every single line of the project will be graded 0.**
