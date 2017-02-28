import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Ownable,
    unowned
}

"Returns all nodes that are owned by the current player."
shared [Node*] allowedNodesToLoseOrSell(Game game) {
    return let (player = game.currentPlayer) [
        for (node in game.board.nodes.keys)
            if (game.owner(node) == player)
                node
    ];
}

"Returns all unowned nodes."
shared [Node*] allowedNodesToWinFromLeague(Game game) {
    return [
        for (node in game.board.nodes.keys)
            if (node is Ownable)
                if (game.owner(node) == unowned)
                    node
    ];
}

"Returns all owned nodes that are not owned by the current player."
shared [Node*] allowedNodesToWinFromPlayer(Game game) {
    return let (player = game.currentPlayer) [
        for (node in game.board.nodes.keys)
            if (let (owner = game.owner(node)) owner != unowned && owner != player)
                node    
    ];
}
