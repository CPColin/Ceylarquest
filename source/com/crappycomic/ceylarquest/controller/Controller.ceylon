import com.crappycomic.ceylarquest.model {
    Game,
    Result
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

shared class Controller(variable Game game,
        UserActionPanel<out Anything, out Anything> userActionPanel, Anything(Game) draw) {
    shared void updateGame(Result result = game) {
        if (is Game result) {
            game = result;
            
            userActionPanel.showPhase(game);
            
            draw(game);
        }
        else {
            userActionPanel.showError(result.message);
        }
    }
}
