import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Rolled,
    RollingWithMultiplier,
    Rules,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    roll,
    rollDice
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void rollTest() {
    value count = 100;
    
    object rules extends Rules() {
        dieCount = count;
    }
    
    value result = roll(rules);
    
    assertEquals(result.size, count, "Incorrect number of dice.");
    assertTrue(result.every((die) => 0 < die <= rules.diePips),
        "At least one die was out of range.");
}

test
shared void rollDiceNoMultiplier() {
    value game = testGame.with {
        phase = preRoll;
    };
    value result = rollDice(game);
    
    if (is Game result) {
        assertTrue(result.phase is Rolled, "Phase should be Rolled.");
    }
    else {
        fail(result.message);
    }
}

test
shared void rollDiceWithMultiplier() {
    value multiplier = 2;
    value game = testGame.with {
        phase = RollingWithMultiplier(multiplier);
    };
    value result = rollDice(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is Rolled, "Phase should be Rolled.");
        
        assert(is Rolled phase);
        
        assertEquals(phase.multiplier, multiplier, "Resulting multiplier was incorrect.");
    }
    else {
        fail(result.message);
    }
}

test
shared void rollDiceWrongPhase() {
    wrongPhaseTest((game) => rollDice(game), preRoll, RollingWithMultiplier(1));
}
