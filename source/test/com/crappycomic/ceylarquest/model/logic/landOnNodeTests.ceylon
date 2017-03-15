import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Debt,
    Game,
    Ownable,
    PreLand,
    SettlingDebts,
    collectCash
}
import com.crappycomic.ceylarquest.model.logic {
    landOnNode,
    rentFee
}

import test.com.crappycomic.ceylarquest.model {
    TestNode,
    testGame,
    testNodes,
    testPlayers,
    wrongPhaseTest
}

test
shared void landOnNodePayRent() {
    value [player, owner] = testPlayers;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        currentPlayer = player;
        owners = { node -> owner };
        phase = PreLand(false);
        playerLocations = { player -> node };
    };
    value rent = rentFee(game, player, node);
    
    assertTrue(rent > 0, "Rent needs to be positive for this test.");
    
    value result = landOnNode(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is SettlingDebts, "Phase should have become SettlingDebts.");
        
        if (is SettlingDebts phase) {
            value debts = phase.debts.sequence();
            
            assertEquals(debts, [Debt(player, rent, owner)], "Unexpected debts.");
        }
    }
    else {
        fail(result.message);
    }
}

test
shared void landOnNodeWithTriggeringAction() {
    landOnNodeMaybeTriggeringAction(true);
}

test
shared void landOnNodeWithoutTriggeringAction() {
    landOnNodeMaybeTriggeringAction(false);
}

void landOnNodeMaybeTriggeringAction(Boolean triggerAction) {
    value cash = 100;
    object testNode extends TestNode() satisfies ActionTrigger {
        action = collectCash(cash);
    }
    value game = testGame.with {
        phase = PreLand(triggerAction);
    };
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    value expectedCash = triggerAction then playerCash + cash else playerCash;
    value result = landOnNode(game, testNode);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), expectedCash,
            "Player's resulting cash was unexpected.");
    }
    else {
        fail(result.message);
    }
}

test
shared void landOnNodeWrongPhase() {
    value node = testNodes<Ownable>().first;
    
    wrongPhaseTest((game) => landOnNode(game, node), PreLand(true));
}
