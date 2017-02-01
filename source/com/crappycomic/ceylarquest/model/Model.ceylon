shared class InvalidMove(shared String message) {}

shared alias Result => Game|InvalidMove;

shared object incorrectPhase extends InvalidMove("Incorrect game phase for requested action.") {}

// TODO: mutators for Game objects
// TODO: state checks

shared Integer defaultFuelStationPrice = 500;

shared Integer defaultPassStartCash = 500;
