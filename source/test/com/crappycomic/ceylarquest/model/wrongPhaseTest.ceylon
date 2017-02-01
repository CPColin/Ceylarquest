import ceylon.language.meta.declaration {
    OpenClassType
}
import ceylon.test {
    assertEquals
}

import com.crappycomic.ceylarquest.model {
    Game,
    Phase,
    Result,
    incorrectPhase
}

"Verifies that no phase passed in the [[rightPhases]] parameter produces an [[incorrectPhase]]
 result and every phase not passed produces an [[incorrectPhase]] result when a [[Game]] with that
 phase is passed to the given [[action]].
 
 In this way, we can verify that the game logic code agrees with our unit tests, as far as expected
 phases are concerned."
shared void wrongPhaseTest(Result(Game) action, Phase+ rightPhases) {
    value wrongPhases = set {
        for (caseType in `class Phase`.caseTypes.narrow<OpenClassType>())
            if (exists objectValue = caseType.declaration.objectValue)
                objectValue.apply<Phase>().get()
    } ~ set { rightPhases; };
    
    value disallowedRightPhases = set {
        for (phase in rightPhases)
            if (action(testGame.with { phase = phase; }) == incorrectPhase)
                phase
    };
    
    // Either the model incorrectly disallowed a phase from the rightPhases parameter or the test
    // should not have passed it.
    assertEquals(disallowedRightPhases, emptySet, "Some correct phases were incorrectly caught.");
    
    value uncaughtWrongPhases = set {
        for (phase in wrongPhases)
            if (action(testGame.with { phase = phase; }) != incorrectPhase)
                phase
    };
    
    // Either the model should have checked for this phase or the test should have passed it in the
    // rightPhases parameter.
    assertEquals(uncaughtWrongPhases, emptySet, "Some incorrect phases were not caught.");
}
