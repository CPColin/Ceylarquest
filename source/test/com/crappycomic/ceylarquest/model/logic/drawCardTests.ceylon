import ceylon.test {
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    DrewCard,
    Game,
    drawingCard
}
import com.crappycomic.ceylarquest.model.logic {
    drawCard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void drawCardTest() {
    value game = testGame.with {
        phase = drawingCard;
    };
    value result = drawCard(game);
    
    if (is Game result) {
        value phase = result.phase;
        
        assertTrue(phase is DrewCard, "Phase should be DrewCard.");
        
        assert (is DrewCard phase);
        
        assertTrue(game.board.cards.contains(phase.card), "Returned Card isn't from the deck.");
    }
    else {
        fail(result.message);
    }
}

test
shared void drawCardWrongPhase() {
    wrongPhaseTest((game) => drawCard(game), drawingCard);
}
