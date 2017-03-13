import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Node,
    Owner,
    Result,
    nobody,
    postLand
}

"Returns `true` if the player can choose the given [[node]], based on the given [[allowedNodes]].
 If no node is allowed, the given node must be null. If some nodes are allowed, the given node must
 be one of them."
shared Boolean canChooseNode([Node*] allowedNodes, Node? node) {
    if (exists node) {
        return allowedNodes.contains(node);
    }
    else {
        return allowedNodes.empty;
    }
}

"Updates the state of the given [[game]] to make the given [[node]] owned by the given [[owner]]."
shared Result chooseNode(Game game, [Node*](Game) allowedNodes, Node? node, Owner owner) {
    if (!canChooseNode(allowedNodes(game), node)) {
        return InvalidMove("Chosen node is invalid.");
    }
    
    return game.with {
        owners = if (exists node) then { node -> owner } else null;
        phase = postLand;
    };
}

shared Result loseNodeToLeague(Game game, Node? node) {
    return chooseNode(game, allowedNodesToLoseOrSell(game.currentPlayer), node, nobody);
}

shared Result winNodeFromLeague(Game game, Node? node) {
    return chooseNode(game, allowedNodesToWinFromLeague, node, game.currentPlayer);
}

shared Result winNodeFromPlayer(Game game, Node? node) {
    return chooseNode(game, allowedNodesToWinFromPlayer, node, game.currentPlayer);
}
