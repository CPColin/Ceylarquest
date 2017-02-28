import com.crappycomic.ceylarquest.model {
    Administration,
    Game,
    Player,
    SettlingDebts
}

"Returns `true` if the state of the given [[game]] allows the given [[player]] to sell a fuel
 station. That is, the player has one to sell and is either attempting to settle a debt that can't
 be covered by the player's cash-on-hand or the player is on an [[Administration]] node."
shared Boolean canSellFuelStation(Game game, Player player = game.currentPlayer) {
    if (game.playerFuelStationCount(player) <= 0) {
        return false;
    }
    
    value phase = game.phase;
    
    if (is SettlingDebts phase) {
        value debt = phase.debts.find((debt) => debt.debtor == player);
        
        return game.playerCash(player) < (debt?.amount else 0);
    }
    else {
        return game.playerLocation(player) is Administration;
    }
}
