import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    purchaseNode,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void testPurchaseOwnedNode() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        ownedNodes = {node -> player};
    };
    
    assertTrue(game.ownedNodes.defines(node), "Node is unexpectedly not owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node that was already owned should have failed.");
    }
}

test
shared void testPurchaseUnownableNode() {
    value node = tropicHopBoard.testUnownablePort;
    value player = testPlayers.first.key;
    value game = Game(tropicHopBoard, testPlayers);
    
    assertFalse(game.ownedNodes.defines(node), "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node that was not able to be owned should have failed.");
    }
}

test
shared void testPurchaseUnownedNode() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = Game(tropicHopBoard, testPlayers);
    value playerCash = game.playerCash(player);
    
    assertFalse(game.ownedNodes.defines(node), "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        value owner = result.ownedNodes.get(node);
        
        assertTrue(owner exists);
        
        if (exists owner) {
            assertTrue(owner == player);
        }
        
        assertEquals(result.playerCash(player), playerCash - node.price,
            "Player's cash didn't decrease by the price of the node: ``node.price``.");
    }
    else {
        fail(result.message);
    }
}

test
shared void testPurchaseWithInsufficientFunds() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerCashes = {player -> 0};
    };
    
    assertFalse(game.ownedNodes.defines(node), "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node with insufficient funds should have failed.");
    }
}
