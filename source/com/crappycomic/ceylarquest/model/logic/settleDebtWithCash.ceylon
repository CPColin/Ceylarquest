import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Player,
    Result,
    SettlingDebts
}

"Updates the state of the given [[game]] to have the given [[player]] settle their current debt
 using cash."
shared Result settleDebtWithCash(Game game, Player player) {
    if (!canSettleDebtWithCash(game, player)) {
        return InvalidMove("``game.playerName(player)`` may not settle debt with cash.");
    }
    
    value phase = game.phase;
    
    assert (is SettlingDebts phase);
    
    value debt = phase.debts.find((debt) => debt.debtor == player);
    
    assert (exists debt);
    
    return game.with {
        phase = SettlingDebts([
                for (element in phase.debts)
                    if (element.debtor != player)
                        element
            ],
            phase.nextPhase);
        playerCashes = {
            debt.debtor -> game.playerCash(debt.debtor) - debt.amount,
            debt.creditor -> game.playerCash(debt.creditor) + debt.amount
        };
    };
}
