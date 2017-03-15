import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Result,
    SettlingDebts
}

"Updates the state of the given [[game]] to have the first indebted player settle their current debt
 using cash."
shared Result settleDebtWithCash(Game game) {
    if (!canSettleDebtWithCash(game)) {
        return InvalidMove("First indebted player may not settle debt with cash.");
    }
    
    value phase = game.phase;
    
    assert (is SettlingDebts phase);
    
    value debt = phase.debts.first;
    
    assert (exists debt);
    
    return game.with {
        phase = SettlingDebts(phase.debts.rest, phase.nextPhase);
        playerCashes = {
            debt.debtor -> game.playerCash(debt.debtor) - debt.amount,
            debt.creditor -> game.playerCash(debt.creditor) + debt.amount
        };
    };
}
