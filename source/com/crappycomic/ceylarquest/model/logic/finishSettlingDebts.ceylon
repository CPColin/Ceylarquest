import com.crappycomic.ceylarquest.model {
    Game,
    Result,
    SettlingDebts,
    InvalidMove,
    incorrectPhase
}

"Updates the state of the given [[game]] to advance to the appropriate next phase, assuming that all
 outstanding debts have been settled."
shared Result finishSettlingDebts(Game game) {
    value phase = game.phase;
    
    if (!is SettlingDebts phase) {
        return incorrectPhase;
    }
    
    if (!phase.debts.empty) {
        return InvalidMove("Cannot finish settling debts when some are outstanding.");
    }
    
    return game.with {
        phase = phase.nextPhase;
    };
}
