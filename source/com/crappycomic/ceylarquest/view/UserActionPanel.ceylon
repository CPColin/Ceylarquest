import com.crappycomic.ceylarquest.model {
    Card,
    ChoosingAllowedMove,
    DrewCard,
    Game,
    Node,
    Path,
    Player,
    PreLand,
    RollingWithMultiplier,
    SettlingDebts,
    choosingNodeLostToLeague,
    choosingNodeWonFromLeague,
    choosingNodeWonFromPlayer,
    currentPlayerEliminated,
    drawingCard,
    gameOver,
    postLand,
    preRoll,
    trading
}

shared interface UserActionPanel {
    shared formal void showChoosingAllowedMovePanel(Game game, [Path+] paths, Integer fuel);
    
    shared formal void showChoosingNodeLostToLeaguePanel(Game game);
    
    shared formal void showChoosingNodeWonFromLeaguePanel(Game game);
    
    shared formal void showChoosingNodeWonFromPlayerPanel(Game game);
    
    shared formal void showDrawingCardPanel(Game game);
    
    shared formal void showDrewCardPanel(Game game, Card card);
    
    shared formal void showError(String message);
    
    shared formal void showPostLandPanel(Game game);
    
    shared formal void showPreLandPanel(Game game);
    
    shared formal void showPreRollPanel(Game game);
    
    shared String nodeName(Game game, Node node = game.playerLocation(game.currentPlayer)) {
        return node.name;
    }
    
    shared String playerName(Game game, Player player = game.currentPlayer) {
        return game.playerName(player);
    }
    
    // TODO: returns Boolean temporarily so calling code knows if all phases are handled yet
    shared default Boolean showPhase(Game game) {
        value phase = game.phase;
        
        switch (phase)
        case (is ChoosingAllowedMove) {
            showChoosingAllowedMovePanel(game, phase.paths, phase.fuel);
        }
        case (is DrewCard) {
            showDrewCardPanel(game, phase.card);
        }
        case (is RollingWithMultiplier) {
            return false; // TODO
        }
        case (is PreLand) {
            showPreLandPanel(game);
        }
        case (is SettlingDebts) {
            return false; // TODO
        }
        case (choosingNodeLostToLeague) {
            showChoosingNodeLostToLeaguePanel(game);
        }
        case (choosingNodeWonFromLeague) {
            showChoosingNodeWonFromLeaguePanel(game);
        }
        case (choosingNodeWonFromPlayer) {
            showChoosingNodeWonFromPlayerPanel(game);
        }
        case (currentPlayerEliminated) {
            return false; // TODO
        }
        case (drawingCard) {
            showDrawingCardPanel(game);
        }
        case (gameOver) {
            return false; // TODO
        }
        case (postLand) {
            showPostLandPanel(game);
        }
        case (preRoll) {
            showPreRollPanel(game);
        }
        case (trading) {
            return false; // TODO
        }
        
        return true;
    }
}
