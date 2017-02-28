import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Node,
    Owner,
    Result,
    unowned,
    postLand
}

// TODO: tests

shared Boolean canChooseNode([Node*] allowedNodes, Node? node) {
    if (exists node) {
        return allowedNodes.contains(node);
    }
    else {
        return allowedNodes.empty;
    }
}

shared Result loseNodeToLeague(Game game, Node? node) {
    return chooseNode(game, allowedNodesToLoseOrSell, node, unowned);
}

shared Result winNodeFromLeague(Game game, Node? node) {
    return chooseNode(game, allowedNodesToWinFromLeague, node, game.currentPlayer);
}

shared Result winNodeFromPlayer(Game game, Node? node) {
    return chooseNode(game, allowedNodesToWinFromPlayer, node, game.currentPlayer);
}

Result chooseNode(Game game, [Node*](Game) allowedNodes, Node? node, Owner owner) {
    if (!canChooseNode(allowedNodes(game), node)) {
        return InvalidMove("Chosen node is invalid.");
    }
    
    return game.with {
        owners = if (exists node) then { node -> owner } else null;
        phase = postLand;
    };
}
