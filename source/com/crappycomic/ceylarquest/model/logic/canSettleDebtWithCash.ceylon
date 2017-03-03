import com.crappycomic.ceylarquest.model {
    Game,
    Player,
    SettlingDebts
}

"Returns `true` if a debt is currently being settled by the given [[player]] and the player has
 enough cash on hand to settle it."
shared Boolean canSettleDebtWithCash(Game game, Player player) {
    value phase = game.phase;
    
    if (!is SettlingDebts phase) {
        return false;
    }
    
    value debt = phase.debts.find((debt) => debt.debtor == player);
    
    if (!exists debt) {
        return false;
    }
    
    return game.playerCash(debt.debtor) >= debt.amount;
}
