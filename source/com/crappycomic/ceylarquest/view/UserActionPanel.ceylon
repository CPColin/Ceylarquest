import com.crappycomic.ceylarquest.model {
    Game,
    Path
}

shared interface UserActionPanel {
    shared formal void showChoosingAllowedMovePanel([Path+] paths, Integer fuel);
    
    shared formal void showDrawingCardPanel(Game game);
    
    shared formal void showPreLandPanel(Game game);
    
    shared formal void showPreRollPanel(Game game);
}
