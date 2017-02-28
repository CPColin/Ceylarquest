import com.crappycomic.ceylarquest.model {
    Administration,
    Game,
    Player,
    SettlingDebts
}

"Returns `true` if the state of the given [[game]] allows the given [[player]] to sell possessions.
 That is, the player is either attempting to settle a debt that can't be covered by the player's
 cash-on-hand or the player is on an [[Administration]] node.
 
 This function assumes the rules of the game require the player to be on an [[Administration]] node
 in order to sell a posession. If the rules concerning that functionality evolve, this function
 should, too."
shared Boolean canSell(Game game, Player player) {
    value phase = game.phase;
    
    if (is SettlingDebts phase) {
        value debt = phase.debts.find((debt) => debt.debtor == player);
        
        return game.playerCash(player) < (debt?.amount else 0);
    }
    else {
        return game.playerLocation(player) is Administration;
    }
}
