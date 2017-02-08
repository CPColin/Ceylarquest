import ceylon.test {
    assertEquals,
    assertNotEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void nextPlayerTests() {
    value game1 = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        activePlayers = { testPlayers.first.key, testPlayers.last.key };
    };
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