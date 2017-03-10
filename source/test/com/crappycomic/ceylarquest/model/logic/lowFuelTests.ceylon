import ceylon.test {
    assertEquals,
    assertFalse,
    test
}
import com.crappycomic.ceylarquest.model.logic {
    lowFuel
}
import com.crappycomic.ceylarquest.model {
    Game,
    RollType,
    Rules
}
import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayerNames
}

// The function this test covers might not be worth testing, but those are famous last words, so
// here we go!
test
shared void lowFuelTest() {
    value game = Game.test {
        board = testGame.board;
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = RollType.never;
        };
    };
    value player = game.currentPlayer;
    value maximumRoll = game.rules.diePips * game.rules.dieCount;
    
    assertFalse(game.rules.cardRollType.matches([game.rules.diePips].repeat(game.rules.dieCount)),
        "Maximum roll should not draw a card for this test.");
    
    for (fuel in 0..maximumRoll) {
        value fuelGame = game.with {
            playerFuels = { player -> fuel };
        };
        
        assertEquals(lowFuel(fuelGame), fuel <= maximumRoll,
            "Low fuel state didn't match expected state.");
    }
}
