import ceylon.random {
    DefaultRandom
}

import com.crappycomic.ceylarquest.model {
    CostsFuelToLeave,
    Game,
    Result,
    Roll,
    Rolled,
    RollingWithMultiplier,
    Rules,
    currentPlayerEliminated,
    incorrectPhase,
    preRoll
}

"Performs a random roll of however many dice the given [[rules]] call for and returns the result."
shared Roll roll(Rules rules) {
    value random = DefaultRandom();
    
    return [ for (_ in 0:rules.dieCount) random.nextInteger(rules.diePips) + 1 ];
}

"Performs a [[roll]] of the dice and updates the state of the given [[game]] with the result."
shared Result rollDice(Game game) {
    value phase = game.phase;
    
    if (phase != preRoll && !phase is RollingWithMultiplier) {
        return incorrectPhase;
    }
    
    value player = game.currentPlayer;
    
    if (game.playerLocation(player) is CostsFuelToLeave
            && game.playerFuel(player) < game.rules.dieCount) {
        return game.with {
            phase = currentPlayerEliminated;
        };
    }
    
    return game.with {
        phase = Rolled(roll(game.rules),
            if (is RollingWithMultiplier phase) then phase.multiplier else null);
    };
}
