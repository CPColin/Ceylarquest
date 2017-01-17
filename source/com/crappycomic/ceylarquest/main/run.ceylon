import ceylon.json {
    JsonObject
}

import com.crappycomic.ceylarquest.model {
    Color,
    Game,
    InvalidSave,
    Location,
    loadGame
}

import com.crappycomic.ceylarquest.view {
    BoardOverlay,
    GraphicsContext
}

import java.awt {
    AwtColor = Color,
    BasicStroke,
    Dimension,
    Graphics,
    Graphics2D
}

import java.awt.geom {
    AffineTransform
}

import java.awt.image {
    BufferedImage
}

import java.util.concurrent {
    Executors,
    TimeUnit
}

import javax.swing {
    JFrame,
    JPanel,
    JScrollPane
}

String json = JsonObject {
    "board" -> JsonObject {
        "moduleName" -> "com.crappycomic.tropichop",
        "packageName" -> "com.crappycomic.tropichop",
        "objectName" -> "tropicHopBoard"
    },
    "players" -> JsonObject {
        "cyan" -> "Cyan",
        "red" -> "Red"
    }
}.pretty;

late Game game;

shared void run() {
    print(json);
    
    value game = loadGame(json);
    
    switch (game)
    case (is InvalidSave) {
        print("Invalid save: " + game.string);
    }
    case (is Game) {
        print("It worked!");
        
        package.game = game;
        
        overlay();
    }
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

variable BufferedImage? closestNodes = null;

class BoardPanel() extends JPanel() {
    shared actual void paint(Graphics g) {
        assert (is Graphics2D g);
        
        value context = JavaGraphicsContext(g, width, height);
        
        if (exists closestNodes = closestNodes) {
            context.clear();
            
            context.drawImage(closestNodes);
        }
        else {
            BoardOverlay(game.board, context).highlightNodes();
        }
    }
}

late BoardPanel panel;

void overlay() {
    value frame = JFrame();
    
    panel = BoardPanel();
    panel.preferredSize = Dimension(1280, 1280);
    
    frame.title = "Ceylarquest Debug Stuff";
    frame.add(JScrollPane(panel));
    frame.defaultCloseOperation = JFrame.exitOnClose;
    frame.setMinimumSize(Dimension(640, 640));
    frame.setLocationRelativeTo(null);
    frame.extendedState = JFrame.maximizedBoth;
    frame.visible = true;
    
    value executorService = Executors.newSingleThreadExecutor();
    
    executorService.submit(calculateClosestNodes);
}

void calculateClosestNodes() {
    value start = system.milliseconds;
    value image = BufferedImage(1280, 1280, BufferedImage.typeIntRgb);
    value graphics = image.createGraphics();
    value context = JavaGraphicsContext(graphics, image.width, image.height);
    
    context.fillRect([0, 0], [0, 0, 0], image.width, image.height);
    
    package.closestNodes = image;
    
    value executorService = Executors.newSingleThreadScheduledExecutor();
    
    executorService.scheduleAtFixedRate(() => panel.repaint(), 1, 1, TimeUnit.seconds);
    
    for (x in 0..image.width) {
        for (y in 0..image.height) {
            value closestNode = game.board.calculateClosestNode(x, y);
            value nodeHash = closestNode.id.hash.magnitude;
            
            value color = [
                (nodeHash * 13) % 256,
                (nodeHash * 3) % 256,
                (nodeHash * 37) % 256
            ];
            
            context.fillRect([x, y], color, 1, 1);
        }
    }
    
    graphics.dispose();
    
    panel.repaint();
    
    print("took ``system.milliseconds - start`` ms");
}
