import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Result,
    postLand
}

// TODO: need tests
// TODO: need to apply each action or reduce cards to having just one action
shared Result applyCard(Game game, Card card) {
    value result = card.actions.first(game, game.currentPlayer);
    
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
