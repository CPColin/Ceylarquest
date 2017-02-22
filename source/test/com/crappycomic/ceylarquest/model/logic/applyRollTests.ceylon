import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    Game,
    Rolled,
    Rules,
    drawingCard,
    incorrectPhase,
    rollTypeAlways,
    rollTypeNever
}
import com.crappycomic.ceylarquest.model.logic {
    applyRoll
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayerNames,
    wrongPhaseTest
}

test
shared void applyRollDrawCard() {
    value game = Game.test {
        board = tropicHopBoard;
        phase = Rolled([1, 2], null);
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeAlways;
        };
    };
    value result = applyRoll(game);
    
    if (is Game result) {
        assertEquals(result.phase, drawingCard, "Phase isn't DrawingCard");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRolledWithMultiplierDontCheckFuel() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value game = testGame.with {
        phase = Rolled([1, 2], 1);
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertTrue(game.phase is Rolled, "Phase needs to be Rolled for this test.");
    
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase should be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertFalse(phase.paths.any((path) => path.last == node), "Player should have moved.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRolledWithMultiplierDontDrawCard() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value game = Game.test {
        board = tropicHopBoard;
        phase = Rolled([1, 1], 1);
        playerLocations = { player -> node };
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeAlways;
        };
    };
    
    assertTrue(game.phase is Rolled, "Phase needs to be Rolled for this test.");
    
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase should be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertFalse(phase.paths.any((path) => path.last == node), "Player should have moved.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRolledWithMultiplier() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value roll = [3, 4];
    value multiplier = 4;
    value game = testGame.with {
        phase = Rolled(roll, multiplier);
        playerLocations = { player -> node };
    };
    
    assertTrue(game.phase is Rolled, "Phase needs to be Rolled for this test.");
    
    value totalRoll = roll.fold(0)(plus);
    // This would be (totalRoll * multiplier) exactly, if we were sure of no WellPull nodes.
    value expectedPathSize = totalRoll * (multiplier - 1) + 1;
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase should be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertTrue(phase.paths.every((path) => path.size > expectedPathSize),
            "Paths aren't long enough.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRollInsufficientFuel() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value game = testGame.with {
        phase = Rolled([1, 2], null);
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase should be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertEquals(phase.paths.size, 1, "Insufficient fuel should result in a single path.");
        assertEquals(phase.paths.first, [node],
            "Insufficient fuel should have kept player from moving.");
    }
    else {
        fail(result.message);
    }
    
}

test
shared void applyRollInvalidRollTooHigh() {
    value game = testGame.with {
        phase = Rolled([1, testGame.rules.diePips + 1], null);
    };
    value result = applyRoll(game);
    
    if (is Game result) {
        fail("Too-high roll should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        assertTrue(result.message.contains("Invalid roll"),
            "Unexpected error message: ``result.message``");
    }
}

test
shared void applyRollInvalidRollZero() {
    value game = testGame.with {
        phase = Rolled([0, 1], null);
    };
    value result = applyRoll(game);
    
    if (is Game result) {
        fail("Zero in roll should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        assertTrue(result.message.contains("Invalid roll"),
            "Unexpected error message: ``result.message``");
    }
}

test
shared void applyRollSuccess() {
    value player = testGame.currentPlayer;
    value startNode = tropicHopBoard.testBeforeStart;
    value endNode = tropicHopBoard.testAfterStart;
    value game = Game.test {
        board = tropicHopBoard;
        currentPlayer = player;
        phase = Rolled([1, 1], null);
        playerLocations = { player -> startNode };
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeNever;
        };
    };
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase needs to be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertEquals(phase.paths.size, 1, "Wrong number of allowed paths.");
        
        value path = phase.paths.first;
        
        assertEquals(path.first, startNode, "Path didn't start at the right node.");
        assertEquals(path.last, endNode, "Path didn't end at the right node.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRollWrongPhase() {
    wrongPhaseTest((game) => applyRoll(game), Rolled([1, 1], 1));
}
