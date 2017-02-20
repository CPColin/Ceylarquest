import com.crappycomic.ceylarquest.model {
    Card,
    DrewCard,
    Game,
    Result,
    incorrectPhase,
    postLand
}

"Applies the [[action|Card.action]] of the current [[card|DrewCard.card]] to the given [[game]]. If
 the action does not change the [[phase|Game.phase]] of the game, the result will use the
 [[postLand]] phase, to indicate that the card consumed the player's turn."
shared Result applyCard(Game game) {
    value phase = game.phase;
    
    if (!is DrewCard phase) {
        return incorrectPhase;
    }
    
    value result = phase.card.action(game);
    
    if (result.phase == game.phase) {
        return result.with {
            // If the card didn't change the phase, treat it as a lost turn.
            phase = postLand;
        };
    }
    else {
        return result;
    }
}
