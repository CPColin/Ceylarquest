import com.crappycomic.ceylarquest.model {
    Game,
    Player
}
import com.crappycomic.ceylarquest.model.logic {
    totalWorth
}

shared interface PlayerInfoPanel {
    shared {String*} strings(Game game, Player player)
        => game.activePlayers.contains(player)
            then {
                "Cash: $``format(game.playerCash(player))``",
                "``game.board.strings.fuel``: ``game.playerFuel(player)`` \
                 ``pluralize(game.board.strings.fuelUnit, game.playerFuel(player))``",
                "``game.board.strings.fuelStation``s: ``game.playerFuelStationCount(player)``",
                "Total Worth: $``format(totalWorth(game, player))``"
            }
            else { "Resigned" };
    
    shared formal void updatePanel(Game game);
}
