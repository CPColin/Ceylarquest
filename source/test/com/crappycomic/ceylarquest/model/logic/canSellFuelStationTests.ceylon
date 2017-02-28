import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Debt,
    Ownable,
    SettlingDebts,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canSellFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers
}

test
shared void canSellFuelStationNoneToSell() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        playerFuelStationCounts = { player -> 0};
    };
    
    assertFalse(canSellFuelStation(game), "Player can't sell fuel station when none are on-hand.");
}

test shared void canSellFuelStationSettlingDebt() {
    value [debtor, creditor] = testPlayers;
    value game = testGame.with {
        phase = SettlingDebts({ Debt(debtor, 2, creditor) }, postLand);
        playerCashes = { debtor -> 1 };
    };
    
    assertTrue(canSellFuelStation(game, debtor),
        "Should be able to sell fuel station when settling debt.");
}

test shared void canSellFuelStationSettlingDebtNotDebtor() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        phase = SettlingDebts({}, postLand);
    };
    
    assertFalse(canSellFuelStation(game, player),
        "Should not be able to sell fuel station not a debtor.");
}

test shared void canSellFuelStationSettlingDebtTooLow() {
    value [debtor, creditor] = testPlayers;
    value game = testGame.with {
        phase = SettlingDebts({ Debt(debtor, 1, creditor) }, postLand);
        playerCashes = { debtor -> 2 };
    };
    
    assertFalse(canSellFuelStation(game, debtor),
        "Should not be able to sell fuel station when cash can cover debt.");
}

test shared void canSellFuelStationTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        phase = preRoll;
        playerLocations = { player -> node };
    };
    
    assertTrue(canSellFuelStation(game, player),
        "Should be able to sell a fuel station on an Administraion node.");
}

test shared void canSellFuelStationWrongNode() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable, Administration>().first;
    value game = testGame.with {
        phase = preRoll;
        playerLocations = { player -> node };
    };
    
    assertFalse(canSellFuelStation(game, player),
        "Should not be able to sell a fuel station on a non-Administraion node.");
}
