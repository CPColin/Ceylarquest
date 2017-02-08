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
    PreLand,
    SettlingDebts,
    collectCash,
    testPlayers
}
import com.crappycomic.ceylarquest.model.logic {
    landOnNode,
    rentFee
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    TestNode,
    testGame,
    wrongPhaseTest
}

test
shared void landOnNodePayRent() {
    value player = testPlayers.first.key;
    value owner = testPlayers.last.key;
    value node = tropicHopBoard.testOwnablePort;
    value game = testGame.with {
        owners = { node -> owner };
        phase = PreLand(false);
        playerLocations = { player -> node };
    };
    value rent = rentFee(game, player, node);
    
    assertTrue(rent > 0, "Rent needs to be positive for this test.");
    
    value result = landOnNode(game, player, node);
    
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
    value player = testPlayers.first.key;
    value cash = 100;
    object testNode extends TestNode("testNode") satisfies ActionTrigger {
        action = collectCash(cash);
    }
    value game = testGame.with {
        phase = PreLand(triggerAction);
    };
    value playerCash = game.playerCash(player);
    value expectedCash = triggerAction then playerCash + cash else playerCash;
    value result = landOnNode(game, player, testNode);
    
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
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testAfterStart;
    
    wrongPhaseTest((game) => landOnNode(game, player, node), PreLand(true));
}
