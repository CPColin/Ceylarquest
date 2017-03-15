import ceylon.test {
    assertEquals,
    assertNotEquals,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Card,
    DrewCard,
    Game,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

"Verifies that applying a card that does not change the [[phase of the game|Game.phase]] results in
 the game having the [[postLand]] phase, because the card consumed the player's turn."
test
shared void applyCardNoPhaseChange() {
    value card = Card("No phase change", identity);
    value game = testGame.with {
        phase = DrewCard(card);
    };
    
    assertNotEquals(game.phase, postLand);
    
    value result = applyCard(game);
    
    if (is Game result) {
        assertEquals(result.phase, postLand);
    }
    else {
        fail(result.message);
    }
}

"Verifies that applying a card that changes the [[phase of the game|Game.phase]] results in the game
 having the given phase."
test
shared void applyCardPhaseChange() {
    value phase = preRoll;
    value card = Card("Phase change", (game) => game.with { phase = phase; });
    value game = testGame.with {
        phase = DrewCard(card);
    };

    assertNotEquals(game.phase, phase);
    
    value result = applyCard(game);
    
    if (is Game result) {
        assertEquals(result.phase, phase);
    }
    else {
        fail(result.message);
    }
}

test
shared void applyCardWrongPhase() {
    value card = Card("Do nothing", identity);
    
    wrongPhaseTest((game) => applyCard(game), DrewCard(card));
}
