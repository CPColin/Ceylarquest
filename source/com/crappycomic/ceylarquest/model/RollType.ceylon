"Returns `true` if the given [[Roll]] matches a certain criterion."
shared alias RollType => Boolean(Roll);

"Always returns `true`."
see(`function rollTypeNever`)
shared Boolean rollTypeAlways(Roll roll) {
    return true;
}

"Returns `true` if all the dice are the same."
shared Boolean rollTypeAllMatch(Roll roll) {
    return if (nonempty roll) then roll.every((die) => die == roll.first) else false;
}

"Returns `true` if the roll is the highest that can possibly be rolled."
shared Boolean rollTypeMaximum(Integer diePips)(Roll roll) {
    return roll.every((die) => die == diePips);
}

"Always returns `false`."
see(`function rollTypeAlways`)
shared Boolean rollTypeNever(Roll roll) {
    return false;
}
