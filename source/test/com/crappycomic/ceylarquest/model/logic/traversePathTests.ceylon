import ceylon.test {
    assertEquals,
    assertFalse,
    assertNotEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    Game,
    Ownable,
    Path,
    PreLand,
    Well,
    WellOrbit,
    WellPull
}
import com.crappycomic.ceylarquest.model.logic {
    passesStart,
    traversePath
}

import test.com.crappycomic.ceylarquest.model {
    TestNode,
    testGame,
    testNodes,
    wrongPhaseTest
}

// uses fuel
// resulting phase is PreLand(true/false)
// resulting location is end of path

test
shared void traversePathInsufficientFuel() {
    value player = testGame.currentPlayer;
    value path = [testGame.playerLocation(player)];
    value playerFuel = testGame.playerFuel(player);
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], playerFuel + 1);
    };
    
    assertInvalidMove(traversePath(game, path),
        "Traversing a path with insufficient fuel should not have worked.");
}

test
shared void traversePathNotInPhase() {
    value [node1, node2] = testNodes<Ownable>();
    value path1 = [node1];
    value path2 = [node2];
    
    assertNotEquals(path1, path2, "This test requires two different paths.");
    
    value game = testGame.with {
        phase = ChoosingAllowedMove([path1], 0);
    };
    
    assertInvalidMove(traversePath(game, path2),
        "Traversing path that was not in the phase should not have worked.");
}

test
shared void traversePathPassesStart() {
    value [startNode, endNode] = testNodes<>();
    value path = [
        startNode,
        testGame.board.start,
        endNode
    ];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = testGame.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertTrue(passesStart(game.board, path), "Path needs to pass Start.");
    
    value result = traversePath(game, path);
    
    if (is Game result) {
        traversePathCheckResult(result, path);
        assertEquals(result.playerCash(player), playerCash + game.rules.passStartCash,
            "Player didn't earn cash for passing Start.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathSkipStart() {
    value path = testNodes<>();
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertFalse(passesStart(game.board, path), "Path incorrectly passes Start.");
    
    value result = traversePath(game, path);
    
    if (is Game result) {
        traversePathCheckResult(result, path);
        assertEquals(result.playerCash(player), playerCash, "Player should not have earned cash.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathToWellOrbit() {
    traversePathToWell(object extends TestNode() satisfies WellOrbit {});
}

test
shared void traversePathToWellPull() {
    traversePathToWell(object extends TestNode() satisfies WellPull {});
}

test
shared void traversePathUsesFuel() {
    value player = testGame.currentPlayer;
    value fuel = 10;
    value path = [testNodes<>().first];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], fuel);
        playerFuels = { player -> fuel };
    };
    value result = traversePath(game, path);
    
    if (is Game result) {
        traversePathCheckResult(result, path);
        assertEquals(result.playerFuel(player), 0, "Player should have used all remaining fuel.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathWithoutAdvancing() {
    value path = [testNodes<>().first];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    
    assertEquals(path.size, 1, "Path needs to be size one for this test to make sense.");
    
    value result = traversePath(game, path);
    
    if (is Game result) {
        traversePathCheckResult(result, path);
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathWrongPhase() {
    object node extends TestNode() {}
    value path = [node];
    
    wrongPhaseTest((game) => traversePath(game, path), ChoosingAllowedMove([path], 0));
}

void traversePathCheckResult(Game result, Path path) {
    value phase = result.phase;
    
    assertTrue(phase is PreLand);
    
    assert (is PreLand phase);
    
    assertEquals(phase.advancedToNode, path.size > 1,
        "Phase.advancedToNode doesn't agree with path length.");
    assertEquals(result.playerLocation(result.currentPlayer), path.last,
        "Player did not end up on expected node.");
}

void traversePathToWell(Well node) {
    value path = [node];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    
    assertInvalidMove(traversePath(game, path),
        "Traversing a path ending on a Well should not have worked.");
}

