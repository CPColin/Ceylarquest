import ceylon.test {
    assertEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    RollingWithMultiplier,
    advanceToNode,
    choosingNodeWonFromLeague,
    choosingNodeWonFromPlayer,
    collectCash,
    collectCashAndRollAgain,
    collectFuelStation,
    currentPlayerEliminated,
    preRoll,
    rollWithMultiplier,
    useFuel,
    winDisputeWithLeague,
    winDisputeWithPlayer
}
import com.crappycomic.ceylarquest.model.logic {
    passesStart
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void advanceToNodeTest() {
    value startNode = tropicHopBoard.testAfterStart;
    value endNode = tropicHopBoard.testBeforeStart;
    value fuel = 5;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        playerLocations = { player -> startNode };
    };
    value result = advanceToNode(fuel, endNode)(game);
    value phase = result.phase;
    
    assertTrue(phase is ChoosingAllowedMove, "Unexpected resulting phase.");
    
    assert(is ChoosingAllowedMove phase);
    
    value paths = phase.paths;
    
    assertEquals(paths.size, 1, "Unexpected number of paths in resulting phase.");
    
    assertEquals(paths.first.last, endNode, "Resulting path ended on wrong node.");
    assertEquals(phase.fuel, fuel, "Resulting phase uses incorrect amount of fuel.");
}

test
shared void advanceToNodeEliminationTest() {
    value player = testGame.currentPlayer;
    value fuel = 5;
    value game = testGame.with {
        playerFuels = { player -> fuel - 1 };
    };
    
    assertTrue(game.playerFuel(player) < fuel, "Player has too much fuel for this test.");
    
    value result = advanceToNode(fuel, game.playerLocation(player))(game);
    
    assertEquals(result.phase, currentPlayerEliminated,
        "Resulting phase should be that the current player was eliminated.");
}

test
shared void advanceToNodePassStartTest() {
    value startNode = tropicHopBoard.testBeforeStart;
    value endNode = tropicHopBoard.testAfterStart;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        playerLocations = { player -> startNode };
    };
    value result = advanceToNode(0, endNode)(game);
    value phase = result.phase;
    
    assert (is ChoosingAllowedMove phase);
    
    assertTrue(phase.paths.every((path) => passesStart(tropicHopBoard, path)));
}

test
shared void collectCashTest() {
    value cash = 100;
    value player = testGame.currentPlayer;
    value playerCash = testGame.playerCash(player);
    value result = collectCash(cash)(testGame);
    
    assertEquals(result.playerCash(player), playerCash + cash,
        "Player's cash didn't change by expected amount.");
}

test
shared void collectCashAndRollAgainTest() {
    value cash = 100;
    value player = testGame.currentPlayer;
    value playerCash = testGame.playerCash(player);
    value result = collectCashAndRollAgain(cash)(testGame);
    
    assertEquals(result.playerCash(player), playerCash + cash,
        "Player's cash didn't change by expected amount.");
    assertEquals(result.phase, preRoll, "Resulting phase wasn't preRoll.");
}

test
shared void collectFuelStationTest() {
    value player = testGame.currentPlayer;
    value playerFuelStationCount = testGame.playerFuelStationCount(player);
    value fuelStations = 2;
    value result = collectFuelStation(fuelStations)(testGame);
    
    assertEquals(result.playerFuelStationCount(player), playerFuelStationCount + fuelStations,
        "Player's fuel station count should have increased by ``fuelStations``.");
}

test
shared void collectFuelStationNoneRemainTest() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        playerFuelStationCounts = {
            player -> testGame.playerFuelStationCount(player) + testGame.fuelStationsRemaining
        };
    };
    value playerFuelStationCount = game.playerFuelStationCount(player);
    
    assertEquals(game.fuelStationsRemaining, 0,
        "Fuel stations remaining must be zero for this test.");
    
    value result = collectFuelStation(1)(game);
    
    assertEquals(result.playerFuelStationCount(player), playerFuelStationCount,
        "Player should not have gained a fuel station.");
}

"Verifies that attempting to award more fuel stations than are available results in some, but not
 all of them, actually being awarded."
test
shared void collectFuelStationSomeRemainTest() {
    value player = testGame.currentPlayer;
    value fuelStations = 1;
    value game = testGame.with {
        playerFuelStationCounts = {
            player -> testGame.playerFuelStationCount(player) + testGame.fuelStationsRemaining
                - fuelStations
        };
    };
    value playerFuelStationCount = game.playerFuelStationCount(player);
    
    assertEquals(game.fuelStationsRemaining, fuelStations,
        "Fuel stations remaining must be ``fuelStations`` for this test.");
    
    value result = collectFuelStation(fuelStations * 2)(game);
    
    assertEquals(result.playerFuelStationCount(player), playerFuelStationCount + fuelStations,
        "Player gained incorrect number of fuel stations.");
}

test
shared void loseDisputeWithLeagueTest() {
    value result = winDisputeWithLeague(testGame);
    
    assertEquals(result.phase, choosingNodeWonFromLeague, "Incorrect phase.");
}

test
shared void rollWithMultiplierTest() {
    value multiplier = 5;
    value result = rollWithMultiplier(multiplier)(testGame);
    value phase = result.phase;
    
    assertTrue(phase is RollingWithMultiplier, "Incorrect phase type.");
    
    assert(is RollingWithMultiplier phase);
    
    assertEquals(phase.multiplier, multiplier, "Phase has unexpected multiplier.");
}

test
shared void rollWithMultiplierEliminationTest() {
    value player = testGame.currentPlayer;
    value multiplier = 5;
    value game = testGame.with {
        playerFuels = { player -> multiplier - 1 };
    };
    
    assertTrue(game.playerFuel(player) < multiplier, "Player has too much fuel for this test.");
    
    value result = rollWithMultiplier(multiplier)(game);
    
    assertEquals(result.phase, currentPlayerEliminated,
        "Resulting phase should be that the current player was eliminated.");
}

test
shared void useFuelTest() {
    value player = testGame.currentPlayer;
    value playerFuel = testGame.playerFuel(player);
    value fuel = 5;
    
    assertTrue(playerFuel >= fuel, "Player needs at least ``fuel`` fuel for this test.");
    
    value result = useFuel(fuel)(testGame);
    
    assertEquals(result.playerFuel(player), playerFuel - fuel,
        "Player fuel didn't change by expected amount.");
}

test
shared void useFuelEliminationTest() {
    value player = testGame.currentPlayer;
    value fuel = 5;
    value game = testGame.with {
        playerFuels = { player -> fuel - 1 };
    };
    
    assertTrue(game.playerFuel(player) < fuel, "Player has too much fuel for this test.");
    
    value result = useFuel(fuel)(game);
    
    assertEquals(result.phase, currentPlayerEliminated,
        "Resulting phase should be that the current player was eliminated.");
}

test
shared void winDisputeWithLeagueTest() {
    value result = winDisputeWithLeague(testGame);
    
    assertEquals(result.phase, choosingNodeWonFromLeague, "Incorrect phase.");
}

test
shared void winDisputeWithPlayerTest() {
    value result = winDisputeWithPlayer(testGame);
    
    assertEquals(result.phase, choosingNodeWonFromPlayer, "Incorrect phase.");
}
