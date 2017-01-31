shared abstract class Phase()
        of choosingAllowedMove | choosingNodeLostToLeague | choosingNodeWonFromLeague
            | choosingNodeWonFromPlayer | gameOver | postRoll | preLand | preRoll | settlingDebt
            | trading {}

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
