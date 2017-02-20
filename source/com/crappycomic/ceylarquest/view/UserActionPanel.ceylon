import com.crappycomic.ceylarquest.model {
    Card,
    ChoosingAllowedMove,
    DrewCard,
    Game,
    Node,
    Ownable,
    Path,
    Player,
    PreLand,
    RollingWithMultiplier,
    SettlingDebts,
    choosingNodeLostToLeague,
    choosingNodeWonFromLeague,
    choosingNodeWonFromPlayer,
    currentPlayerEliminated,
    drawingCard,
    gameOver,
    postLand,
    preRoll,
    trading
}
import com.crappycomic.ceylarquest.model.logic {
    allowedNodesToLoseToLeague,
    allowedNodesToWinFromLeague,
    allowedNodesToWinFromPlayer,
    canPurchaseNode,
    nodePrice
}

shared interface UserActionPanel<Child, ChooseNodeParameter> {
    shared formal Child createApplyCardButton(Game game);
    
    shared formal Child createChooseNodeLostToLeagueButton(Game game,
        ChooseNodeParameter? parameter);
    
    shared formal Child createChooseNodeWonFromLeagueButton(Game game,
        ChooseNodeParameter? parameter);
    
    shared formal Child createChooseNodeWonFromPlayerButton(Game game,
        ChooseNodeParameter? parameter);
    
    shared formal Child createDrawCardButton(Game game);
    
    shared formal Child createEndTurnButton(Game game);
    
    shared formal Child createLandOnNodeButton(Game game);
    
    shared formal Child[] createNodeSelect(Game game, [Node*] nodes,
        Child(Game, ChooseNodeParameter?) createButton);
    
    shared formal void createPanel(String label, Child* children);
    
    shared formal Child createPurchaseNodeButton(Game game, Boolean canPurchaseNode, Integer price);
    
    shared formal Child createRollDiceButton(Game game);
    
    shared formal Child createTraversePathButton(Game game, Path path);
    
    shared void showChoosingAllowedMovePanel(Game game, [Path+] paths) {
        createPanel("``playerName(game)`` must choose a move.",
            *[ for (path in paths) createTraversePathButton(game, path) ]);
    }
    
    shared void showChoosingNodeLostToLeaguePanel(Game game) {
        // TODO: localize "League"
        showChoosingNodePanel(game, "``playerName(game)`` lost a property to the League.",
            allowedNodesToLoseToLeague, createChooseNodeLostToLeagueButton);
    }
    
    shared void showChoosingNodeWonFromLeaguePanel(Game game) {
        // TODO: localize "League"
        showChoosingNodePanel(game, "``playerName(game)`` won a property from the League.",
            allowedNodesToWinFromLeague, createChooseNodeWonFromLeagueButton);
    }
    
    shared void showChoosingNodeWonFromPlayerPanel(Game game) {
        showChoosingNodePanel(game, "``playerName(game)`` won a property from another player.",
            allowedNodesToWinFromPlayer, createChooseNodeWonFromPlayerButton);
    }
    
    shared void showDrawingCardPanel(Game game) {
        createPanel("``playerName(game)`` must draw a card.",
            createDrawCardButton(game));
    }
    
    shared void showDrewCardPanel(Game game, Card card) {
        createPanel("``playerName(game)`` drew \"``card.description``\"",
            createApplyCardButton(game));
    }
    
    shared formal void showError(String message);
    
    shared void showPostLandPanel(Game game) {
        value node = game.playerLocation(game.currentPlayer);
        value price = if (is Ownable node) then nodePrice(game, node) else 0;
        
        createPanel("``playerName(game)`` is at ``nodeName(game, node)``.",
            createPurchaseNodeButton(game, canPurchaseNode(game, node), price),
            createEndTurnButton(game));
    }
    
    shared void showPreLandPanel(Game game) {
        createPanel("``playerName(game)`` has arrived at ``nodeName(game)``.",
            createLandOnNodeButton(game));
    }
    
    shared void showPreRollPanel(Game game) {
        createPanel("``playerName(game)``'s turn!",
            createRollDiceButton(game));
    }
    
    shared String nodeName(Game game, Node node = game.playerLocation(game.currentPlayer)) {
        return node.name;
    }
    
    shared String playerName(Game game, Player player = game.currentPlayer) {
        return game.playerName(player);
    }
    
    // TODO: returns Boolean temporarily so calling code knows if all phases are handled yet
    shared default Boolean showPhase(Game game) {
        value phase = game.phase;
        
        switch (phase)
        case (is ChoosingAllowedMove) {
            showChoosingAllowedMovePanel(game, phase.paths);
        }
        case (is DrewCard) {
            showDrewCardPanel(game, phase.card);
        }
        case (is RollingWithMultiplier) {
            return false; // TODO
        }
        case (is PreLand) {
            showPreLandPanel(game);
        }
        case (is SettlingDebts) {
            return false; // TODO
        }
        case (choosingNodeLostToLeague) {
            showChoosingNodeLostToLeaguePanel(game);
        }
        case (choosingNodeWonFromLeague) {
            showChoosingNodeWonFromLeaguePanel(game);
        }
        case (choosingNodeWonFromPlayer) {
            showChoosingNodeWonFromPlayerPanel(game);
        }
        case (currentPlayerEliminated) {
            return false; // TODO
        }
        case (drawingCard) {
            showDrawingCardPanel(game);
        }
        case (gameOver) {
            return false; // TODO
        }
        case (postLand) {
            showPostLandPanel(game);
        }
        case (preRoll) {
            showPreRollPanel(game);
        }
        case (trading) {
            return false; // TODO
        }
        
        return true;
    }
    
    void showChoosingNodePanel(Game game, String label, [Node*](Game) allowedNodes,
            Child(Game, ChooseNodeParameter?) createButton) {
        value nodes = allowedNodes(game)
            .sort(byIncreasing(Node.name));
        
        createPanel(label,
            *createNodeSelect(game, nodes, createButton));
    }
}
