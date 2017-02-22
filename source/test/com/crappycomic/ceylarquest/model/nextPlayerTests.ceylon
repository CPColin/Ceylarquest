import ceylon.test {
    assertEquals,
    assertNotEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    Game
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void nextPlayerTests() {
    value game1 = Game.test {
        board = tropicHopBoard;
        playerNames = testPlayerNames;
        activePlayers = testPlayers;
    };
    
    assertEquals(game1.activePlayers.size, 2, "This test requires exactly two active players.");
    
    value game2 = game1.with {
        currentPlayer = game1.nextPlayer;
    };
    value game3 = game2.with {
        currentPlayer = game2.nextPlayer;
    };
    
    assertNotEquals(game1.currentPlayer, game2.currentPlayer,
        "Advancing player once should have resulted in a different player.");
    assertEquals(game1.currentPlayer, game3.currentPlayer,
        "Advancing player twice should have looped back around.");
}
