# Ceylarquest

Ceylarquest is a port of the TropicHop Java code to Ceylon with the following soft goals:

* Practice using Ceylon.
* Rework the logic and structure of the Java code to use more modern idioms, including idempotence, immutability, and other functional programming techniques, as appropriate.
* Write unit tests as the logic is written.
* Attempt to rework the `ServerModel` Java class into a web application that clients can `GET` game state from and `POST` moves to.
* Attempt to create a platform-independent GUI.

## Running the code

This code is, partially, an experiment in cross-platform development, so you can run it as a Java Swing application and as a web server that delivers the code to your browser. To run the code as a Java Swing application, run the `com.crappycomic.ceylarquest.main` module. To run a web server that will deliver the code, run the `com.crappycomic.ceylarquest.www.server` module, then access `localhost:8080/boardDebug.html` in your browser. You'll see some links for debugging the board layout. The "Create Controller" link will start the application and replace these links with buttons that let you play the game.

## Lessons learned

One of the goals of this project is to shake up my normal, Java-flavored, object-oriented coding style by using a language that specifically aims to address some of the shortcomings Java has. I started college in 2000 and have been programming primarily in Java since then. Along the way, I created hundreds of classes that mixed (mutable) state with logic, knew too much about each other, and relied too heavily on global state. Along the way, I rarely wrote any sort of automated test code.

### Unit testing and limiting responsibility

One of my last major pushes at Experts Exchange was to update pieces of the system to support more unit testing; without going into too much detail, aspects of the system were often too closely coupled to isolate and test reliably. I was happy to have the opportunity to design this project, from the ground up, to support unit tests and to have logic that operated independently of other logic. That said, I still had to make a few adjustments to my thinking:

* If a function has a validation step followed by a mutation step, every unit test of the mutation step necessarily has to pass the validation step first. This leads to unnecessary clutter and unexpected behavior in the unit tests. However, if each step were written as its own function, the unit tests of the mutation step get to assume that the validation has already been tested and can, thus, focus on actually testing the mutation logic. For an example of this strategy, see `canCondemnNode()`, `condemnNode()`, and their unit tests.
* I spent a handful of hours worrying too much about what the state diagram of the logic needed to look like and how I was going to keep track of which functions updated the `Game.phase` attribute and in what way. I was stuck trying to design the state diagram from the top down and making no progress actually writing code. Once I finally flipped the problem on its head, I started to make some progress: write the code from the bottom up. Ultimately, it didn't really matter what the whole state diagram looked like, as long as, say, the `endTurn()` function resulted in a state where the next player was ready to begin the next turn.
* Along the same lines as above, on a few occasions, I spent too much time thinking about individual functions and how many things they would need to keep track of and update, before reminding myself that nothing will update anything if I don't actually write some code! I soon got the hang of starting with the parts of the functionality I knew I needed, letting me get that code (and their tests) out of the way right away, making the problem left to solve much smaller.

### Immutable objects and idempotent functions

I admit that I never really "got" what people were saying about immutable objects and idempotent functions. Every time I read something about functional programming (FP), the common refrain was that they were "easier to reason about." I would see that phrase and wonder what was so unreasonable about all the code people were writing, then smugly go back to writing more global-state-updating behemoths. After forcing myself to write my logic _and the unit tests for my logic_, I did gain _some_ appreciation for these FP styles. That is, it's nice that, when writing a unit test, I don't have to worry about configuring a bunch of state before running a test and resetting that state after running it. Within the context of the game logic itself, though, the benefits are less clear, but I'll count the benefits to the unit testing as being worth it already.

One nice lesson that came along with mutability was that it was more clear when a function was trying to do too much. I had been picturing updating the UI to show the new game state every time it changed, similar to how the TropicHop Java code did it. I'd heard a complaint, though, about too much stuff happening at once in the Java application; for example, rolling the dice could result in doubles, which could cause the player to draw a card, which could ask the player to expend more fuel than is available, which could cause the player to lose the game and relinquish all property. This would cause a multiple-second pause in the UI as the client received such a large burst of individual state updates.

