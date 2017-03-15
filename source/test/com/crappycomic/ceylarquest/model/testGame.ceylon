import com.crappycomic.ceylarquest.model {
    Game,
    gameOver
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

shared Game testGame = Game.test {
    board = tropicHopBoard;
    phase = gameOver;
    playerNames = testPlayerNames;
};
