import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Rules,
    rollTypeMaximum,
    rollTypeNever
}
import com.crappycomic.ceylarquest.model.logic {
    maximumFuelPerRoll
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayerNames
}

test
shared void maximumFuelPerRollMaximum() {
    value game = Game.test {
        board = testGame.board;
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeMaximum(testGame.rules.diePips);
        };
    };
    value maximumRoll = game.rules.diePips * game.rules.dieCount;
    
    assertEquals(maximumFuelPerRoll(game), maximumRoll - 1,
        "Maximum roll draws a card, so maximum fuel should have been decremented.");
}

test
shared void maximumFuelPerRollNever() {
    value game = Game.test {
        board = testGame.board;
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeNever;
        };
    };
    value maximumRoll = game.rules.diePips * game.rules.dieCount;
    
    assertEquals(maximumFuelPerRoll(game), maximumRoll,
        "Maximum roll does not draw a card, so maximum fuel should have been equal.");
}
