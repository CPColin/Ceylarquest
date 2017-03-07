import com.crappycomic.ceylarquest.model {
    Game,
    Player
}
import com.crappycomic.ceylarquest.view {
    Base=PlayerInfoPanel
}

import javax.swing {
    BorderFactory,
    BoxLayout,
    JLabel,
    JPanel
}

class PlayerInfoPanel extends JPanel satisfies Base {
    Player player;
    
    shared new(Game game, Player player) extends JPanel() {
        this.player = player;
        
        value borderColor = awtColor(player.color.withValue(0.75));
        value borderWidth = 3;
        value outsideBorder = BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(borderColor, borderWidth), game.playerName(player));
        value insideBorder
            = BorderFactory.createEmptyBorder(borderWidth, borderWidth, borderWidth, borderWidth);
        
        border = BorderFactory.createCompoundBorder(outsideBorder, insideBorder);
    }
    
    shared actual void updatePanel(Game game) {
        removeAll();
        
        this.layout = BoxLayout(this, BoxLayout.yAxis);
        
        strings(game, player).each((string) => add(JLabel(string)));
        
        validate();
        repaint();
    }
}
