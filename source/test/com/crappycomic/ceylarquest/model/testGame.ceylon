import com.crappycomic.ceylarquest.model {
    Game,
    gameOver,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard,
    tropicHopRules
}

shared Game testGame = Game {
    board = tropicHopBoard;
    phase = gameOver;
    playerNames = testPlayers;
    rules = tropicHopRules;
};
