import ceylon.test {
    assertNotEquals
}

import com.crappycomic.ceylarquest.model {
    Player
}

"Provides a pair of [[Player]] instances for testing. They are guaranteed to be different from each
 other, but are otherwise entirely ordinary."
shared Player[2] testPlayers {
    value player1 = testPlayerNames.first.key;
    value player2 = testPlayerNames.last.key;
    
    assertNotEquals(player1, player2, "This function requires two different players.");
    
    return [player1, player2];
}
