import ceylon.language.meta {
    classDeclaration
}

"Enumerates the possible phases a [[Game]] can be in, which affect what the players can and can't do
 at a given point during play. Code in [[package com.crappycomic.ceylarquest.model.logic]] should,
 at most, advance the phase one step along the (not-yet-drawn) state diagram."
shared abstract class Phase()
        of ChoosingAllowedMove | RollingAgain | choosingNodeLostToLeague | choosingNodeWonFromLeague
            | choosingNodeWonFromPlayer | drawingCard | gameOver | postRoll | preLand | preRoll
            | settlingDebt | trading {
    shared actual String string => classDeclaration(this).name;
}

// TODO: do we want/need [Path+] here?
shared class ChoosingAllowedMove(shared [Path*] paths, Boolean useFuel) extends Phase() {}

shared class RollingAgain(shared Integer multiplier) extends Phase() {}

shared object choosingNodeLostToLeague extends Phase() {}

shared object choosingNodeWonFromLeague extends Phase() {}

shared object choosingNodeWonFromPlayer extends Phase() {}

shared object drawingCard extends Phase() {}

shared object gameOver extends Phase() {}

shared object postRoll extends Phase() {}

shared object preLand extends Phase() {}

shared object preRoll extends Phase() {}

shared object settlingDebt extends Phase() {}

shared object trading extends Phase() {}
