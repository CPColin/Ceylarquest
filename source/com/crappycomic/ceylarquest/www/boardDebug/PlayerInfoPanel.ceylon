import com.crappycomic.ceylarquest.model {
    Game,
    Player
}
import com.crappycomic.ceylarquest.view {
    Base=PlayerInfoPanel
}
import ceylon.html {
    Div,
    FieldSet,
    Legend,
    renderTemplate
}

class PlayerInfoPanel satisfies Base {
    String panelIdPrefix = "playerInfo";
    
    String panelId;
    
    Player player;
    
    shared new(Game game, Player player) {
        this.player = player;
        this.panelId = "``panelIdPrefix``-``player.string``";
    }
    
    shared void createPanel(Game game) {
        value fieldSet = FieldSet {
            style = "border-color: ``rgba(player.color.withValue(0.75))``; border-width: 3px";
            Legend {
                game.playerName(player)
            },
            Div {
                id = panelId;
            }
        };
        value stringBuilder = StringBuilder();
        
        renderTemplate(fieldSet, stringBuilder.append);
        
        dynamic {
            dynamic panel = document.createElement("div");
            
            panel.innerHTML = stringBuilder.string;
            document.getElementById(panelIdPrefix).appendChild(panel);
        }
    }
    
    shared actual void updatePanel(Game game) {
        value divs = Div {
            for (string in strings(game, player))
                Div { string }
        };
        value stringBuilder = StringBuilder();
        
        renderTemplate(divs, stringBuilder.append);
        
        dynamic {
            document.getElementById(panelId).innerHTML = stringBuilder.string;
        }
    }
}
