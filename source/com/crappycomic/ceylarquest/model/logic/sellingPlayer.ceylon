import com.crappycomic.ceylarquest.model {
    Game,
    Player,
    SettlingDebts
}

"Returns the player who is currently considering selling assets."
shared Player sellingPlayer(Game game) {
    value phase = game.phase;
    
    if (is SettlingDebts phase, exists debt = phase.debts.first) {
        return debt.debtor;
    }
    else {
        return game.currentPlayer;
    }
}
