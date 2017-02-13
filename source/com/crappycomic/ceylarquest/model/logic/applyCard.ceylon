import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Result,
    postLand
}

"Applies the [[action|Card.action]] of the given [[card]] to the given [[game]]. If the action does
 not change the [[phase|Game.phase]] of the game, the result will use the [[postLand]] phase, to
 indicate that the card consumed the player's turn."
shared Result applyCard(Game game, Card card) {
    value result = card.action(game);
    
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
