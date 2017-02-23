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
        return actionButton(applyCardButtonLabel, () => applyCard(game));
    }
    
    shared actual JButton createApplyRollButton(Game game) {
        return actionButton(applyRollButtonLabel, () => applyRoll(game));
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
        return actionButton(drawCardButtonLabel, () => drawCard(game));
    }
    
    shared actual JButton createEndTurnButton(Game game) {
        return actionButton(endTurnButtonLabel, () => endTurn(game));
    }
    
    shared actual JButton createLandOnNodeButton(Game game) {
        return actionButton(landOnNodeButtonLabel, () => landOnNode(game));
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
        return actionButton(placeFuelStationButtonLabel,
            () => placeFuelStation(game, game.playerLocation(game.currentPlayer)),
            canPlaceFuelStation);
    }
    
    shared actual JButton createPurchaseFuelButton(Game game, Boolean fuelAvailable,
            Integer price) {
        return actionButton(purchaseFuelButtonLabel(fuelAvailable, price),
            () => showPurchaseFuelPanel(game),
            fuelAvailable);
    }
    
    shared actual JButton createPurchaseNodeButton(Game game, Boolean canPurchaseNode,
            Integer price) {
        return actionButton(purchaseNodeButtonLabel(canPurchaseNode, price),
            () => purchaseNode(game),
            canPurchaseNode);
    }
    
    shared actual JButton createResignButton(Game game) {
        return actionButton(resignButtonLabel, () => game.without(game.currentPlayer));
    }
    
    shared actual JButton createRollDiceButton(Game game) {
        return actionButton(rollDiceButtonLabel, () => rollDice(game));
    }
    
    shared actual JButton createTraversePathButton(Game game, Path path) {
        return actionButton(path.last.name, () => traversePath(game, path));
    }
    
    shared actual void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Error", JOptionPane.errorMessage);
    }
    
    JButton actionButton(String label, Result()|Anything() action, Boolean enabled = true) {
        value button = JButton(label);
        
        if (is Result() action) {
            button.addActionListener((_) => controller.updateGame(action()));
        }
        else {
            button.addActionListener((_) => action());
        }
        
        button.enabled = enabled;
        
        return button;
    }
    
    JButton chooseNodeButton(Game game, JComboBox<Node>? comboBox,
            Result(Game, Node?) chooseNode) {
        if (exists comboBox) {
            return actionButton(chooseNodeButtonLabel, () {
                value node = comboBox.selectedItem;
                
                assert (is Node? node);
                
                return chooseNode(game, node);
            });
        }
        else {
            return actionButton(chooseNodeNoneAvailableButtonLabel, () => chooseNode(game, null));
        }
    }
}
