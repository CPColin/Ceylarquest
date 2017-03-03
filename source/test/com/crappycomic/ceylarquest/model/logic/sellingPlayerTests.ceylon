import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    Debt,
    SettlingDebts,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    sellingPlayer
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers
}

test
shared void sellingPlayerOtherPhase() {
    value game = testGame.with {
        phase = postLand;
    };
    
    assertEquals(sellingPlayer(game), game.currentPlayer,
        "With other phase, the selling player should be the current player.");
}

test
shared void sellingPlayerSettlingDebts() {
    value [debtor, creditor] = testPlayers;
    value game = testGame.with {
        currentPlayer = creditor;
        phase = SettlingDebts([ Debt(debtor, 100, creditor) ], postLand);
    };
    
    assertEquals(sellingPlayer(game), debtor,
        "With debts, the selling player should be the first debtor.");
}

test
shared void sellingPlayerSettlingNoDebts() {
    value game = testGame.with {
        phase = SettlingDebts(empty, postLand);
    };
    
    assertEquals(sellingPlayer(game), game.currentPlayer,
        "With no debts, the selling player should be the current player.");
}
