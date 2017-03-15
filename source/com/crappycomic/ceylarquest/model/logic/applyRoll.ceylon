import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    CostsFuelToLeave,
    Game,
    InvalidMove,
    Result,
    Rolled,
    drawingCard,
    incorrectPhase
}

"Applies the latest [[roll]] to the given [[game]] and returns a Game [[with|Game.with]] the
 [[phase|Game.phase]] updated to reflect the outcome of the roll, which may be that the player is
 now [[drawing a card|drawingCard]] or the player is now
 [[choosing an allowed move|ChoosingAllowedMove]] from those available, depending on the
 [[player's fuel|Game.playerFuel]].
 
 If the player rolled with a [[multiplier|Rolled.multiplier]] because of an action or when bypassing
 a node, this function will never result in drawing a card and will skip the fuel check."
shared Result applyRoll(Game game) {
    value phase = game.phase;
    
    if (!is Rolled phase) {
        return incorrectPhase;
    }
    
    value player = game.currentPlayer;
    value roll = phase.roll;
    
    if (!roll.every((die) => 0 < die <= game.rules.diePips)) {
        return InvalidMove("Invalid roll: ``roll``");
    }
    
    value totalRoll = Integer.sum(roll);
    value multiplier = phase.multiplier;
    value fuel = multiplier exists
        then 0
        else (game.playerLocation(player) is CostsFuelToLeave then totalRoll else 0);
    Integer distance;
    
    if (exists multiplier) {
        // Don't draw cards or check fuel when roll was with a multiplier.
        distance = totalRoll * multiplier;
    }
    else {
        if (game.rules.cardRollType.matches(roll)) {
            // Draw a card.
            return game.with {
                phase = drawingCard;
            };
        }
        else if (fuel > game.playerFuel(player)) {
            // Insufficient fuel to move, so stay put.
            distance = 0;
        }
        else {
            // Proceed normally.
            distance = totalRoll;
        }
    }
    
    value paths = allowedMoves(game.board, game.playerLocation(player), distance);
    // The smaller value is used for cases where the player had to stay put.
    value usedFuel = Integer.smallest(fuel, distance);
    
    return game.with {
        phase = ChoosingAllowedMove(paths, usedFuel);
    };
}
