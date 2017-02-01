import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    CollectCash,
    Game,
    incorrectPhase,
    preRoll,
    testPlayers,
    traversePath,
    defaultPassStartCash
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void traversePathPassesStart() {
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerCash = game.playerCash(player);
    value path
        = [tropicHopBoard.testBeforeStart, tropicHopBoard.start, tropicHopBoard.testAfterStart];
    
    assertTrue(game.board.passesStart(path), "Path needs to pass Start.");
    
    value result = traversePath(game, player, path);
    
    if (is Game result) {
        assertEquals(result.playerLocation(player), path.last,
            "Player didn't end up on the right node.");
        assertEquals(result.playerCash(player), playerCash + defaultPassStartCash,
            "Player didn't earn cash for passing Start.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathRemainAtActionTrigger() {
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value node = tropicHopBoard.testActionTrigger;
    value action = node.action;
    
    assertTrue(action is CollectCash, "Node action needs to be CollectCash for this test.");
    
    value playerCash = game.playerCash(player);
    value path = [node];
    value result = traversePath(game, player, path);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), playerCash, "Player should not have earned cash.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathSkipStart() {
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerCash = game.playerCash(player);
    value path = [tropicHopBoard.testBeforeStart, tropicHopBoard.testAfterStart];
    
    assertFalse(game.board.passesStart(path), "Path incorrectly passes Start.");
    
    value result = traversePath(game, player, path);
    
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
shared void traversePathToActionTrigger() {
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value node = tropicHopBoard.testActionTrigger;
    value action = node.action;
    
    assertTrue(action is CollectCash, "Node action needs to be CollectCash for this test.");
    
    value playerCash = game.playerCash(player);
    value actionGame = action.perform(game, player);
    
    assertTrue(actionGame.playerCash(player) > playerCash, "Action didn't increase player's cash.");
    
    value path = [node, node];
    value result = traversePath(game, player, path);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), actionGame.playerCash(player),
            "Resulting games didn't match.");
    }
    else {
        fail(result.message);
    }
}

test
shared void traversePathToWell() {
    value player = testPlayers.first.key;
    value path = [tropicHopBoard.testWell];
    value game = testGame.with {
        phase = preRoll;
    };
    value result = traversePath(game, player, path);
    
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
    value player = testPlayers.first.key;
    value path = [tropicHopBoard.testOwnablePort];
    
    wrongPhaseTest((game) => traversePath(game, player, path), preRoll);
}
