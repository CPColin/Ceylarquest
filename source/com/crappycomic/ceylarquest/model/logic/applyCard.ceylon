import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Result,
    postLand
}

// TODO: need tests
shared Result applyCard(Game game, Card card) {
    value result = card.action(game, game.currentPlayer);
    
    if (is Game result) {
        if (result.phase == game.phase) {
            return result.with {
                // If the card didn't change the phase, treat it as a lost turn.
                phase = postLand;
            };
        }
    }
    
    return result;
}
