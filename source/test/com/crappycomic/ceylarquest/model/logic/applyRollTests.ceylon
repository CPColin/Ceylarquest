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
    RollingWithMultiplier,
    Rules,
    drawingCard,
    incorrectPhase,
    preRoll,
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
    value game = Game {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeAlways;
        };
    };
    value result = applyRoll(game, game.currentPlayer, [1, 2]);
    
    if (is Game result) {
        assertEquals(result.phase, drawingCard, "Phase isn't DrawingCard");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRollingAgainDontCheckFuel() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value game = testGame.with {
        phase = RollingWithMultiplier(1);
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertTrue(game.phase is RollingWithMultiplier,
        "Phase needs to be RollingWithMultiplier for this test.");
    
    value result = applyRoll(game, player, [1, 2]);
    
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
shared void applyRollingAgainDontDrawCard() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value game = Game {
        board = tropicHopBoard;
        phase = RollingWithMultiplier(1);
        playerLocations = { player -> node };
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeAlways;
        };
    };
    
    assertTrue(game.phase is RollingWithMultiplier,
        "Phase needs to be RollingWithMultiplier for this test.");
    
    value result = applyRoll(game, player, [1, 1]);
    
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
shared void applyRollingAgainMultiplier() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testAfterStart;
    value multiplier = 4;
    value game = testGame.with {
        phase = RollingWithMultiplier(multiplier);
        playerLocations = { player -> node };
    };
    
    assertTrue(game.phase is RollingWithMultiplier,
        "Phase needs to be RollingWithMultiplier for this test.");
    
    value roll = [3, 4];
    value totalRoll = roll.fold(0)(plus);
    // This would be (totalRoll * multiplier) exactly, if we were sure of no WellPull nodes.
    value expectedPathSize = totalRoll * (multiplier - 1) + 1;
    value result = applyRoll(game, player, roll);
    
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
        phase = preRoll;
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value result = applyRoll(game, player, [1, 2]);
    
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
        phase = preRoll;
    };
    value result = applyRoll(game, game.currentPlayer, [1, game.rules.diePips + 1]);
    
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
        phase = preRoll;
    };
    value result = applyRoll(game, game.currentPlayer, [0, 1]);
    
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
    value game = Game {
        board = tropicHopBoard;
        phase = preRoll;
        playerLocations = { player -> startNode };
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = rollTypeNever;
        };
    };
    value result = applyRoll(game, player, [1, 1]);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase needs to be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertEquals(phase.paths.size, 1, "Wrong number of allowed paths.");
        
        value paths = phase.paths;
        
        assertEquals(paths.first.first, startNode, "Path didn't start at the right node.");
        assertEquals(paths.first.last, endNode, "Path didn't end at the right node.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRollWrongPhase() {
    wrongPhaseTest((game)
        => applyRoll(game, game.currentPlayer, [0, 0]), preRoll, RollingWithMultiplier(1));
}
