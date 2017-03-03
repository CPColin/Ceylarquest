import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Debt,
    Game,
    Player,
    SettlingDebts,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    canSettleDebtWithCash
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers
}

test
shared void canSettleDebtWithCashInsufficientCash() {
    value game = canSettleDebtWithCashGame.with {
        playerCashes = { canSettleDebtWithCashDebtor -> 0 };
    };
    
    assertFalse(canSettleDebtWithCash(game, canSettleDebtWithCashDebtor),
        "Should not be able to settle debt with insufficient cash.");
}

test
shared void canSettleDebtWithCashNotInDebt() {
    value game = canSettleDebtWithCashGame.with {
        phase = SettlingDebts(empty, postLand);
    };
    
    assertFalse(canSettleDebtWithCash(game, canSettleDebtWithCashDebtor),
        "Can't settle a debt when there's no debt to settle.");
}

test
shared void canSettleDebtWithCashTest() {
    assertTrue(canSettleDebtWithCash(canSettleDebtWithCashGame, canSettleDebtWithCashDebtor));
}

test
shared void canSettleDebtWithCashWrongPhase() {
    value game = canSettleDebtWithCashGame.with {
        phase = postLand;
    };
    
    assertFalse(canSettleDebtWithCash(game, canSettleDebtWithCashDebtor),
        "Can't settle a debt when the phase isn't SettlingDebts.");
}

Player canSettleDebtWithCashCreditor = testPlayers.first;

Player canSettleDebtWithCashDebtor = testPlayers.last;

Game canSettleDebtWithCashGame {
    value game = testGame.with {
        phase = SettlingDebts(
            [ Debt(canSettleDebtWithCashDebtor, 100, canSettleDebtWithCashCreditor) ], postLand);
    };
    
    assertTrue(canSettleDebtWithCash(game, canSettleDebtWithCashDebtor),
        "Test game was not set up properly.");
    
    return game;
}
