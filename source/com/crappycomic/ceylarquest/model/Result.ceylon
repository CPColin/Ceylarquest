shared class InvalidMove(shared String message) {}

shared object incorrectPhase extends InvalidMove("Incorrect game phase for requested action.") {}

"The possible results of a mutation of the [[Game]] state."
shared alias Result => Game|InvalidMove;
