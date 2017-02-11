import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Path
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard,
    applyRoll,
    drawCard,
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
        
        panel.add(JLabel("``playerName(game)`` Must Draw a Card"));
        
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
        // TODO
    }
    
    shared actual void showPreRollPanel(Game game) {
        value panel = JPanel();
        
        panel.add(JLabel("``playerName(game)``'s Turn"));
        
        value rollDiceButton = JButton("Roll Dice");
        
        rollDiceButton.addActionListener(rollDiceAndApplyRoll(game));
        
        panel.add(rollDiceButton);
        
        showPanel(panel);
    }
    
    String playerName(Game game) {
        return game.playerName(game.currentPlayer);
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
