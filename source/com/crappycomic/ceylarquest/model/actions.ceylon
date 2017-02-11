import com.crappycomic.ceylarquest.model.logic {
    findShortestPath
}

"Something that can happen when a [[Card]] is drawn. These actions may cause the
 [[phase|Game.phase]] of the [[Game]] to change and could even
 [[eliminate the current player|currentPlayerEliminated]] from the game."
shared alias CardAction => Result(Game, Player);

"Something that can happen when a [[Node]] is landed on. These actions may _not_ cause the
 [[phase|Game.phase]] of the [[Game]] to change."
shared alias NodeAction => Game(Game, Player);

// TODO: need tests

// TODO: test for advancing past start
shared Result advanceToNode(Integer fuel, Node node)(Game game, Player player) 
    => checkFuel(game, player, fuel)
        then game.with {
            phase = ChoosingAllowedMove(
                [findShortestPath(game.board, game.playerLocation(player), node)], fuel);
        }
        else eliminatePlayerInsufficientFuel(game);

shared Game collectCash(Integer amount)(Game game, Player player)
    => game.with {
        playerCashes = { player -> game.playerCash(player) + amount };
    };

shared Game collectCashAndRollAgain(Integer amount)(Game game, Player player)
    => game.with {
        phase = preRoll; // Using preRoll instead of RollingAgain so card and fuel checks happen.
        playerCashes = { player -> game.playerCash(player) + amount };
    };

shared Game collectFuelStation(Integer amount)(Game game, Player player)
    => let (fuelStations = smallest(amount, game.fuelStationsRemaining))
        if (fuelStations > 0)
        then game.with {
            playerFuelStationCounts
                = { player -> game.playerFuelStationCount(player) + fuelStations };
        }
        else game; // TODO: with message saying no fuel station was available

shared Game loseDisputeWithLeague(Game game, Player player)
    => game.with {
        phase = choosingNodeLostToLeague;
    };

shared Game rollWithMultiplier(Integer multiplier)(Game game, Player player)
    => checkFuel(game, player, multiplier)
        then game.with {
            phase = RollingWithMultiplier(multiplier);
        }
        else eliminatePlayerInsufficientFuel(game);

shared Result useFuel(Integer amount)(Game game, Player player)
    => checkFuel(game, player, amount)
        then game.with {
            playerFuels = { player -> game.playerFuel(player) - amount };
        }
        else eliminatePlayerInsufficientFuel(game);

shared Game winDisputeWithLeague(Game game, Player player)
    => game.with {
        phase = choosingNodeWonFromLeague;
    };

shared Game winDisputeWithPlayer(Game game, Player player)
    => game.with {
        phase = choosingNodeWonFromPlayer;
    };

Boolean checkFuel(Game game, Player player, Integer fuel)
    => game.playerFuel(player) >= fuel;

Game eliminatePlayerInsufficientFuel(Game game)
    => game.with {
        phase = currentPlayerEliminated;
        // TODO: modify activePlayers here? or later?
    };
