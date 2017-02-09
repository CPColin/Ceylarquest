import com.crappycomic.ceylarquest.model {
    Game,
    gameOver
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

shared Game testGame = Game {
    board = tropicHopBoard;
    phase = gameOver;
    playerNames = testPlayerNames;
};