In the Ceylon code, I had started to worry about all the things that could happen when a player rolls the dice, as above. With a mutable state object, I probably would have passed the state through various functions, each of which would call various mutators on the object and continue to the next function. With immutable objects, it became clear that each function could, at most, make a single update to the initial state and return the new state; there could be no long chains of logic. This made it more clear that the functions should be smaller and make the smallest possible changes to the state.

### Bugs and the 80/20 rule

The 80/20 rule suggests you're bound to spend 80% of your bug-hunt time hunting for 20% of your bugs. It could also suggest that 20% of your bugs are going to ruin 80% of your program. If a certain bug falls into the latter category, it's perfectly reasonable to attack it until it also falls into the former category. Conversely, if you've encountered a bug that affects 1% of your program or could be worked around after spending 1% of your time on it, you owe it to yourself and your code to file the bug, work around it, and forget about it.

Every developer learns and relearns that lesson many times. (Maybe we spend 80% of our careers learning 20% of that lesson?) I ran into a few weird edge cases where the workaround was relatively simple, but involved making the code more complicated or less elegant. The lesson I relearned was to swallow that tiny bit of pride, file the bug, and come back to it later.

See [ceylon/ceylon#6865](https://github.com/ceylon/ceylon/issues/6865) for an example of a bug I spent too much time on before giving up and [ceylon/ceylon#6881](https://github.com/ceylon/ceylon/issues/6881) and [ceylon/ceylon#6978](https://github.com/ceylon/ceylon/issues/6978) for bugs I filed right away and came back to later. 

## Interesting bits of code

* I really like how the depth-first search code in `findAllPaths()` turned out. Thanks to Ceylon's lack of function overloading, I finally wrote a recursive function that didn't need separate code that sets up the first call to the recursive function. The code went through a couple of iterations before I worked out the right way to combine recursion with Ceylon comprehensions and came up with the elegant (but not "clever"!) solution I ultimately checked in.
* Similarly, I like the breadth-first search code in `findShortestPath()`. I'd implemented it using an iterative algorithm, because I was worried the recursive algorithm would be impossible to read, so it was nice when I gave the recursive algorithm a try and ended up with a clear and concise couple of blocks of code.
* I wrote the `testNodes()` function when I started to notice a bunch of unit tests all needed two nodes of the same type that were guaranteed to be different. A little later, I realized I sometimes needed to guarantee that the two nodes were also _not_ of a certain type. Since Ceylon doesn't have [negation types](https://github.com/ceylon/ceylon/issues/6876), the function takes two type arguments, the first being the type to satisfy and the second being the type to avoid. A few other Ceylon features help out:
    * Ceylon supports fully reified generics, so the types we use when calling the function are available at runtime. If this were Java, we'd have to pass instances of `Class` all over the place and do a bunch of non-intuitive type checks.
    * We can specify default values for the type parameters, allowing code that doesn't need to exclude types to specify only one type parameter and code that only needs `Node` instances to specify no type parameters at all.
    * Since Ceylon has such nice support for intersection and union types, we can have calls like `testNodes<Ownable&FuelSalable, FuelStationable>()` and know we'll get nodes back that are both `Ownable` and `FuelSalable`, but not `FuelStationable`. With calls like `testNodes<Node, FuelSalable|FuelStationable>()` we clearly say that we don't care exactly which nodes we get back, as long as they're neither `FuelSalable` nor `FuelStationable`. That'd all be a _nightmare_ to write in Java!
    * If Ceylon gains negation types (see above GitHib issue), it'll be nice to come back to this code and have the calls look more like this: `testNodes<Ownable&!FuelSalable&!FuelStationable>()`.
* The functions defined in `actions.ceylon` started life as classes, with the various `Node` and `Card` instances creating instances as needed. Each class satisfied an `Action` interface, which declared a `perform()` method. It quickly became clear that I was introducing a bunch of unnecessary boilerplate, so the classes became curried functions and the `Node` and `Card` instances partially applied the functions, instead of creating instances of various classes.
