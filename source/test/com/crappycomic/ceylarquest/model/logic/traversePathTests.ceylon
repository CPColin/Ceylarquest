import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    ChoosingAllowedMove,
    Game,
    Well,
    WellOrbit,
    WellPull,
    collectCash,
    incorrectPhase
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
    wrongPhaseTest
}

test
shared void traversePathInsufficientFuel() {
    value player = testGame.currentPlayer;
    value path = [testGame.playerLocation(player)];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value playerFuel = game.playerFuel(player);
    value result = traversePath(game, player, path, playerFuel + 1);
    
    if (is Game result) {
        fail("Traversing a path with insufficient fuel should not have worked.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void traversePathPassesStart() {
    value path
            = [tropicHopBoard.testBeforeStart, tropicHopBoard.start, tropicHopBoard.testAfterStart];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = testGame.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertTrue(passesStart(game.board, path), "Path needs to pass Start.");
    
    value result = traversePath(game, player, path, 0);
    
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
    value actionGame = node.action(game, player);
    
    assertTrue(actionGame.playerCash(player) > playerCash, "Action didn't increase player's cash.");
    
    value result = traversePath(game, player, path, 0);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), playerCash, "Player should not have earned cash.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathSkipStart() {
    value path = [tropicHopBoard.testBeforeStart, tropicHopBoard.testAfterStart];
    value game = testGame.with {
        phase = ChoosingAllowedMove([path], 0);
    };
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertFalse(passesStart(game.board, path), "Path incorrectly passes Start.");
    
    value result = traversePath(game, player, path, 0);
    
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
    value player = game.currentPlayer;
    value result = traversePath(game, player, path, 0);
    
    if (is Game result) {
        fail("Traversing a path ending on a Well should not have worked.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void traversePathWrongPhase() {
    object node extends TestNode() {}
    value path = [node];
    
    wrongPhaseTest((game)
        => traversePath(game, game.currentPlayer, path, 0), ChoosingAllowedMove([path], 0));
}
