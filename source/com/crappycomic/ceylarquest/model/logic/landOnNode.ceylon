import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Debt,
    Game,
    Node,
    Player,
    PreLand,
    Result,
    SettlingDebts,
    incorrectPhase,
    postLand
}

"Updates the given [[game]] with the result of landing the [[current player|Game.currentPlayer]] on
 the given [[node]]. If the node is an [[ActionTrigger]], the action will fire. If rent is due, the
 updated phase will include the incurred debt."
shared Result landOnNode(variable Game game, Node node = game.playerLocation(game.currentPlayer)) {
    value phase = game.phase;
    
    if (!is PreLand phase) {
        return incorrectPhase;
    }
    
    value player = game.currentPlayer;
    
    if (phase.advancedToNode) {
        if (is ActionTrigger node) {
            game = node.action(game);
        }
    }
    
    value rent = rentFee(game, player, node);
    {Debt*} debts;
    
    if (rent > 0) {
        value owner = game.owner(node);
        
        if (is Player owner) {
            debts = { Debt(player, rent, owner) };
        }
        else {
            debts = {};
        }
    }
    else {
        debts = {};
    }
    
    return game.with {
        phase = SettlingDebts(debts, postLand);
    };
}
