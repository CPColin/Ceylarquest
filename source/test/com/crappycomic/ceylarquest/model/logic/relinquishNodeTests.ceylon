import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Ownable,
    Player
}
import com.crappycomic.ceylarquest.model.logic {
    nodePrice,
    relinquishNode
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers
}

test
shared void relinquishNodeSuccess() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testOwnablePort;
    value game = testGame.with {
        owners = { node -> player };
    };
    value playerCash = game.playerCash(player);
    
    assertEquals(game.owner(node), player, "Node isn't owned by the right player.");
    
    value result = relinquishNode(game, player, node, false);
    
    if (is Game result) {
        assertFalse(result.owner(node) is Player, "Node is still owned by somebody.");
        assertEquals(result.playerCash(player), playerCash, "Player's cash changed unexpectedly.");
    }
    else {
        fail(result.message);
    }
}

test
shared void relinquishNodeWrongOwner() {
    value [player, owner] = testPlayers;
    value node = tropicHopBoard.testOwnablePort;
    value game = testGame.with {
        owners = { node -> owner };
    };
    
    assertEquals(game.owner(node), owner, "Node must be owned for this test.");
    
    assertInvalidMove(relinquishNode(game, player, node, false),
        "Relinquishing node owned by somebody else should not have worked.");
}

test
shared void relinquishUnownableNode() {
    value node = tropicHopBoard.testUnownablePort;
    
    assertFalse(node is Ownable, "Node may not be Ownable for this test.");
    
    assertInvalidMove(relinquishNode(testGame, testGame.currentPlayer, node, false),
        "Relinquishing unownable node should not have worked.");
}

test
suppressWarnings("redundantNarrowing") // Double-checking the node is Ownable
shared void relinquishUnownedNode() {
    value node = tropicHopBoard.testOwnablePort;
    
    assertTrue(node is Ownable, "Node must be Ownable for this test.");
    
    assertInvalidMove(relinquishNode(testGame, testGame.currentPlayer, node, false),
        "Relinquishing unowned node should not have worked.");
}

test
shared void sellNodeSuccess() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testOwnablePort;
    value game = testGame.with {
        owners = { node -> player };
    };
    value playerCash = game.playerCash(player);
    
    assertEquals(game.owner(node), player, "Node isn't owned by the right player.");
    
    value result = relinquishNode(game, player, node, true);
    
    if (is Game result) {
        assertFalse(result.owner(node) is Player, "Node is still owned by somebody.");
        assertEquals(result.playerCash(player), playerCash + nodePrice(game, node),
            "Player wasn't compensated for selling node.");
    }
    else {
        fail(result.message);
    }
}
