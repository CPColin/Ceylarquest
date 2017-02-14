import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Ownable,
    unowned
}
import com.crappycomic.ceylarquest.model.logic {
    canPurchaseNode
}

import test.com.crappycomic.ceylarquest.model {
    TestNode,
    testGame,
    testNodes
}

test
shared void canPurchaseNodeAlreadyOwned() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        owners = { node -> player };
        playerCashes = { player -> runtime.maxIntegerValue };
    };
    
    assertFalse(canPurchaseNode(game, node),
        "Node that is already owned should not be purchaseable.");
}

test
shared void canPurchaseNodeInsufficientFunds() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        playerCashes = { player -> 0 };
    };
    
    assertFalse(canPurchaseNode(game, node),
        "Node should not be purchaseable with insufficient funds.");
}

test
shared void canPurchaseNodeNotOwnable() {
    value player = testGame.currentPlayer;
    object node extends TestNode() {}
    value game = testGame.with {
        playerCashes = { player -> runtime.maxIntegerValue };
    };
    
    assertFalse(canPurchaseNode(game, node),
        "Node that is now Ownable should not be purchaseable.");
}

test
shared void canPurchaseNodeTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        playerCashes = { player -> runtime.maxIntegerValue };
    };
    
    assertEquals(game.owner(node), unowned, "Node should be unowned for this test.");
    assertTrue(game.playerCash(player) >= node.price, "Player should be able to afford the node.");
    
    assertTrue(canPurchaseNode(game, node), "Node should be purchaseable.");
}
