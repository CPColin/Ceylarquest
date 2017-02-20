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

shared class Controller(variable Game game,
        UserActionPanel<out Anything, out Anything> userActionPanel, Anything(Game) draw) {
    shared void updateGame(Result result = game) {
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
            
            draw(game);
        }
        else {
            userActionPanel.showError(result.message);
        }
    }
}
