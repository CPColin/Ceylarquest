import com.crappycomic.ceylarquest.model {
    Administration,
    Game,
    SettlingDebts
}

"Returns `true` if the state of the given [[game]] allows the [[selling player|sellingPlayer]] to
 sell possessions. That is, the player is either attempting to settle a debt that can't be covered
 by the player's cash-on-hand or the player is on an [[Administration]] node.
 
 This function assumes the rules of the game require the player to be on an [[Administration]] node
 in order to sell a posession. If the rules concerning that functionality evolve, this function
 should, too."
shared Boolean canSell(Game game) {
    value player = sellingPlayer(game);
    value phase = game.phase;
    
    if (is SettlingDebts phase) {
        value debt = phase.debts.first;
        
        if (exists debt, debt.debtor == player) {
            return game.playerCash(debt.debtor) < debt.amount;
        }
        else {
            return false;
        }
    }
    else {
        return game.playerLocation(player) is Administration;
    }
}
