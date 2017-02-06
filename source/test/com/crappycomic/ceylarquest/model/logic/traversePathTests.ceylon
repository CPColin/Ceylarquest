import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    incorrectPhase,
    preRoll,
    testPlayers
}
import com.crappycomic.ceylarquest.model.logic {
    passesStart,
    traversePath
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void traversePathInsufficientFuel() {
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerFuel = game.playerFuel(player);
    value path = [game.playerLocation(player)];
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
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerCash = game.playerCash(player);
    value path
        = [tropicHopBoard.testBeforeStart, tropicHopBoard.start, tropicHopBoard.testAfterStart];
    
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
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerCash = game.playerCash(player);
    value node = tropicHopBoard.testActionTrigger;
    value actionGame = node.action(game, player);
    
    assertTrue(actionGame.playerCash(player) > playerCash, "Action didn't increase player's cash.");
    
    value path = [node];
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
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerCash = game.playerCash(player);
    value path = [tropicHopBoard.testBeforeStart, tropicHopBoard.testAfterStart];
    
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
shared void traversePathToActionTrigger() {
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = preRoll;
    };
    value playerCash = game.playerCash(player);
    value node = tropicHopBoard.testActionTrigger;
    value action = node.action;
    value actionGame = action(game, player);
    
    assertTrue(actionGame.playerCash(player) > playerCash, "Action didn't increase player's cash.");
    
    value path = [node, node];
    value result = traversePath(game, player, path, 0);
    
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
    value player = testPlayers.first.key;
    value path = [tropicHopBoard.testOwnablePort];
    
    wrongPhaseTest((game) => traversePath(game, player, path, 0), preRoll);
}
