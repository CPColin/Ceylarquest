import ceylon.json {
    JsonObject
}

import com.crappycomic.ceylarquest.model {
    Board,
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
    Graphics,
    Graphics2D
}

import javax.swing {
    JFrame,
    JPanel
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

class JavaGraphicsContext(Graphics2D g) satisfies GraphicsContext {
    shared actual void drawLine(Location from, Location to, Color color, Integer width) {
        value stroke = g.stroke;
        
        g.stroke = BasicStroke(width.float);
        g.color = awtColor(color, 255);
        
        g.drawLine(from[0], from[1], to[0], to[1]);
        
        // TODO: care about resetting the stroke?
        g.stroke = stroke;
    }
    
    shared actual void fillCircle(Location center, Integer radius, Color color) {
        value diameter = radius * 2;
        
        g.color = awtColor(color, 128);
        
        g.fillOval(center[0] - radius, center[1] - radius, diameter, diameter);
    }
    
    AwtColor awtColor(Color color, Integer alpha = 255)
        => AwtColor(color[0], color[1], color[2], alpha);
}

class BoardPanel() extends JPanel() {
    shared actual void paint(Graphics g) {
        assert (is Graphics2D g);
        
        BoardOverlay(JavaGraphicsContext(g)).highlightNodes(game.board);
    }
}

void overlay() {
    value frame = JFrame();
    value panel = BoardPanel();
    
    frame.setSize(1280, 1280);
    frame.add(panel);
    frame.defaultCloseOperation = JFrame.exitOnClose;
    frame.visible = true;
}
