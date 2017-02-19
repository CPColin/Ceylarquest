import ceylon.interop.java {
    createJavaObjectArray
}
import ceylon.language {
    cprint=print
}

import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Node,
    Ownable,
    Path,
    Result,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    allowedNodesToLoseToLeague,
    allowedNodesToWinFromLeague,
    allowedNodesToWinFromPlayer,
    applyCard,
    applyRoll,
    canPurchaseNode,
    drawCard,
    landOnNode,
    loseNodeToLeague,
    nodePrice,
    purchaseNode,
    rollDice,
    traversePath,
    winNodeFromLeague,
    winNodeFromPlayer
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

import javax.swing {
    JButton,
    JComboBox,
    JLabel,
    JPanel
}

object userActionPanel extends JPanel() satisfies UserActionPanel {
    shared actual void showChoosingAllowedMovePanel(Game game, [Path+] paths, Integer fuel) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)`` must choose a move."));
        
        for (path in paths) {
            value node = path.last;
            value button = JButton(node.name);
            
            button.addActionListener(void(_) {
                controller.updateGame(traversePath(game, game.currentPlayer, path, fuel));
            });
            
            panel.add(button);
        }
        
        showPanel(panel);
    }
    
    shared actual void showChoosingNodeLostToLeaguePanel(Game game) {
        // TODO: localize "League"
        showChoosingNodePanel(game, "``playerName(game)`` lost a property to the League.",
            allowedNodesToLoseToLeague, loseNodeToLeague);
    }
    
    shared actual void showChoosingNodeWonFromLeaguePanel(Game game) {
        // TODO: localize "League"
        showChoosingNodePanel(game, "``playerName(game)`` won a property from the League.",
            allowedNodesToWinFromLeague, winNodeFromLeague);
    }
    
    shared actual void showChoosingNodeWonFromPlayerPanel(Game game) {
        showChoosingNodePanel(game, "``playerName(game)`` won a property from another player.",
            allowedNodesToWinFromPlayer, winNodeFromPlayer);
    }
    
    shared actual void showDrawingCardPanel(Game game) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)`` must draw a card."));
        
        value button = JButton("Draw a Card");
        
        button.addActionListener(void(_) {
            controller.updateGame(drawCard(game));
        });
        
        panel.add(button);
        
        showPanel(panel);
    }
    
    shared actual void showDrewCardPanel(Game game, Card card) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)`` drew \"``card.description``\""));
        
        value button = JButton("OK");
        
        button.addActionListener(void(_) {
            controller.updateGame(applyCard(game, card));
        });
        
        panel.add(button);
        
        showPanel(panel);
    }
    
    shared actual void showError(String message) {
        cprint(message);
    }
    
    shared actual void showPostLandPanel(Game game) {
        value panel = JPanel();
        value node = game.playerLocation(game.currentPlayer);
        value nodeName = this.nodeName(game, node);
        
        panel.add(JLabel("``playerName(game)`` is at ``nodeName``."));
        
        if (is Ownable node) {
            value purchaseNodeButton = JButton("Purchase This Node ($``nodePrice(game, node)``)");
            
            purchaseNodeButton.enabled = canPurchaseNode(game);
            
            purchaseNodeButton.addActionListener(void(_) {
                controller.updateGame(purchaseNode(game));
            });
            
            panel.add(purchaseNodeButton);
        }
        else {
            value purchaseNodeButton = JButton("Purchase This Node");
            
            purchaseNodeButton.enabled = false;
            
            panel.add(purchaseNodeButton);
        }
        
        value endTurnButton = JButton("End Turn");
        
        endTurnButton.addActionListener(void(_) {
            // TODO: temporary, for testing
            controller.updateGame(game.with {
                currentPlayer = game.nextPlayer;
                phase = preRoll;
            });
        });
        
        panel.add(endTurnButton);
        
        showPanel(panel);
    }
    
    shared actual void showPreLandPanel(Game game) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)`` has arrived at ``nodeName(game)``."));
        
        value continueButton = JButton("Continue");
        
        continueButton.addActionListener(void(_) {
            controller.updateGame(landOnNode(game));
        });
        
        panel.add(continueButton);
        
        showPanel(panel);
    }
    
    shared actual void showPreRollPanel(Game game) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)``'s turn!"));
        
        value rollDiceButton = JButton("Roll Dice");
        
        rollDiceButton.addActionListener(rollDiceAndApplyRoll(game));
        
        panel.add(rollDiceButton);
        
        showPanel(panel);
    }
    
    void rollDiceAndApplyRoll(Game game)(Anything _)  {
        value roll = rollDice(game.rules);
        
        controller.updateGame(applyRoll(game, game.currentPlayer, roll));
    }
    
    void showChoosingNodePanel(Game game, String label, [Node*](Game) allowedNodes,
            Result(Game, Node?) chooseNode) {
        value panel = JPanel();
        
        panel.add(JLabel(label));
        
        value nodes = allowedNodes(game)
            .sort(byIncreasing(Node.name));
        
        if (nonempty nodes) {
            value comboBox = JComboBox(createJavaObjectArray(nodes));
            
            panel.add(comboBox);
            
            value button = JButton("Choose");
            
            button.addActionListener(void(_) {
                value node = comboBox.selectedItem;
                
                assert (is Node? node);
                
                controller.updateGame(chooseNode(game, node));
            });
            
            panel.add(button);
        }
        else {
            value button = JButton("None available");
            
            button.addActionListener(void(_) {
                controller.updateGame(chooseNode(game, null));
            });
            
            panel.add(button);
        }
        
        showPanel(panel);
    }
    
    void showPanel(JPanel panel) {
        removeAll();
        add(panel);
        
        validate();
        repaint();
    }
}
