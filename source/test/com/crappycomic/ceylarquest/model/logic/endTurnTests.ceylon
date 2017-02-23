import ceylon.test {
    assertEquals,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    endTurn
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void endTurnTests() {
    value game = testGame.with {
        phase = postLand;
    };
    value result = endTurn(game);
    
    if (is Game result) {
        assertEquals(result.phase, preRoll, "Phase did not update properly.");
        assertEquals(result.currentPlayer, game.nextPlayer,
            "Current player did not update properly.");
    }
    else {
        fail(result.message);
    }
}

test
shared void endTurnWrongPhase() {
    wrongPhaseTest((game) => endTurn(game), postLand);
}
