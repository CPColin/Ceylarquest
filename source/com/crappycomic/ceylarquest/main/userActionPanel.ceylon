import ceylon.interop.java {
    createJavaObjectArray
}

import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Path,
    Result
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard,
    applyRoll,
    drawCard,
    endTurn,
    landOnNode,
    loseNodeToLeague,
    placeFuelStation,
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
    JOptionPane,
    JPanel
}

object userActionPanel extends JPanel() satisfies UserActionPanel<Component, JComboBox<Node>> {
    shared actual JButton createApplyCardButton(Game game) {
        return actionButton("OK", () => applyCard(game));
    }
    
    shared actual JButton createApplyRollButton(Game game) {
        return actionButton("OK", () => applyRoll(game));
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
        return actionButton("End Turn", () => endTurn(game));
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
    
    shared actual JButton createPlaceFuelStationButton(Game game, Boolean canPlaceFuelStation) {
        value button = actionButton("Place Fuel Station",
            () => placeFuelStation(game, game.playerLocation(game.currentPlayer)),
            canPlaceFuelStation);
        
        return button;
    }
    
    shared actual JButton createPurchaseFuelButton(Game game, Boolean fuelAvailable,
            Integer price) {
        value label = fuelAvailable then "Refuel ($``price``)" else "Refuel";
        value button = JButton(label);
        
        button.addActionListener((_) => showPurchaseFuelPanel(game));
        button.enabled = fuelAvailable;
        
        return button;
    }
    
    shared actual JButton createPurchaseNodeButton(Game game, Boolean canPurchaseNode,
            Integer price) {
        value label = canPurchaseNode
            then "Purchase Property ($``price``)"
            else "Purchase Property";
        
        return actionButton(label, () => purchaseNode(game), canPurchaseNode);
    }
    
    shared actual JButton createResignButton(Game game) {
        return actionButton("Resign", () => game.without(game.currentPlayer));
    }
    
    shared actual JButton createRollDiceButton(Game game) {
        return actionButton("Roll Dice", () => rollDice(game));
    }
    
    shared actual JButton createTraversePathButton(Game game, Path path) {
        return actionButton(path.last.name, () => traversePath(game, path));
    }
    
    shared actual void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Error", JOptionPane.errorMessage);
    }
    
    JButton actionButton(String label, Result() action, Boolean enabled = true) {
        value button = JButton(label);
        
        button.addActionListener((_) => controller.updateGame(action()));
        button.enabled = enabled;
        
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
}
