import ceylon.interop.java {
    javaClassFromInstance
}
import ceylon.language {
    cprint=print
}

import com.crappycomic.ceylarquest.model {
    Path
}
import com.crappycomic.ceylarquest.view {
    BoardOverlay,
    black
}

import java.awt {
    Graphics,
    Graphics2D,
    RenderingHints
}
import java.awt.image {
    BufferedImage
}

import javax.imageio {
    ImageIO
}
import javax.swing {
    JPanel
}

class BoardPanel() extends JPanel() {
    // TODO: this should probably be an attribute of BoardOverlay and the sequence of drawing
    // should be maintained by that class, instead of this one
    shared variable [Path+]? paths = null;
    
    BufferedImage? loadImage(String name) {
        try {
            value resource = javaClassFromInstance(game.board).getResourceAsStream(name);
           
            if (exists resource) {
                return ImageIO.read(resource);
            }
        }
        catch (Exception e) {
            cprint("Failed to load ``name``: ``e.string``");
        }
        
        return null;
    }
    
    BufferedImage? backgroundImage = loadImage("background.png");
    
    BufferedImage? foregroundImage = loadImage("foreground.png");
    
    shared actual void paint(Graphics g) {
        assert (is Graphics2D g);
        
        g.setRenderingHint(RenderingHints.keyAntialiasing, RenderingHints.valueAntialiasOn);
        
        value context = JavaGraphicsContext(g, width, height);
        
        context.fillRect([0, 0], black, width, height);
        
        if (exists closestNodes = closestNodes) {
            context.drawImage(closestNodes);
        }
        else {
            if (exists backgroundImage) {
                context.drawImage(backgroundImage);
            }
            
            if (exists foregroundImage) {
                context.drawImage(foregroundImage);
            }
            
            value boardOverlay = BoardOverlay(context);
            
            boardOverlay.drawOwnedNodes(game);
            //boardOverlay.highlightNodes(game);
            boardOverlay.drawPlacedFuelStations(game);
            
            if (exists paths = paths) {
                boardOverlay.drawPaths(game.currentPlayer, paths);
            }
            
            boardOverlay.drawActivePlayers(game);
        }
    }
}
