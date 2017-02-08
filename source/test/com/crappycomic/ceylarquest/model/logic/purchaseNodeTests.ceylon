import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Player,
    incorrectPhase,
    postLand,
    testPlayers
}
import com.crappycomic.ceylarquest.model.logic {
    purchaseNode
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void purchaseOwnedNode() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame.with {
        owners = { node -> player };
        phase = postLand;
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node that was already owned should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void purchaseUnownableNode() {
    value node = tropicHopBoard.testUnownablePort;
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = postLand;
    };
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node that was not able to be owned should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void purchaseUnownedNode() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = postLand;
    };
    value playerCash = game.playerCash(player);
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        value owner = result.owner(node);
        
        assertEquals(owner, player, "Node is owned by the wrong player.");
        
        assertEquals(result.playerCash(player), playerCash - node.price,
            "Player's cash didn't decrease by the price of the node: ``node.price``.");
    }
    else {
        fail(result.message);
    }
}

test
shared void purchaseWithInsufficientFunds() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame.with {
        phase = postLand;
        playerCashes = { player -> 0 };
    };
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node with insufficient funds should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void purchaseNodeWrongPhase() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testOwnablePort;
    
    wrongPhaseTest((game) => purchaseNode(game, player, node), postLand);
}
