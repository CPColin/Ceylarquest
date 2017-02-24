import ceylon.language.meta {
    classDeclaration
}

"Enumerates the possible phases a [[Game]] can be in, which affect what the players can and can't do
 at a given point during play. Code in [[package com.crappycomic.ceylarquest.model.logic]] should,
 at most, advance the phase one step along the (not-yet-drawn) state diagram."
shared abstract class Phase()
        of ChoosingAllowedMove | DrewCard | PreLand | Rolled | RollingWithMultiplier | SettlingDebts
            | choosingNodeLostToLeague | choosingNodeWonFromLeague | choosingNodeWonFromPlayer
            | currentPlayerEliminated | drawingCard | gameOver | postLand | preRoll {
    shared actual String string => classDeclaration(this).name;
}

shared class ChoosingAllowedMove(shared [Path+] paths, shared Integer fuel) extends Phase() {}

shared class DrewCard(shared Card card) extends Phase() {}

shared class Rolled(shared Roll roll, shared Integer? multiplier) extends Phase() {}

shared class RollingWithMultiplier(shared Integer multiplier) extends Phase() {}

shared class PreLand(shared Boolean advancedToNode) extends Phase() {}

shared class SettlingDebts(shared {Debt*} debts, shared Phase nextPhase) extends Phase() {}

shared object choosingNodeLostToLeague extends Phase() {}

shared object choosingNodeWonFromLeague extends Phase() {}

shared object choosingNodeWonFromPlayer extends Phase() {}

shared object currentPlayerEliminated extends Phase() {}

shared object drawingCard extends Phase() {}

shared object gameOver extends Phase() {}

shared object postLand extends Phase() {}

shared object preRoll extends Phase() {}
