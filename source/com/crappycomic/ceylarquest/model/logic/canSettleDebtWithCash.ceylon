import com.crappycomic.ceylarquest.model {
    Game,
    SettlingDebts
}

"Returns `true` if a debt is currently being settled and the first indebted player has enough cash
 on hand to settle it."
shared Boolean canSettleDebtWithCash(Game game) {
    value phase = game.phase;
    
    if (!is SettlingDebts phase) {
        return false;
    }
    
    value debt = phase.debts.first;
    
    if (!exists debt) {
        return false;
    }
    
    return game.playerCash(debt.debtor) >= debt.amount;
}
