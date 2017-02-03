import ceylon.test {
    assertEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Rules
}
import com.crappycomic.ceylarquest.model.logic {
    rollDice
}

test
shared void rollDiceTest() {
    value count = 100;
    
    object rules extends Rules() {
        dieCount = count;
    }
    
    value roll = rollDice(rules);
    
    assertEquals(roll.size, count, "Incorrect number of dice.");
    assertTrue(roll.every((die) => 0 < die <= rules.diePips), "At least one die was out of range.");
}
