import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Debt,
    Node,
    SettlingDebts,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canSell
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers
}

test shared void canSellOnRightNode() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        phase = preRoll; // Any phase but SettlingDebt
        playerLocations = { player -> node };
    };
    
    assertTrue(canSell(game), "Should be able to sell on an Administraion node.");
}

test shared void canSellOnWrongNode() {
    value player = testGame.currentPlayer;
    value node = testNodes<Node, Administration>().first;
    value game = testGame.with {
        phase = preRoll;
        playerLocations = { player -> node };
    };
    
    assertFalse(canSell(game), "Should not be able to sell on a non-Administration node.");
}

test shared void canSellSettlingDebt() {
    value [debtor, creditor] = testPlayers;
    value game = testGame.with {
        phase = SettlingDebts([ Debt(debtor, 2, creditor) ], postLand);
        playerCashes = { debtor -> 1 };
    };
    
    assertTrue(canSell(game), "Should be able to sell when settling debt.");
}

test shared void canSellSettlingDebtNotDebtor() {
    value game = testGame.with {
        phase = SettlingDebts(empty, postLand);
    };
    
    assertFalse(canSell(game), "Should not be able to sell when not a debtor.");
}

test shared void canSellSettlingDebtTooLow() {
    value [debtor, creditor] = testPlayers;
    value game = testGame.with {
        phase = SettlingDebts([ Debt(debtor, 1, creditor) ], postLand);
        playerCashes = { debtor -> 2 };
    };
    
    assertFalse(canSell(game), "Should not be able to sell when cash can cover debt.");
}
