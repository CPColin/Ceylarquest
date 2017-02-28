import com.crappycomic.ceylarquest.model {
    Card,
    ChoosingAllowedMove,
    DrewCard,
    FuelSalable,
    Game,
    Node,
    Ownable,
    Path,
    Player,
    PreLand,
    Roll,
    Rolled,
    RollingWithMultiplier,
    SettlingDebts,
    choosingNodeLostToLeague,
    choosingNodeWonFromLeague,
    choosingNodeWonFromPlayer,
    currentPlayerEliminated,
    drawingCard,
    gameOver,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    allowedNodesToLoseToLeague,
    allowedNodesToWinFromLeague,
    allowedNodesToWinFromPlayer,
    canPlaceFuelStation,
    canPurchaseFuelStation,
    canPurchaseNode,
    canSellFuelStation,
    fuelAvailable,
    fuelFee,
    nodePrice
}

shared interface UserActionPanel<Child, ChooseNodeParameter> {
    shared formal Child createApplyCardButton(Game game);
    
    shared formal Child createApplyRollButton(Game game);
    
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
    
    shared formal Child createPlaceFuelStationButton(Game game, Boolean canPlaceFuelStation);
    
    shared formal Child createPurchaseFuelButton(Game game, Boolean fuelAvailable, Integer price);
    
    shared formal Child createPurchaseFuelStationButton(Game game, Boolean canPurchaseFuelStation,
        Integer price);
    
    shared formal Child createPurchaseNodeButton(Game game, Boolean canPurchaseNode, Integer price);
    
    shared formal Child createResignButton(Game game);
    
    shared formal Child createRollDiceButton(Game game);
    
    shared formal Child createSellFuelStationButton(Game game, Boolean canSellFuelStation,
        Integer price);
    
    shared formal Child createTraversePathButton(Game game, Path path);
    
    shared formal void showError(String message);
    
    shared String applyCardButtonLabel => "OK";
    
    shared String applyRollButtonLabel => "OK";
    
    shared String chooseNodeButtonLabel => "Choose";
    
    shared String chooseNodeNoneAvailableButtonLabel => "None Available";
    
    shared String drawCardButtonLabel => "Draw a Card";
    
    shared String endTurnButtonLabel => "End Turn";
    
    shared String landOnNodeButtonLabel => "Continue";
    
    shared String placeFuelStationButtonLabel(Game game)
        => "Place ``game.board.strings.fuelStationCapitalized``";
    
    shared String purchaseFuelButtonLabel(Game game, Boolean fuelAvailable, Integer price)
        => let (label = game.board.strings.purchaseFuel)
            if (fuelAvailable) then "``label`` ($``price``)" else label;
    
    shared String purchaseFuelStationButtonLabel(Game game, Integer price)
        => "Purchase ``game.board.strings.fuelStationCapitalized`` ($``price``)";
    
    shared String purchaseNodeButtonLabel(Boolean canPurchaseNode, Integer price)
        => canPurchaseNode then "Purchase Property ($``price``)" else "Purchase Property";
    
    shared String resignButtonLabel => "Resign";
    
    shared String rollDiceButtonLabel => "Roll Dice";
    
    shared String sellFuelStationButtonLabel(Game game, Integer price)
        => "Sell ``game.board.strings.fuelStationCapitalized`` ($``price``)";
    
    shared void showChoosingAllowedMovePanel(Game game, [Path+] paths) {
        createPanel("``playerName(game)`` must choose a move.",
            *[ for (path in paths) createTraversePathButton(game, path) ]);
    }
    
    shared void showChoosingNodeLostToLeaguePanel(Game game) {
        showChoosingNodePanel(game,
            "``playerName(game)`` lost a property to the ``game.board.strings.leagueShort``.",
            allowedNodesToLoseToLeague,
            createChooseNodeLostToLeagueButton);
    }
    
    shared void showChoosingNodeWonFromLeaguePanel(Game game) {
        showChoosingNodePanel(game,
            "``playerName(game)`` won a property from the ``game.board.strings.leagueShort``.",
            allowedNodesToWinFromLeague,
            createChooseNodeWonFromLeagueButton);
    }
    
    shared void showChoosingNodeWonFromPlayerPanel(Game game) {
        showChoosingNodePanel(game, "``playerName(game)`` won a property from another player.",
            allowedNodesToWinFromPlayer, createChooseNodeWonFromPlayerButton);
    }
    
    shared void showCurrentPlayerEliminatedPanel(Game game) {
        createPanel("``playerName(game)`` has been eliminated.",
            createResignButton(game));
    }
    
    shared void showDrawingCardPanel(Game game) {
        createPanel("``playerName(game)`` must draw a card.",
            createDrawCardButton(game));
    }
    
    shared void showDrewCardPanel(Game game, Card card) {
        createPanel("``playerName(game)`` drew \"``card.description``\"",
            createApplyCardButton(game));
    }
    
    shared void showGameOverPanel(Game game) {
        value winner = game.activePlayers.first;
        value label
            = if (exists winner) then "``playerName(game, winner)`` wins!" else "Everybody loses!";
        
        createPanel("Game over! ``label``");
    }
    
    shared void showPostLandPanel(Game game) {
        value player = game.currentPlayer;
        value node = game.playerLocation(player);
        
        createPanel("``playerName(game)`` is at ``nodeName(game, node)``.",
            createPurchaseNodeButton(game, canPurchaseNode(game, node),
                if (is Ownable node) then nodePrice(game, node) else 0),
            createPurchaseFuelButton(game, fuelAvailable(game, node),
                if (is FuelSalable node) then fuelFee(game, player, node) else 0),
            createPlaceFuelStationButton(game,
                game.board.nodes.keys.any((node) => canPlaceFuelStation(game, node))),
            createPurchaseFuelStationButton(game, canPurchaseFuelStation(game),
                game.rules.fuelStationPrice),
            createSellFuelStationButton(game, canSellFuelStation(game),
                game.rules.fuelStationPrice),
            createEndTurnButton(game));
    }
    
    shared void showPreLandPanel(Game game) {
        createPanel("``playerName(game)`` has arrived at ``nodeName(game)``.",
            createLandOnNodeButton(game));
    }
    
    shared void showPreRollPanel(Game game) {
        value player = game.currentPlayer;
        value node = game.playerLocation(player);
        
        createPanel("``playerName(game)``'s turn!",
            createPurchaseFuelButton(game, fuelAvailable(game, node),
                if (is FuelSalable node) then fuelFee(game, player, node) else 0),
            createPlaceFuelStationButton(game,
                game.board.nodes.keys.any((node) => canPlaceFuelStation(game, node))),
            createPurchaseFuelStationButton(game, canPurchaseFuelStation(game),
                game.rules.fuelStationPrice),
            createSellFuelStationButton(game, canSellFuelStation(game),
                game.rules.fuelStationPrice),
            createRollDiceButton(game));
    }
    
    shared void showPurchaseFuelPanel(Game game) {
        // TODO
        showError("TODO");
    }
    
    shared void showRolledPanel(Game game, Roll roll, Integer? multiplier) {
        value label = if (exists multiplier)
            then "``playerName(game)`` rolled ``roll`` (x``multiplier``)."
            else "``playerName(game)`` rolled ``roll``.";
        
        createPanel(label,
            createApplyRollButton(game));
    }
    
    shared void showRollingWithMultiplierPanel(Game game, Integer multiplier) {
        createPanel("``playerName(game)`` is rolling with a multiplier of ``multiplier``.",
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
        case (is Rolled) {
            showRolledPanel(game, phase.roll, phase.multiplier);
        }
        case (is RollingWithMultiplier) {
            showRollingWithMultiplierPanel(game, phase.multiplier);
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
            showCurrentPlayerEliminatedPanel(game);
        }
        case (drawingCard) {
            showDrawingCardPanel(game);
        }
        case (gameOver) {
            showGameOverPanel(game);
        }
        case (postLand) {
            showPostLandPanel(game);
        }
        case (preRoll) {
            showPreRollPanel(game);
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
