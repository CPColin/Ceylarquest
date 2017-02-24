import ceylon.test {
    assertEquals,
    assertFalse,
    assertNotEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    ChoosingAllowedMove,
    Game,
    Ownable,
    Well,
    WellOrbit,
    WellPull,
    collectCash
}
import com.crappycomic.ceylarquest.model.logic {
    passesStart,
    traversePath
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    TestNode,
    testGame,
    testNodes,
    testNodesBeforeAndAfterStart,
    wrongPhaseTest
}

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
    value path = [
        testNodesBeforeAndAfterStart.first,
        tropicHopBoard.start,
        testNodesBeforeAndAfterStart.last
    ];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = testGame.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertTrue(passesStart(game.board, path), "Path needs to pass Start.");
    
    value result = traversePath(game, path);
    
    if (is Game result) {
        assertEquals(result.playerLocation(player), path.last,
            "Player didn't end up on the right node.");
        assertEquals(result.playerCash(player), playerCash + game.rules.passStartCash,
            "Player didn't earn cash for passing Start.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathRemainAtActionTrigger() {
    object node extends TestNode() satisfies ActionTrigger {
        action = collectCash(100);
    }
    value path = [node];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    value actionGame = node.action(game);
    
    assertTrue(actionGame.playerCash(player) > playerCash, "Action didn't increase player's cash.");
    
    value result = traversePath(game, path);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), playerCash, "Player should not have earned cash.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathSkipStart() {
    value path = testNodesBeforeAndAfterStart.reversed;
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertFalse(passesStart(game.board, path), "Path incorrectly passes Start.");
    
    value result = traversePath(game, path);
    
    if (is Game result) {
        assertEquals(result.playerLocation(player), path.last,
            "Player didn't end up on the right node.");
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

void traversePathToWell(Well node) {
    value path = [node];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    
    assertInvalidMove(traversePath(game, path),
        "Traversing a path ending on a Well should not have worked.");
}

test
shared void traversePathWrongPhase() {
    object node extends TestNode() {}
    value path = [node];
    
    wrongPhaseTest((game) => traversePath(game, path), ChoosingAllowedMove([path], 0));
}
