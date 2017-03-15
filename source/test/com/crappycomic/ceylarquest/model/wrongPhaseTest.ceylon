import ceylon.language.meta {
    classDeclaration
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
 result when a [[Game]] with that phase is passed to the given [[action]]. Other phases may be
 allowed and will not be caught by this test; thus, this test enforces a minimal set of allowed
 phases."
shared void wrongPhaseTest(Result(Game) action, Phase+ rightPhases) {
    value disallowedPhaseNames = set {
        for (phase in rightPhases)
            if (action(testGame.with { phase = phase; }) == incorrectPhase)
                classDeclaration(phase).name
    };
    
    // Either the model incorrectly disallowed a phase from the rightPhases parameter or the test
    // should not have passed it.
    assertEquals(disallowedPhaseNames, emptySet, "Some correct phases were incorrectly caught.");
}
