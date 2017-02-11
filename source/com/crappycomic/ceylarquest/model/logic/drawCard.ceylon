import ceylon.random {
    randomize
}

import com.crappycomic.ceylarquest.model {
    DrewCard,
    Game,
    Result,
    drawingCard,
    incorrectPhase
}

"Draws a [[com.crappycomic.ceylarquest.model::Card]] from the
 [[deck|com.crappycomic.ceylarquest.model::Board.cards]] and returns the given [[game]] with its
 [[phase|Game.phase]] altered to be [[DrewCard]]."
shared Result drawCard(Game game) {
    if (game.phase != drawingCard) {
        return incorrectPhase;
    }
    
    value card = randomize(game.board.cards).first;
    
    assert (exists card);
    
    return game.with {
        phase = DrewCard(card);
    };
}
