import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    CostsFuelToLeave,
    Game,
    Node,
    Rolled,
    RollType,
    Rules,
    drawingCard,
    incorrectPhase
}
import com.crappycomic.ceylarquest.model.logic {
    allowedMoves,
    applyRoll
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayerNames,
    wrongPhaseTest
}

test
shared void applyRollDrawCard() {
    value game = Game.test {
        board = testGame.board;
        phase = Rolled([1, 2], null);
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = RollType.always;
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
    value node = testNodes<CostsFuelToLeave>().first;
    value game = testGame.with {
        phase = Rolled([6, 5], 1);
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
    value game = Game.test {
        board = testGame.board;
        phase = Rolled([1, 1], 1);
        playerNames = testPlayerNames;
        rules = object extends Rules() {
            cardRollType = RollType.always;
        };
    };
    value node = game.playerLocation(game.currentPlayer);
    
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
    value roll = [3, 4];
    value multiplier = 4;
    value game = testGame.with {
        phase = Rolled(roll, multiplier);
    };
    
    assertTrue(game.phase is Rolled, "Phase needs to be Rolled for this test.");
    
    value totalRoll = Integer.sum(roll);
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
    value node = testNodes<CostsFuelToLeave>().first;
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
shared void applyRollNoFuelCost() {
    value player = testGame.currentPlayer;
    value node = testNodes<Node, CostsFuelToLeave>().first;
    value game = testGame.with {
        phase = Rolled([6, 5], null);
        playerLocations = { player -> node };
    };
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase needs to be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertEquals(phase.fuel, 0, "Used fuel should be zero.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRollSuccess() {
    value player = testGame.currentPlayer;
    value node = testNodes<>().first;
    value roll = [3, 4];
    value game = testGame.with {
        phase = Rolled(roll, null);
        playerLocations = { player -> node };
    };
    value paths = allowedMoves(testGame.board, node, Integer.sum(roll));
    value result = applyRoll(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is ChoosingAllowedMove, "Phase needs to be ChoosingAllowedMove.");
        
        assert (is ChoosingAllowedMove phase);
        
        assertEquals(phase.paths, paths, "Allowed paths did not match expected paths.");
    }
    else {
        fail(result.message);
    }
}

test
shared void applyRollWrongPhase() {
    wrongPhaseTest((game) => applyRoll(game), Rolled([1, 1], 1));
}
