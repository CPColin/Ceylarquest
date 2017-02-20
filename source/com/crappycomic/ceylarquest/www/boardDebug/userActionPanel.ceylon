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
        return actionButton("OK", "doApplyCard");
    }
    
    shared actual Button createChooseNodeLostToLeagueButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doLoseNodeToLeague");
    }
    
    shared actual Button createChooseNodeWonFromLeagueButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doWinNodeFromLeague");
    }
    
    shared actual Button createChooseNodeWonFromPlayerButton(Game game, String? selectId) {
        return chooseNodeButton(selectId, "doWinNodeFromPlayer");
    }
    
    shared actual Button createDrawCardButton(Game game) {
        return actionButton("Draw a Card", "doDrawCard");
    }
    
    shared actual Button createEndTurnButton(Game game) {
        return actionButton("End Turn", "doEndTurn");
    }
    
    shared actual Button createLandOnNodeButton(Game game) {
        return actionButton("Continue", "doLandOnNode");
    }
    
    shared actual Content<FlowCategory>[] createNodeSelect(Game game, [Node*] nodes,
            Content<FlowCategory>(Game, String?) createButton) {
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
            value button = createButton(game, id);
            
            return [select, button];
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
    
    shared actual Button createPurchaseNodeButton(Game game, Boolean canPurchaseNode,
            Integer price) {
        value label = canPurchaseNode
            then "Purchase Property ($``price``)"
            else "Purchase Property";
        
        return actionButton(label, "doPurchaseNode", null, canPurchaseNode);
    }
    
    shared actual Button createRollDiceButton(Game game) {
        return actionButton("Roll Dice", "doRollDice");
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
    
    shared actual Boolean showPhase(Game game) {
        value result = super.showPhase(game);
        
        // TODO: the package needs to track the game separately, because the action buttons can't
        // pass the game around properly. if possible, find a better way to do this and remove the
        // default annotation from the supermethod
        // could serialize and pass the JSON? ugh
        package.game = game;
        
        return result;
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
    
    Button chooseNodeButton(String? selectId, String functionName) {
        if (exists selectId) {
            return actionButton("Choose", functionName,
                "document.getElementById('``selectId``').value");
        }
        else {
            return actionButton("None Available", functionName, "null");
        }
    }
}
