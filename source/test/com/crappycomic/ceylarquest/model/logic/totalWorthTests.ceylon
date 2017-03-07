import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable,
    Player
}
import com.crappycomic.ceylarquest.model.logic {
    nodePrice,
    totalWorth
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

// These tests don't do much beyond restate the target function with a different syntax, but that's
// better than nothing, as a double-check of the logic.

test
shared void totalWorthCash() {
    value cash = 123;
    value game = totalWorthGame.with {
        playerCashes = { totalWorthPlayer -> cash };
    };
    
    assertEquals(totalWorth(game, totalWorthPlayer), cash, "Incorrect total worth from cash.");
}

test
shared void totalWorthCombo() {
    value cash = 123;
    value fuelStationCount = 3;
    value ownable = testNodes<Ownable>().first;
    value game = totalWorthGame.with {
        owners = { ownable -> totalWorthPlayer };
        playerCashes = { totalWorthPlayer -> cash };
        playerFuelStationCounts = { totalWorthPlayer -> fuelStationCount };
    };
    value expectedTotalWorth
        = cash + fuelStationCount * game.rules.fuelStationPrice + nodePrice(game, ownable);
    
    assertEquals(totalWorth(game, totalWorthPlayer), expectedTotalWorth,
        "Incorrect total worth from combined assets.");
}

test
shared void totalWorthFuelStationCount() {
    value fuelStationCount = 2;
    value game = totalWorthGame.with {
        playerFuelStationCounts = { totalWorthPlayer -> fuelStationCount };
    };
    
    assertEquals(totalWorth(game, totalWorthPlayer), fuelStationCount * game.rules.fuelStationPrice,
        "Incorrect total worth from fuel stations.");
}

test
shared void totalWorthOwnedNodes() {
    value ownable = testNodes<Ownable, FuelStationable>().first;
    value fuelStationables = testNodes<Ownable&FuelStationable>();
    value game = totalWorthGame.with {
        owners = {
            ownable -> totalWorthPlayer,
            fuelStationables.first -> totalWorthPlayer,
            fuelStationables.last -> totalWorthPlayer
        };
        placedFuelStations = { fuelStationables.first };
    };
    value expectedTotalWorth
        = nodePrice(game, ownable)
            + nodePrice(game, fuelStationables.first)
            + nodePrice(game, fuelStationables.last);
    
    assertEquals(totalWorth(game, totalWorthPlayer), expectedTotalWorth,
        "Incorrect total worth from owned nodes.");
}


test
shared void totalWorthZero() {
    assertEquals(totalWorth(totalWorthGame, totalWorthPlayer), 0,
        "Test game was not set up properly.");
}

Game totalWorthGame = testGame.with {
    playerCashes = { totalWorthPlayer -> 0 };
    playerFuelStationCounts = { totalWorthPlayer -> 0 };
};

Player totalWorthPlayer = testGame.currentPlayer;
