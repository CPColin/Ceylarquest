import ceylon.random {
    DefaultRandom
}

import com.crappycomic.ceylarquest.model {
    Rules
}

shared Integer[] rollDice(Rules rules) {
    value random = DefaultRandom();
    
    return [ for (_ in 0:rules.dieCount) random.nextInteger(rules.diePips) + 1 ];
}
