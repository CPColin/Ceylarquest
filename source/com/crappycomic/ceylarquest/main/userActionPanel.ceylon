import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Node,
    Path,
    Player
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard,
    applyRoll,
    drawCard,
    landOnNode,
    rollDice,
    traversePath
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

import javax.swing {
    JButton,
    JLabel,
    JPanel
}

object userActionPanel extends JPanel() satisfies UserActionPanel {
    shared actual void showChoosingAllowedMovePanel([Path+] paths, Integer fuel) {
        value panel = JPanel();
        
        panel.add(JLabel("Choose a Move"));
        
        for (path in paths) {
            value node = path.last;
            value button = JButton(node.name);
            
            button.addActionListener(void(_) {
                updateView(traversePath(game, game.currentPlayer, path, fuel));
            });
            
            panel.add(button);
        }
        
        showPanel(panel);
    }
    
    shared actual void showDrawingCardPanel(Game game) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)`` must draw a card."));
        
        value button = JButton("Draw a Card");
        
        button.addActionListener(void(_) {
            updateView(drawCard(game));
        });
        
        panel.add(button);
        
        showPanel(panel);
    }
    
    shared void showDrewCardPanel(Game game, Card card) {
        value panel = JPanel();
        
        panel.add(JLabel("Drew \"``card.description``\""));
        
        value button = JButton("OK");
        
        button.addActionListener(void(_) {
            updateView(applyCard(game, card));
        });
        
        panel.add(button);
        
        showPanel(panel);
    }
    
    shared actual void showPreLandPanel(Game game) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)`` has arrived at ``nodeName(game)``."));
        
        value continueButton = JButton("Continue");
        
        continueButton.addActionListener(void(_) {
            updateView(landOnNode(game));
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
    
    String nodeName(Game game, Node node = game.playerLocation(game.currentPlayer)) {
        return node.name;
    }
    
    String playerName(Game game, Player player = game.currentPlayer) {
        return game.playerName(player);
    }
    
    void rollDiceAndApplyRoll(Game game)(Anything _)  {
        value roll = rollDice(game.rules);
        
        updateView(applyRoll(game, game.currentPlayer, roll));
    }
    
    void showPanel(JPanel panel) {
        removeAll();
        add(panel);
        
        validate();
        repaint();
    }
}
