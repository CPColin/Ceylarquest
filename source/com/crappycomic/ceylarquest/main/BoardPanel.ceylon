import ceylon.interop.java {
    javaClassFromInstance
}
import ceylon.language {
    cprint=print
}


import com.crappycomic.ceylarquest.model {
    Board
}
import com.crappycomic.ceylarquest.view {
    black,
    boardOverlay
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

class BoardPanel extends JPanel {
    BufferedImage? loadImage(Board board, String name) {
        try {
            value resource = javaClassFromInstance(board).getResourceAsStream(name);
           
            if (exists resource) {
                return ImageIO.read(resource);
            }
        }
        catch (Exception e) {
            cprint("Failed to load ``name``: ``e.string``");
        }
        
        return null;
    }
    
    BufferedImage? backgroundImage;
    
    BufferedImage? foregroundImage;
    
    shared new(Board board) extends JPanel() {
        backgroundImage = loadImage(board, "background.png");
        foregroundImage = loadImage(board, "foreground.png");
    }
    
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
            
            boardOverlay.draw(context, controller.game);
        }
    }
}
