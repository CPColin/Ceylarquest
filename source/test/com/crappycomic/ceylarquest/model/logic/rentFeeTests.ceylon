import ceylon.test {
    assertEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Ownable,
    unowned
}
import com.crappycomic.ceylarquest.model.logic {
    rentFee
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers
}

"Verifies the [[rent fee|rentFee]] is non-zero when a different player owns the node."
test
shared void rentFeeDifferentOwner() {
    value [player, owner] = testPlayers;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        owners = { node -> owner };
    };
    
    assertEquals(game.owner(node), owner, "Owner doesn't own the test node.");
    
    assertTrue(rentFee(game, player, node) > 0,
        "Rent should not be free on node owned by somebody else.");
}

"Verifies the [[rent fee|rentFee]] is zero when the current player owns the node."
test
shared void rentFeeSameOwner() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        owners = { node -> player };
    };
    
    assertEquals(game.owner(node), player, "Player doesn't own the test node.");
    
    assertEquals(rentFee(game, player, node), 0, "Rent should be free on self-owned node.");
}

"Verifies the [[rent fee|rentFee]] is zero when nobody owns the node."
test
shared void rentFeeUnowned() {
    value node = testNodes<Ownable>().first;
    value game = testGame;
    
    assertEquals(game.owner(node), unowned, "Somebody owns the test node.");
    
    assertEquals(rentFee(game, game.currentPlayer, node), 0,
        "Rent should be free on unowned node.");
}
