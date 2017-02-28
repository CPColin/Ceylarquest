import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Ownable,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    canSell,
    canSellNode
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

test
shared void canSellNodeAnyOwned() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        owners = { node -> player };
        phase = postLand;
        playerLocations = { player -> testNodes<Administration>().first };
    };
    
    assertTrue(canSell(game, player), "The test game was not set up properly.");
    
    assertTrue(canSellNode(game, player, null), "Player should be able to sell a node.");
}

test
shared void canSellNodeAnyUnowned() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        phase = postLand;
        playerLocations = { player -> testNodes<Administration>().first };
    };
    
    assertTrue(canSell(game, player), "The test game was not set up properly.");
    
    assertFalse(canSellNode(game, player, null), "Player should not be able to sell a node.");
}

test
shared void canSellNodeOwned() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        owners = { node -> player };
        phase = postLand;
        playerLocations = { player -> testNodes<Administration>().first };
    };
    
    assertTrue(canSell(game, player), "The test game was not set up properly.");
    
    assertTrue(canSellNode(game, player, node), "Player should be able to sell owned node.");
}

test
shared void canSellNodeUnowned() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        phase = postLand;
        playerLocations = { player -> testNodes<Administration>().first };
    };
    
    assertTrue(canSell(game, player), "The test game was not set up properly.");
    
    assertFalse(canSellNode(game, player, node), "Player should not be able to sell unowned node.");
}
