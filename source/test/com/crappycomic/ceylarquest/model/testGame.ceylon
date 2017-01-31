import com.crappycomic.ceylarquest.model {
    Game,
    gameOver,
    testPlayers,
    preRoll
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

Game testGame = Game {
    board = tropicHopBoard;
    phase = gameOver;
    playerNames = testPlayers;
};