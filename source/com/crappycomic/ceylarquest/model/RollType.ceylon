"Enumerates various types of [[Roll]] that may result in certain actions, like drawing a [[Card]]."
shared abstract class RollType of Specific | allMatch | always | never {
    "Matches rolls where all dice have the [[given value|diePips]]."
    shared static class Specific(Integer diePips) extends RollType() {
        description = "``diePips`` on all dice";
        
        matches(Roll roll) => roll.every((die) => die == diePips);
    }
    
    "Matches rolls where all dice have the same value."
    shared static object allMatch extends RollType() {
        description = "the same number on all dice";
        
        matches(Roll roll) => roll.group(identity).size == 1;
    }
    
    "Matches all rolls."
    shared static object always extends RollType() {
        description = "anything";
        
        matches(Roll roll) => true;
    }
    
    "Matches no rolls."
    shared static object never extends RollType() {
        description = "nothing";
        
        matches(Roll roll) => false;
    }
    
    // Classes with static members can't have parameters.
    shared new() {}
    
    "Returns a description of this type of roll."
    shared formal String description;
    
    "Returns `true` if the given roll matches the criteria of this instance."
    shared formal Boolean matches(Roll roll);
}
