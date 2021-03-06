import ceylon.interop.java {
    createJavaObjectArray
}

import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Ownable,
    Path,
    Result
}
import com.crappycomic.ceylarquest.model.logic {
    applyCard,
    applyRoll,
    condemnNode,
    drawCard,
    endTurn,
    finishSettlingDebts,
    landOnNode,
    loseNodeToLeague,
    placeFuelStation,
    purchaseFuel,
    purchaseFuelStation,
    purchaseNode,
    rollDice,
    sellFuelStation,
    sellNode,
    settleDebtWithCash,
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
import java.lang {
    JInteger=Integer
}

import javax.swing {
    JButton,
    JComboBox,
    JLabel,
    JOptionPane,
    JPanel,
    JSpinner,
    SpinnerNumberModel
}

object userActionPanel extends JPanel() satisfies UserActionPanel<Component, JComboBox<Node>> {
    shared actual JButton createApplyCardButton(Game game) {
        return actionButton(applyCardButtonLabel, () => applyCard(game));
    }
    
    shared actual JButton createApplyRollButton(Game game) {
        return actionButton(applyRollButtonLabel, () => applyRoll(game));
    }
    
    shared actual JButton createCancelButton(Game game) {
        return actionButton(cancelButtonLabel, () => game);
    }
    
    shared actual JButton createChooseNodeLostToLeagueButton(Game game, JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, loseNodeToLeague);
    }
    
    shared actual JButton createChooseNodeToPlaceFuelStationOnButton(Game game,
            JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, placeFuelStation);
    }
    
    shared actual JButton createChooseNodeToSellButton(Game game, JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, (game, node) {
            if (is Ownable node) {
                return sellNode(game, node);
            }
            else {
                return game;
            }
        });
    }
    
    shared actual JButton createChooseNodeWonFromLeagueButton(Game game,
            JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, winNodeFromLeague);
    }
    
    shared actual JButton createChooseNodeWonFromPlayerButton(Game game,
            JComboBox<Node>? comboBox) {
        return chooseNodeButton(game, comboBox, winNodeFromPlayer);
    }
    
    shared actual JButton createCondemnNodeButton(Game game, Boolean canCondemnNode,
            Integer price) {
        return actionButton(condemnNodeButtonLabel(canCondemnNode, price),
            () => condemnNode(game),
            canCondemnNode);
    }
    
    shared actual JButton createDrawCardButton(Game game) {
        return actionButton(drawCardButtonLabel, () => drawCard(game));
    }
    
    shared actual JButton createEndTurnButton(Game game) {
        return actionButton(endTurnButtonLabel, () => endTurn(game));
    }
    
    shared actual JButton createFinishSettlingDebtsButton(Game game) {
        return actionButton(finishSettlingDebtsButtonLabel, () => finishSettlingDebts(game));
    }
    
    shared actual JButton createLandOnNodeButton(Game game) {
        return actionButton(landOnNodeButtonLabel, () => landOnNode(game));
    }
    
    shared actual Component[] createNodeSelect(Game game, [Node+] nodes,
            Component(Game, JComboBox<Node>?) createButton) {
        value comboBox = JComboBox(createJavaObjectArray(nodes));
        value chooseButton = createButton(game, comboBox);
        
        return [comboBox, chooseButton];
    }
    
    shared actual void createPanel(String label, Component* children) {
        removeAll();
        
        add(JLabel(label));
        
        children.each((child) => add(child));
        
        validate();
        repaint();
    }
    
    shared actual JButton createPlaceFuelStationButton(Game game, Boolean canPlaceFuelStation) {
        return actionButton(placeFuelStationButtonLabel(game),
            () => showChoosingNodeToPlaceFuelStationOnPanel(game),
            canPlaceFuelStation);
    }
    
    shared actual JButton createPurchaseFuelButton(Game game, Boolean fuelAvailable,
            Integer price) {
        return actionButton(purchaseFuelButtonLabel(game, fuelAvailable, price),
            () => showPurchaseFuelPanel(game),
            fuelAvailable);
    }
    
    shared actual JButton createPurchaseFuelStationButton(Game game, Boolean canPurchaseFuelStation,
            Integer price) {
        return actionButton(purchaseFuelStationButtonLabel(game, price),
            () => purchaseFuelStation(game),
            canPurchaseFuelStation);
    }
    
    shared actual JButton createPurchaseNodeButton(Game game, Boolean canPurchaseNode,
            Integer price) {
        return actionButton(purchaseNodeButtonLabel(canPurchaseNode, price),
            () => purchaseNode(game),
            canPurchaseNode);
    }
    
    shared actual Component[] createRefuelSpinner(Game game, Integer maximumUnits, Integer fee) {
        value spinner = JSpinner(SpinnerNumberModel(maximumUnits, 1, maximumUnits, 1));
        value button = actionButton(purchaseFuelButtonLabel(game, true, fee),
            () {
                value fuel = spinner.\ivalue;
                
                assert (is JInteger fuel);
                
                return purchaseFuel(game, fuel.longValue());
            });
        
        return [spinner, JLabel(refuelSpinnerLabel(game)), button];
    }
    
    shared actual JButton createRefuelToFullButton(Game game, Boolean canRefuelToFull,
            Integer units, Integer fee) {
        return actionButton(refuelToFullButtonLabel(game, canRefuelToFull, units, fee),
            () => purchaseFuel(game, units),
            canRefuelToFull);
    }
    
    shared actual JButton createRefuelToLowFuelButton(Game game, Boolean canRefuelToLowFuel,
            Integer units, Integer fee) {
        return actionButton(refuelToLowFuelButtonLabel(game, canRefuelToLowFuel, units, fee),
            () => purchaseFuel(game, units),
            canRefuelToLowFuel);
    }
    
    shared actual JButton createResignButton(Game game) {
        return actionButton(resignButtonLabel, () => game.without(game.currentPlayer));
    }
    
    shared actual JButton createRollDiceButton(Game game) {
        return actionButton(rollDiceButtonLabel, () => rollDice(game));
    }
    
    shared actual JButton createSellFuelStationButton(Game game, Boolean canSellFuelStation,
            Integer price) {
        return actionButton(sellFuelStationButtonLabel(game, price),
            () => sellFuelStation(game),
             canSellFuelStation);
    }
    
    shared actual JButton createSellNodeButton(Game game, Boolean canSellNode) {
        return actionButton(sellNodeButtonLabel,
            () => showChoosingNodeToSellPanel(game),
            canSellNode);
    }
    
    shared actual JButton createSettleDebtWithCashButton(Game game, Boolean canSettleDebtWithCash) {
        return actionButton(settleDebtWithCashButtonLabel,
            () => settleDebtWithCash(game),
            canSettleDebtWithCash);
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
