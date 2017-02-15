import com.crappycomic.ceylarquest.model {
    Card,
    ChoosingAllowedMove,
    DrewCard,
    Game,
    Path,
    PreLand,
    drawingCard,
    postLand,
    preRoll
}

shared interface UserActionPanel {
    shared formal void showChoosingAllowedMovePanel(Game game, [Path+] paths, Integer fuel);
    
    shared formal void showDrawingCardPanel(Game game);
    
    shared formal void showDrewCardPanel(Game game, Card card);
    
    shared formal void showError(String message);
    
    shared formal void showPostLandPanel(Game game);
    
    shared formal void showPreLandPanel(Game game);
    
    shared formal void showPreRollPanel(Game game);
    
    // TODO: returns Boolean temporarily so calling code knows if all phases are handled yet
    shared Boolean showPhase(Game game) {
        value phase = game.phase;
        
        switch (phase)
        case (is ChoosingAllowedMove) {
            showChoosingAllowedMovePanel(game, phase.paths, phase.fuel);
        }
        case (is DrewCard) {
            showDrewCardPanel(game, phase.card);
        }
        case (is PreLand) {
            showPreLandPanel(game);
        }
        case (drawingCard) {
            showDrawingCardPanel(game);
        }
        case (postLand) {
            showPostLandPanel(game);
        }
        case (preRoll) {
            showPreRollPanel(game);
        }
        else {
            // TODO: remove this block once the above cases are exhaustive
            return false;
        }
        
        return true;
    }
}
