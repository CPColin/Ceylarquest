import ceylon.interop.java {
    createJavaIntArray
}

import com.crappycomic.ceylarquest.model {
    Color,
    Location
}
import com.crappycomic.ceylarquest.view {
    GraphicsContext,
    LineCap,
    LineJoin,
    bevelJoin,
    buttCap,
    miterJoin,
    roundCap,
    roundJoin,
    squareCap
}

import java.awt {
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
    
    shared actual void drawCircle(Location center, Color color, Integer radius, Integer width) {
        value diameter = radius * 2;
        
        g.color = awtColor(color);
        g.stroke = BasicStroke(width.float);
        
        g.drawArc(center[0] - radius, center[1] - radius, diameter, diameter, 0, 360);
    }
    
    shared void drawImage(BufferedImage image) {
        value scaleX = width.float / image.width;
        value scaleY = height.float / image.height;
        value scale = Float.largest(scaleX, scaleY);
        value transform = AffineTransform();
        
        transform.scale(scale, scale);
        
        g.drawImage(image, transform, null);
    }
    
    shared actual void drawLine(Location from, Location to, Color color, Integer width) {
        g.color = awtColor(color);
        g.stroke = BasicStroke(width.float);
        
        g.drawLine(from[0], from[1], to[0], to[1]);
    }
    
    shared actual void drawPath({Location*} locations, Color color, Integer width,
            LineCap lineCap, LineJoin lineJoin) {
        g.color = awtColor(color);
        g.stroke = BasicStroke(
            width.float,
            switch (lineCap)
                case (buttCap) BasicStroke.capButt
                case (roundCap) BasicStroke.capRound
                case (squareCap) BasicStroke.capSquare,
            switch (lineJoin)
                case (bevelJoin) BasicStroke.joinBevel
                case (miterJoin) BasicStroke.joinMiter
                case (roundJoin) BasicStroke.joinRound);
        
        g.drawPolyline(
            createJavaIntArray(locations.map((location) => location[0])),
            createJavaIntArray(locations.map((location) => location[1])),
            locations.size);
    }
    
    shared actual void fillCircle(Location center, Color color, Integer radius) {
        value diameter = radius * 2;
        
        g.color = awtColor(color);
        
        g.fillOval(center[0] - radius, center[1] - radius, diameter, diameter);
    }
    
    shared actual void fillRect(Location topLeft, Color color, Integer width, Integer height) {
        g.color = awtColor(color);
        
        g.fillRect(topLeft[0], topLeft[1], width, height);
    }
}
