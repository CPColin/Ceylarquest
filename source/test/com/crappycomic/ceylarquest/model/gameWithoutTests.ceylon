import ceylon.test {
    assertEquals,
    assertFalse,
    assertNotEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    gameOver,
    postLand,
    preRoll
}

"Verifies that the game advances to the next player when the current player is eliminated and
 multiple players remain active."
test
shared void gameWithoutCurrentPlayer() {
    value game = testGame.with {
        phase = postLand;
    };
    value result = game.without(testGame.currentPlayer);
    
    assertEquals(result.phase, preRoll, "Phase should have reset.");
    assertEquals(result.currentPlayer, game.nextPlayer, "Current player should have advanced.");
    assertFalse(result.activePlayers.contains(game.currentPlayer),
        "Current player is still active.");
}

"Verifies that the game advanced to the next player _and_ the resulting phase is [[gameOver]] when
 the current player is eliminated and only one other player remains."
test
shared void gameWithoutCurrentPlayerGameOver() {
    value [player, winner] = testPlayers;
    value game = Game.test {
        board = testGame.board;
        playerNames = testPlayerNames;
        activePlayers = testPlayers;
        currentPlayer = player;
    };
    value result = game.without(player);
    
    assertEquals(result.phase, gameOver, "Phase should be gameOver.");
    assertEquals(result.currentPlayer, winner, "Current player should have advanced.");
    assertEquals(result.activePlayers, set { winner }, "Winner should be sole active player.");
}

"Verifies that the resulting phase is [[gameOver]] when all players are eliminated. This is not
 expected to happen, normally, but lets the logic fail safely."
test
shared void gameWithoutLastPlayer() {
    value player = testGame.currentPlayer;
    value game = Game.test {
        board = testGame.board;
        playerNames = testPlayerNames;
        activePlayers = { player };
    };
    value result = game.without(player);
    
    assertTrue(result.activePlayers.empty, "Active players should be empty.");
    assertEquals(result.phase, gameOver, "Phase should be gameOver.");
}

"Verifies that the resulting phase is [[gameOver]] when the second-to-last player is eliminated."
test
shared void gameWithoutSecondPlace() {
    value [winner, loser] = testPlayers;
    value game = Game.test {
        board = testGame.board;
        playerNames = testPlayerNames;
        activePlayers = testPlayers;
    };
    value result = game.without(loser);
    
    assertEquals(result.activePlayers, set { winner}, "Winner should still be active.");
    assertEquals(result.phase, gameOver, "Phase should be gameOver.");
}

"Verifies that the phase doesn't change when somebody besides the current player leaves the game,
 among other pre- and post-conditions."
test
shared void gameWithoutOtherPlayer() {
    value phase = postLand;
    value game = testGame.with {
        phase = phase;
    };
    value player = game.currentPlayer;
    value loser = game.nextPlayer;
    value playerCount = game.activePlayers.size;
    
    assertTrue(playerCount > 2,
        "This test requires more than two players to be active.");
    assertTrue(game.activePlayers.contains(loser), "The losing player must be active.");
    assertNotEquals(player, loser, "This test requires two different players.");
    
    value result = game.without(loser);
    
    assertFalse(result.activePlayers.contains(loser), "The losing player is still active.");
    assertEquals(result.activePlayers.size, playerCount - 1,
        "Active player count should have decreased by exactly one.");
    assertEquals(result.phase, phase, "Phase should not have changed.");
}
