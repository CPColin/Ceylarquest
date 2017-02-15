import com.crappycomic.ceylarquest.model {
    Game,
    Result,
    SettlingDebts,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

// TODO: don't want to share game, want to pass it to draw()
shared class Controller(shared variable Game game, UserActionPanel userActionPanel,
        Anything() draw) {
    shared void updateGame(Result result) {
        if (is Game result) {
            game = result;
            
            value phase = game.phase;
            
            // TODO: temporary, for testing
            if (is SettlingDebts phase) {
                game = game.with {
                    phase = postLand;
                };
            }
            
            if (!userActionPanel.showPhase(game)) {
                // Just advance to the next player if we don't have a case for the current phase yet.
                game = game.with {
                    currentPlayer = game.nextPlayer;
                    phase = preRoll;
                };
                
                userActionPanel.showPhase(game);
            }
            
            draw();
        }
        else {
            userActionPanel.showError(result.message);
        }
    }
}
