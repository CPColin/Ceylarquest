import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    Game,
    InvalidMove,
    Player,
    Result,
    Roll,
    RollingWithMultiplier,
    drawingCard,
    incorrectPhase,
    preRoll
}

"Applies the given [[roll]] to the given [[game]] and returns a Game [[with|Game.with]] the
 [[phase|Game.phase]] updated to reflect the outcome of the roll, which may be that the player is
 now [[drawing a card|drawingCard]] or the player is now
 [[choosing an allowed move|ChoosingAllowedMove]] from those available, depending on the
 [[player's fuel|Game.playerFuel]].
 
 If the player is currently [[rolling with a multiplier|RollingWithMultiplier]] because of an action
 or when bypassing a node, this function will never result in drawing a card and will skip the fuel
 check."
shared Result applyRoll(Game game, Player player, Roll roll) {
    value phase = game.phase;
    
    if (phase != preRoll && !phase is RollingWithMultiplier) {
        return incorrectPhase;
    }
    
    if (!roll.every((die) => 0 < die <= game.rules.diePips)) {
        return InvalidMove("Invalid roll: ``roll``");
    }
    
    value totalRoll = roll.fold(0)(plus);
    Integer distance;
    
    if (is RollingWithMultiplier phase) {
        // Don't draw cards or check fuel when rolling with a multiplier.
        distance = totalRoll * phase.multiplier;
    }
    else {
        if (game.rules.cardRollType(roll)) {
            // Draw a card.
            return game.with {
                phase = drawingCard;
            };
        }
        else if (totalRoll > game.playerFuel(player)) {
            // Insufficient fuel to move, so stay put.
            distance = 0;
        }
        else {
            // Proceed normally.
            distance = totalRoll;
        }
    }
    
    value paths = allowedMoves(game.board, game.playerLocation(player), distance);
    
    return game.with {
        phase = ChoosingAllowedMove(paths, phase is RollingWithMultiplier then 0 else totalRoll);
    };
}
