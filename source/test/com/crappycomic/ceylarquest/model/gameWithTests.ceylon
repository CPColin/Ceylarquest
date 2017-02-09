import ceylon.test {
    assertEquals,
    assertFalse,
    assertNotEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable,
    Player,
    unowned
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

// These tests aim to make sure Game.with makes only the changes that are passed to it, without
// affecting other players or and nodes.

test
shared void gameWithCurrentPlayer() {
    value gameStart = testGame;
    value playerStart = gameStart.currentPlayer;
    value gameEnd = gameStart.with {
        currentPlayer = gameStart.nextPlayer;
    };
    value playerEnd = gameEnd.currentPlayer;
    
    assertNotEquals(playerEnd, playerStart, "Current player didn't change.");
}

test
shared void gameWithOwnersDecreasing() {
    value [node1, node2] = testNodes<Ownable>();
    value player = testPlayers[0];
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        owners = { node1 -> player, node2 -> player };
    };
    
    assertEquals(gameStart.owner(node1), player, "First node isn't owned by the test player.");
    assertEquals(gameStart.owner(node2), player, "Second node isn't owned by the test player.");
    
    value gameEnd = gameStart.with {
        owners = { node1 -> unowned };
    };
    
    assertFalse(gameEnd.owner(node1) is Player, "First node is still owned.");
    assertTrue(gameEnd.owner(node2) is Player, "Second node should still be owned.");
}

test
shared void gameWithOwnersIncreasing() {
    value [node1, node2] = testNodes<Ownable>();
    value player = testPlayers[0];
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        owners = { node1 -> player };
    };
    
    assertEquals(gameStart.owner(node1), player, "First node isn't owned by the test player.");
    assertEquals(gameStart.owner(node2), unowned, "Second node is owned by somebody.");
    
    value gameEnd = gameStart.with {
        owners = { node2 -> player };
    };
    
    assertTrue(gameEnd.owner(node1) is Player, "First node should still be owned.");
    assertTrue(gameEnd.owner(node2) is Player, "Second node should now be owned.");
}


test
shared void gameWithPlacedFuelStations() {
    value [node1, node2] = testNodes<FuelStationable>();
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        placedFuelStations = { node1 };
    };
    value gameEnd = gameStart.with {
        placedFuelStations = { node2 };
    };
    
    assertTrue(
        gameEnd.placedFuelStations.contains(node1)
            && gameEnd.placedFuelStations.contains(node2),
        "Need to end up with fuel stations on both nodes.");
}

test
shared void gameWithPlayerCashes() {
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        playerCashes = { for (player -> _ in testPlayerNames) player -> 1 };
    };
    value player = gameStart.currentPlayer;
    value gameEnd = gameStart.with {
        playerCashes = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerCash, "cash", player, 0);
}

test
shared void gameWithPlayerFuels() {
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        playerFuels = { for (player -> _ in testPlayerNames) player -> 1 };
    };
    value player = gameStart.currentPlayer;
    value gameEnd = gameStart.with {
        playerFuels = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerFuel, "fuel", player, 0);
}

test
shared void gameWithPlayerFuelStationCounts() {
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        playerFuelStationCounts = { for (player -> _ in testPlayerNames) player -> 1 };
    };
    value player = gameStart.currentPlayer;
    value gameEnd = gameStart.with {
        playerFuelStationCounts = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerFuelStationCount, "fuel station count", player, 0);
}

test
shared void gameWithPlayerLocations() {
    value node1 = tropicHopBoard.testOwnablePort;
    value node2 = tropicHopBoard.testNotFuelSalableOrStationable;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        playerLocations = { for (player -> _ in testPlayerNames) player -> node1 };
    };
    value player = gameStart.currentPlayer;
    value gameEnd = gameStart.with {
        playerLocations = { player -> node2 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerLocation, "location", player, node2);
}

"Verifies that attempts to use a node unknown to the game will be ignored."
test
shared void gameWithUnknownNode() {
    object node extends TestNode() satisfies FuelStationable {}
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
    };
    value player = gameStart.currentPlayer;
    value gameEnd = gameStart.with {
        owners = { node -> player };
        placedFuelStations = { node };
        playerLocations = { player -> node };
    };
    
    assertEquals(gameEnd.owner(node), unowned, "Unknown node shouldn't be owned.");
    assertFalse(gameEnd.placedFuelStation(node), "Unknown node shouldn't have a fuel station.");
    assertEquals(gameEnd.playerLocation(player), tropicHopBoard.start,
        "Player shouldn't be at unknown node.");
}

void checkPlayers<Value>(Game gameStart, Game gameEnd, Value(Player)(Game) attribute,
        String attributeName, Player targetPlayer, Value targetValue) {
    for (player -> _ in testPlayerNames) {
        if (player == targetPlayer) {
            assertEquals(attribute(gameEnd)(player), targetValue,
                "Target player has incorrect ``attributeName``.");
        }
        else {
            assertEquals(attribute(gameEnd)(player), attribute(gameStart)(player),
                "Non-target player's ``attributeName`` changed.");
        }
    }
}
