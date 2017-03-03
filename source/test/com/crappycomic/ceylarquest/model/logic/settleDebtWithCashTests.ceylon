import ceylon.test {
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Debt,
    Game,
    SettlingDebts,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    canSettleDebtWithCash,
    settleDebtWithCash
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers
}

test
shared void settleDebtWithCashTest() {
    value [debtor, creditor] = testPlayers;
    value amount = 100;
    value game = testGame.with {
        phase = SettlingDebts([ Debt(debtor, amount, creditor) ], postLand);
    };
    
    assertTrue(canSettleDebtWithCash(game), "Test game was not set up properly.");
    
    value result = settleDebtWithCash(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is SettlingDebts, "Phase should still be SettlingDebts.");
        
        assert (is SettlingDebts phase);
        
        assertTrue(phase.debts.empty, "Resulting phase should have no more debts in it.");
    }
    else {
        fail(result.message);
    }
}
