import ceylon.html {
    Button,
    ButtonType,
    Content,
    FlowCategory,
    H3,
    Nav,
    renderTemplate
}

import com.crappycomic.ceylarquest.model {
    Card,
    Game,
    Path
}
import com.crappycomic.ceylarquest.view {
    UserActionPanel
}

shared object userActionPanel satisfies UserActionPanel {
    String panelContainerId = "userActions";
    
    shared actual void showChoosingAllowedMovePanel(Game game, [Path+] paths, Integer fuel) {
        showPanel("``playerName(game)`` must choose a move.",
        {
            for (path in paths)
                let (node = path.last)
                actionButton(node.name, "doTraversePath", "'``node.id``'")
        });
    }
    
    shared actual void showChoosingNodeLostToLeaguePanel(Game game) {
        // TODO
    }
    
    shared actual void showChoosingNodeWonFromLeaguePanel(Game game) {
        // TODO
    }
    
    shared actual void showChoosingNodeWonFromPlayerPanel(Game game) {
        // TODO
    }
    
    shared actual void showDrawingCardPanel(Game game) {
        // TODO
    }
    
    shared actual void showDrewCardPanel(Game game, Card card) {
        showPanel("``playerName(game)`` drew \"``card.description``\"",
            actionButton("OK", "doApplyCard"));
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
    
    shared actual void showPostLandPanel(Game game) {
        // TODO
    }
    
    shared actual void showPreLandPanel(Game game) {
        showPanel("``playerName(game)`` has arrived at ``nodeName(game)``.",
            actionButton("Continue", "doLandOnNode"));
    }
    
    shared actual void showPreRollPanel(Game game) {
        showPanel("``playerName(game)``'s turn!",
            actionButton("Roll Dice", "doRollDice"));
    }
    
    Button actionButton(String label, String functionName, String? functionParameters = null) {
        return Button {
            type = ButtonType.button;
            attributes = [
                "onclick" -> "boardDebug.``functionName``(``functionParameters else ""``)"
            ];
            label
        };
    }
    
    void showPanel(String label, Content<FlowCategory>* actions) {
        value panel = Nav {
            H3 {
                label
            },
            *actions
        };
        value stringBuilder = StringBuilder();
        
        renderTemplate(panel, stringBuilder.append);
        
        dynamic {
            document.getElementById(panelContainerId).innerHTML = stringBuilder.string;
        }
    }
}
