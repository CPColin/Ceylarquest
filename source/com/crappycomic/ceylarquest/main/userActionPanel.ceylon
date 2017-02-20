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
    Path,
    Result,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard,
    applyRoll,
    drawCard,
    landOnNode,
    loseNodeToLeague,
    purchaseNode,
    rollDice,
    traversePath,
    winNodeFromLeague,
    winNodeFromPlayer
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

import java.awt {
    Component
}

import javax.swing {
    JButton,
    JComboBox,
    JLabel,
    JPanel
}

object userActionPanel extends JPanel() satisfies UserActionPanel<Component, JComboBox<Node>> {
    shared actual JButton createApplyCardButton(Game game, Card card) {
        return actionButton("OK", () => applyCard(game, card));
    }
    
    shared actual JButton createChooseNodeLostToLeagueButton(Game game, JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, loseNodeToLeague);
    }
    
    shared actual JButton createChooseNodeWonFromLeagueButton(Game game,
            JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, winNodeFromLeague);
    }
    
    shared actual JButton createChooseNodeWonFromPlayerButton(Game game,
            JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, winNodeFromPlayer);
    }
    
    shared actual JButton createDrawCardButton(Game game) {
        return actionButton("Draw a Card", () => drawCard(game));
    }
    
    shared actual JButton createEndTurnButton(Game game) {
        // TODO: temporary, for testing
        return actionButton("End Turn", () => game.with {
            currentPlayer = game.nextPlayer;
            phase = preRoll;
        });
    }
    
    shared actual JButton createLandOnNodeButton(Game game) {
        return actionButton("Continue", () => landOnNode(game));
    }
    
    shared actual Component[] createNodeSelect(Game game, [Node*] nodes,
            Component(Game, JComboBox<Node>?) createButton) {
        if (nonempty nodes) {
            value comboBox = JComboBox(createJavaObjectArray(nodes));
            value button = createButton(game, comboBox);
            
            return [comboBox, button];
        }
        else {
            return [createButton(game, null)];
        }
    }
    
    shared actual void createPanel(String label, Component* children) {
        removeAll();
        
        add(JLabel(label));
        
        children.each((child) => add(child));
        
        validate();
        repaint();
    }
    
    shared actual JButton createPurchaseNodeButton(Game game, Boolean canPurchaseNode,
            Integer price) {
        value label = canPurchaseNode
            then "Purchase Property ($``price``)"
            else "Purchase Property";
        value button = actionButton(label, () => purchaseNode(game));
        
        button.enabled = canPurchaseNode;
        
        return button;
    }
    
    shared actual JButton createRollDiceButton(Game game) {
        return actionButton("Roll Dice", () => rollDiceAndApplyRoll(game));
    }
    
    shared actual JButton createTraversePathButton(Game game, Path path, Integer fuel) {
        value node = path.last;
        value button = JButton(node.name);
        
        button.addActionListener(void(_) {
            controller.updateGame(traversePath(game, game.currentPlayer, path, fuel));
        });
        
        return actionButton(path.last.name,
            () => traversePath(game, game.currentPlayer, path, fuel));
    }
    
    shared actual void showError(String message) {
        cprint(message);
    }
    
    JButton actionButton(String label, Result() action) {
        value button = JButton(label);
        
        button.addActionListener((_) => controller.updateGame(action()));
        
        return button;
    }
    
    JButton chooseNodeButton(Game game, JComboBox<Node>? comboBox,
        Result(Game, Node?) chooseNode) {
        if (exists comboBox) {
            return actionButton("Choose", () {
                value node = comboBox.selectedItem;
                
                assert (is Node? node);
                
                return chooseNode(game, node);
            });
        }
        else {
            return actionButton("None Available", () => chooseNode(game, null));
        }
    }
    
    // TODO: may be broken up into two separate actions
    Result rollDiceAndApplyRoll(Game game) {
        value roll = rollDice(game.rules);
        
        return applyRoll(game, game.currentPlayer, roll);
    }
    
    void showPanel(JPanel panel) {
        removeAll();
        add(panel);
        
        validate();
        repaint();
    }
}
