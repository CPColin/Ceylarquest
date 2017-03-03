import ceylon.test {
    assertEquals,
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
    finishSettlingDebts
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers,
    wrongPhaseTest
}

test
shared void finishSettlingDebtsOutstanding() {
    value [debtor, creditor] = testPlayers;
    value game = testGame.with {
        phase = SettlingDebts([ Debt(debtor, 100, creditor) ], postLand);
    };
    value result = finishSettlingDebts(game);
    
    assertInvalidMove(result, "Should not have been able to finish settling debts.");
}

test
shared void finishSettlingDebtsTest() {
    value nextPhase = postLand;
    value game = testGame.with {
        phase = SettlingDebts(empty, nextPhase);
    };
    value result = finishSettlingDebts(game);
    
    if (is Game result) {
        assertEquals(result.phase, nextPhase, "Phase did not update properly.");
    }
    else {
        fail(result.message);
    }
}

test
shared void finishSettlingDebtsWrongPhase() {
    wrongPhaseTest((game) => finishSettlingDebts(game), SettlingDebts(empty, postLand));
}
