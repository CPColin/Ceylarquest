import ceylon.test {
    assertEquals,
    assertNotEquals,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard
}

import test.com.crappycomic.ceylarquest.model {
    testGame
}

"Verifies that applying a card that does not change the [[phase of the game|Game.phase]] results in
 the game having the [[postLand]] phase, because the card consumed the player's turn."
test
shared void applyCardNoPhaseChange() {
    assertNotEquals(testGame.phase, postLand);
    
    value card = Card("No phase change", (game, player) => game);
    value result = applyCard(testGame, card);
    
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

    assertNotEquals(testGame.phase, phase);
    
    value card = Card("Phase change", (game, player) => game.with { phase = phase; });
    value result = applyCard(testGame, card);
    
    if (is Game result) {
        assertEquals(result.phase, phase);
    }
    else {
        fail(result.message);
    }
}
