import ceylon.test {
    assertFalse,
    assertTrue,
    fail,
    test,
    assertEquals
}

import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Ownable,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canChooseNode,
    chooseNode
}

import test.com.crappycomic.ceylarquest.model {
    TestNode,
    testGame,
    testNodes,
    testPlayers
}

test
shared void canChooseNodeEmptyNonNull() {
    assertFalse(canChooseNode([], object extends TestNode() {}),
        "Cannot choose a node when no node is allowed.");
}

test
shared void canChooseNodeEmptyNull() {
    assertTrue(canChooseNode([], null),
        "Should be allowed to choose no node when no node is allowed.");
}

test
shared void canChooseNodeNonEmptyNull() {
    assertFalse(canChooseNode(testNodes<Node>(), null),
        "Cannot choose no node when some are allowed.");
}

test
shared void canChooseNodeNonEmptyRightNode() {
    value ownables = testNodes<Ownable>();
    value ownable = ownables.first;
    
    assertTrue(canChooseNode(ownables, ownable),
        "Should be allowed to choose a node that was in the list.");
}

test
shared void canChooseNodeNonEmptyWrongNode() {
    value ownables = testNodes<Ownable>();
    value nonOwnable = testNodes<Node, Ownable>().first;
    
    assertFalse(canChooseNode(ownables, nonOwnable),
        "Cannot choose node that was not in the list.");
}

test
shared void chooseNodeNonNull() {
    value player = testPlayers.first;
    value result = chooseNode(chooseNodeGame, chooseNodeOwnableNodes, chooseNodeNode, player);
    
    if (is Game result) {
        assertEquals(result.owner(chooseNodeNode), player, "Player should own chosen node.");
        assertEquals(result.phase, postLand, "Phase should be post-land after choosing a node.");
    }
    else {
        fail(result.message);
    }
}

test
shared void chooseNodeNull() {
    value player = testPlayers.first;
    value owners = chooseNodeGame.owners;
    value result = chooseNode(chooseNodeGame, chooseNodeNoNodes, null, player);
    
    if (is Game result) {
        assertEquals(result.owners, owners, "Owners should not have changed at all.");
        assertEquals(result.phase, postLand,
            "Phase should be post-land after choosing a (no) node.");
    }
    else {
        fail(result.message);
    }
}

[Node*] chooseNodeNoNodes(Game game) {
    return [];
}

[Node*] chooseNodeOwnableNodes(Game game) {
    return testNodes<Ownable>();
}

Game chooseNodeGame {
    value game = testGame.with {
        phase = preRoll;
    };
    
    assertTrue(canChooseNode(chooseNodeOwnableNodes(game), chooseNodeNode));
    
    return game;
}

Node chooseNodeNode = testNodes<Ownable>().first;
