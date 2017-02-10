import ceylon.random {
    DefaultRandom
}

import com.crappycomic.ceylarquest.model {
    Roll,
    Rules
}

"Performs a random roll of however many dice the given [[rules]] call for and returns the result."
shared Roll rollDice(Rules rules) {
    value random = DefaultRandom();
    
    return [ for (_ in 0:rules.dieCount) random.nextInteger(rules.diePips) + 1 ];
}
