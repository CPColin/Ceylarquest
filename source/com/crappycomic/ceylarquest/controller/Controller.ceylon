import com.crappycomic.ceylarquest.model {
    Game,
    Result
}
import com.crappycomic.ceylarquest.view {
    PlayerInfoPanel,
    UserActionPanel
}

shared class Controller(variable Game game,
        UserActionPanel<out Anything, out Anything> userActionPanel,
        [PlayerInfoPanel*] playerInfoPanels,
        Anything(Game) draw) {
    shared void updateGame(Result result = game) {
        if (is Game result) {
            game = result;
            
            playerInfoPanels.each((playerInfoPanel) => playerInfoPanel.updatePanel(game));
            userActionPanel.showPhase(game);
            
            draw(game);
        }
        else {
            userActionPanel.showError(result.message);
        }
    }
}
