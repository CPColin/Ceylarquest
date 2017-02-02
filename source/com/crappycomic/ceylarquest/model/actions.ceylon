"Something that can happen when a [[Card]] is drawn. These actions may not cause the
 [[phase|Game.phase]] of the [[Game]] to change and could even cause the player to lose the game."
shared alias CardAction => Result(Game, Player);

"Something that can happen when a [[Node]] is landed on. These actions may not cause the
 [[phase|Game.phase]] of the [[Game]] to change. This includes actions like uing fuel, which may
 knock a player out of the game."
shared alias NodeAction => Game(Game, Player);

shared Result advanceToNode(Node node)(Game game, Player player) {
    return game; // TODO
}

shared Game collectCash(Integer amount)(Game game, Player player)
    => game.with { playerCashes = { player -> game.playerCash(player) + amount }; };

shared Game collectFuelStation(Integer amount)(Game game, Player player)
    => let (fuelStations = smallest(amount, game.fuelStationsRemaining)) if (fuelStations > 0)
        then game.with {
            playerFuelStationCounts = { player -> game.playerFuelStationCount(player) + fuelStations };
        }
        else game; // TODO: with message saying no fuel station was available

shared Game loseDisputeWithLeague(Game game, Player player) {
    return game; // TODO
}

shared Game rollAgain(Integer multiplier)(Game game, Player player) {
    return game; // TODO: separate "roll again" phase
}

shared Game useFuel(Integer amount)(Game game, Player player) {
    return game; // TODO
}

shared Game winDisputeWithLeague(Game game, Player player) {
    return game; // TODO
}

shared Game winDisputeWithPlayer(Game game, Player player) {
    return game; // TODO
}
