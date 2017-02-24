import ceylon.interop.java {
    javaClassFromInstance
}
import ceylon.language {
    cprint=print
}


import com.crappycomic.ceylarquest.model {
    Board,
    Game
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
import java.awt.geom {
    AffineTransform
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
    
    variable BufferedImage? boardImage = null;
    
    BufferedImage foregroundImage;
    
    shared new(Board board) extends JPanel() {
        backgroundImage = loadImage(board, "background.png");
        
        assert (exists foregroundImage = loadImage(board, "foreground.png"));
        
        this.foregroundImage = foregroundImage;
    }
    
    shared actual void paint(Graphics g) {
        if (!exists boardImage = boardImage) {
            return;
        }
        
        assert (is Graphics2D g);
        
        g.drawImage(boardImage, AffineTransform(), null);
    }
    
    shared void updateBoardImage(Game game) {
        value boardImage = BufferedImage(foregroundImage.width, foregroundImage.height,
            BufferedImage.typeIntRgb);
        value g = boardImage.graphics;
        
        assert (is Graphics2D g);
        
        g.setRenderingHint(RenderingHints.keyAntialiasing, RenderingHints.valueAntialiasOn);
        
        value context = JavaGraphicsContext(g, foregroundImage.width, foregroundImage.height);
        
        context.clear();
        
        if (exists closestNodes = closestNodes) {
            context.drawImage(closestNodes);
        }
        else {
            if (exists backgroundImage) {
                context.drawImage(backgroundImage);
            }
            
            context.drawImage(foregroundImage);
            
            boardOverlay.draw(context, game);
        }
        
        g.dispose();
        
        this.boardImage = boardImage;
        
        repaint();
    }
}
