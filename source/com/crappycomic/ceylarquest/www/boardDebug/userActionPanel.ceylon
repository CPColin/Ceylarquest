import ceylon.html {
    Button,
    ButtonType,
    Content,
    FlowCategory,
    H3,
    Option,
    Nav,
    Select,
    renderTemplate
}

import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Path
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

shared object userActionPanel satisfies UserActionPanel<Content<FlowCategory>, String> {
    String panelContainerId = "userActions";
    
    shared actual Button createApplyCardButton(Game game) {
        return actionButton(applyCardButtonLabel, "doApplyCard");
    }
    
    shared actual Button createApplyRollButton(Game game) {
        return actionButton(applyRollButtonLabel, "doApplyRoll");
    }
    
    shared actual Button createChooseNodeLostToLeagueButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doLoseNodeToLeague");
    }
    
    shared actual Button createChooseNodeToSellButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doSellNode");
    }
    
    shared actual Button createChooseNodeWonFromLeagueButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doWinNodeFromLeague");
    }
    
    shared actual Button createChooseNodeWonFromPlayerButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doWinNodeFromPlayer");
    }
    
    shared actual Button createCondemnNodeButton(Game game, Boolean canCondemnNode, Integer price) {
        return actionButton(condemnNodeButtonLabel(canCondemnNode, price), "doCondemnNode", null,
            canCondemnNode);
    }
    
    shared actual Button createDrawCardButton(Game game) {
        return actionButton(drawCardButtonLabel, "doDrawCard");
    }
    
    shared actual Button createEndTurnButton(Game game) {
        return actionButton(endTurnButtonLabel, "doEndTurn");
    }
    
    shared actual Button createFinishSettlingDebtsButton(Game game) {
        return actionButton(finishSettlingDebtsButtonLabel, "doFinishSettlingDebts");
    }
    
    shared actual Button createLandOnNodeButton(Game game) {
        return actionButton(landOnNodeButtonLabel, "doLandOnNode");
    }
    
    shared actual Content<FlowCategory>[] createNodeSelect(Game game, [Node*] nodes,
            Boolean showCancelButton, Content<FlowCategory>(Game, String?) createButton) {
        if (nonempty nodes) {
            value id = "nodeSelect";
            value select = Select {
                id = id;
                children = {
                    for (node in nodes)
                        Option {
                            val = node.id;
                            node.name
                        }
                };
            };
            value cancelButton = cancelChoosingNodeButton();
            value chooseButton = createButton(game, id);
            
            return showCancelButton
                then [select, cancelButton, chooseButton]
                else [select, chooseButton];

        }
        else {
            return [createButton(game, null)];
        }
    }
    
    shared actual void createPanel(String label, Content<FlowCategory>* children) {
        value panel = Nav {
            H3 {
                label
            },
            *children
        };
        value stringBuilder = StringBuilder();
        
        renderTemplate(panel, stringBuilder.append);
        
        dynamic {
            document.getElementById(panelContainerId).innerHTML = stringBuilder.string;
        }
    }
    
    shared actual Button createPlaceFuelStationButton(Game game, Boolean canPlaceFuelStation) {
        // TODO: current node only, for now
        return actionButton(placeFuelStationButtonLabel(game), "doPlaceFuelStation", null,
            canPlaceFuelStation);
    }
    
    shared actual Button createPurchaseFuelButton(Game game, Boolean fuelAvailable, Integer price) {
        return actionButton(purchaseFuelButtonLabel(game, fuelAvailable, price),
            "userActionPanel().showPurchaseFuelPanel", "boardDebug.game()", fuelAvailable);
    }
    
    shared actual Button createPurchaseFuelStationButton(Game game, Boolean canPurchaseFuelStation,
            Integer price) {
        return actionButton(purchaseFuelStationButtonLabel(game, price), "doPurchaseFuelStation",
            null, canPurchaseFuelStation);
    }
    
    shared actual Button createPurchaseNodeButton(Game game, Boolean canPurchaseNode,
            Integer price) {
        return actionButton(purchaseNodeButtonLabel(canPurchaseNode, price),
            "doPurchaseNode", null, canPurchaseNode);
    }
    
    shared actual Button createResignButton(Game game) {
        return actionButton(resignButtonLabel, "doResign");
    }
    
    shared actual Button createRollDiceButton(Game game) {
        return actionButton(rollDiceButtonLabel, "doRollDice");
    }
    
    shared actual Button createSellFuelStationButton(Game game, Boolean canSellFuelStation,
            Integer price) {
        return actionButton(sellFuelStationButtonLabel(game, price), "doSellFuelStation");
    }
    
    shared actual Button createSellNodeButton(Game game, Boolean canSellNode) {
        return actionButton(sellNodeButtonLabel, "userActionPanel().showChoosingNodeToSellPanel",
            "boardDebug.game()", canSellNode);
    }
    
    shared actual Button createSettleDebtWithCashButton(Game game, Boolean canSettleDebtWithCash) {
        return actionButton(settleDebtWithCashButtonLabel, "doSettleDebtWithCash", null,
            canSettleDebtWithCash);
    }
    
    shared actual Button createTraversePathButton(Game game, Path path) {
        return let (node = path.last)
            actionButton(node.name, "doTraversePath", "'``node.id``'");
    }
    
    shared actual void showError(String message) {
        dynamic {
            alert(message);
        }
    }
    
    shared actual void showPhase(Game game) {
        super.showPhase(game);
        
        // TODO: the package needs to track the game separately, because the action buttons can't
        // pass the game around properly. if possible, find a better way to do this and remove the
        // default annotation from the supermethod
        // could serialize and pass the JSON? ugh
        package.game = game;
    }
    
    Button actionButton(String label, String functionName, String? functionParameters = null,
            Boolean enabled = true) {
        return Button {
            disabled = !enabled;
            type = ButtonType.button;
            attributes = [
                "onclick" -> "boardDebug.``functionName``(``functionParameters else ""``)"
            ];
            label
        };
    }
    
    Button cancelChoosingNodeButton() {
        return actionButton(cancelChoosingNodeButtonLabel, "doCancelChoosingNode", "null");
    }
    
    Button chooseNodeButton(String? selectId, String functionName) {
        if (exists selectId) {
            return actionButton(chooseNodeButtonLabel, functionName,
                "document.getElementById('``selectId``').value");
        }
        else {
            return actionButton(chooseNodeNoneAvailableButtonLabel, functionName, "null");
        }
    }
}
