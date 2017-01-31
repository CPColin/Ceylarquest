import ceylon.language.meta {
    classDeclaration
}
"Enumerates the possible phases a [[Game]] can be in, which affect what the players can and can't do
 at a given point during play."
shared abstract class Phase()
        of choosingAllowedMove | choosingNodeLostToLeague | choosingNodeWonFromLeague
            | choosingNodeWonFromPlayer | gameOver | postRoll | preLand | preRoll | settlingDebt
            | trading {
    shared actual String string {
        value objectValue = classDeclaration(this).objectValue;
        
        assert (exists objectValue);
        
        return objectValue.name;
    }
}

shared object choosingAllowedMove extends Phase() {}

shared object choosingNodeLostToLeague extends Phase() {}

shared object choosingNodeWonFromLeague extends Phase() {}

shared object choosingNodeWonFromPlayer extends Phase() {}

shared object gameOver extends Phase() {}

shared object postRoll extends Phase() {}

shared object preLand extends Phase() {}

shared object preRoll extends Phase() {}

shared object settlingDebt extends Phase() {}

shared object trading extends Phase() {}
