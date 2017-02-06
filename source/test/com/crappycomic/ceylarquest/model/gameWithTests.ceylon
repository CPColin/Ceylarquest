import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Debt,
    FuelStationable,
    Game,
    Ownable,
    Player,
    testPlayers,
    unowned
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

// These tests aim to make sure Game.with makes only the changes that are passed to it, without
// affecting other players or and nodes.

test
shared void gameWithDebts() {
    value debtor = testPlayers.first.key;
    value creditor = testPlayers.last.key;
    value debt1 = Debt(debtor, 100, creditor);
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        debts = { debt1 };
    };
    
    assertEquals(gameStart.debts.size, 1, "Starting number of debts is wrong.");
    
    value debt2 = Debt(debtor, 200, creditor);
    value gameEnd = gameStart.with {
        debts = { debt2 };
    };
    value debts = gameEnd.debts;
    
    assertEquals(debts.size, 2, "Ending number of debts is wrong.");
    assertTrue(debts.contains(debt1) && debts.contains(debt2),
        "Didn't find both Debt objects in the Game object.");
}

test
shared void gameWithOwnersDecreasing() {
    value nodes = tropicHopBoard.nodes.keys.narrow<Ownable>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    value player = testPlayers.first.key;
    
    assert (exists node1, exists node2);
    
    assertFalse(node1 == node2, "This test needs two different Ownable nodes.");
    
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
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
    value nodes = tropicHopBoard.nodes.keys.narrow<Ownable>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    value player = testPlayers.first.key;
    
    assert (exists node1, exists node2);
    
    assertFalse(node1 == node2, "This test needs two different Ownable nodes.");
    
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
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
    value nodes = tropicHopBoard.nodes.keys.narrow<FuelStationable>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    
    assert (exists node1, exists node2);
    
    assertFalse(node1 == node2, "This test needs two different FuelStationable nodes.");
    
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
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
    value player = testPlayers.first.key;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerCashes = { for (player -> _ in testPlayers) player -> 1 };
    };
    value gameEnd = gameStart.with {
        playerCashes = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerCash, "cash", player, 0);
}

test
shared void gameWithPlayerFuels() {
    value player = testPlayers.first.key;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerFuels = { for (player -> _ in testPlayers) player -> 1 };
    };
    value gameEnd = gameStart.with {
        playerFuels = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerFuel, "fuel", player, 0);
}

test
shared void gameWithPlayerFuelStationCounts() {
    value player = testPlayers.first.key;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerFuelStationCounts = { for (player -> _ in testPlayers) player -> 1 };
    };
    value gameEnd = gameStart.with {
        playerFuelStationCounts = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerFuelStationCount, "fuel station count", player, 0);
}

test
shared void gameWithPlayerLocations() {
    value player = testPlayers.first.key;
    value node1 = tropicHopBoard.testOwnablePort;
    value node2 = tropicHopBoard.testNotFuelSalableOrStationable;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerLocations = { for (player -> _ in testPlayers) player -> node1 };
    };
    value gameEnd = gameStart.with {
        playerLocations = { player -> node2 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerLocation, "location", player, node2);
}

"Verifies that attempts to use a node unknown to the game will be ignored."
test
shared void gameWithUnknownNode() {
    value player = testPlayers.first.key;
    object node extends TestNode("FuelStationable") satisfies FuelStationable {}
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
    };
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
    for (player -> _ in testPlayers) {
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
