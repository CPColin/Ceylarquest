import com.crappycomic.ceylarquest.model {
    Color,
    Location
}
import com.crappycomic.ceylarquest.view {
    GraphicsContext
}

import java.awt {
    AwtColor=Color,
    BasicStroke,
    Graphics2D
}
import java.awt.geom {
    AffineTransform
}
import java.awt.image {
    BufferedImage
}

class JavaGraphicsContext(Graphics2D g, Integer width, Integer height) satisfies GraphicsContext {
    shared actual void clear() {
        g.clearRect(0, 0, width, height);
    }
    
    shared void drawImage(BufferedImage image) {
        g.drawImage(image, AffineTransform(), null);
    }
    
    shared actual void drawLine(Location from, Location to, Color color, Integer width) {
        value stroke = g.stroke;
        
        g.stroke = BasicStroke(width.float);
        g.color = awtColor(color, 255);
        
        g.drawLine(from[0], from[1], to[0], to[1]);
        
        // TODO: care about resetting the stroke?
        g.stroke = stroke;
    }
    
    shared actual void fillCircle(Location center, Color color, Integer radius) {
        value diameter = radius * 2;
        
        g.color = awtColor(color, 128);
        
        g.fillOval(center[0] - radius, center[1] - radius, diameter, diameter);
    }
    
    shared actual void fillRect(Location topLeft, Color color, Integer width, Integer height) {
        g.color = awtColor(color);
        
        g.fillRect(topLeft[0], topLeft[1], width, height);
    }
    
    AwtColor awtColor(Color color, Integer alpha = 255)
            => AwtColor(color[0], color[1], color[2], alpha);
}
