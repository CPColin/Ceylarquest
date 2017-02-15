import ceylon.interop.java {
    javaString
}

import com.crappycomic.ceylarquest.controller {
    Controller
}
import com.crappycomic.ceylarquest.model {
    Board,
    Color,
    Game,
    InvalidSave,
    loadGame
}
import com.crappycomic.ceylarquest.view {
    black,
    calculateClosestNode
}

import debug {
    debugGameJson
}

import java.awt {
    Dimension,
    BorderLayout
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
    JScrollPane
}

late Controller controller;

shared void run() {
    value game = loadGame(debugGameJson);
    
    switch (game)
    case (is InvalidSave) {
        print("Invalid save: " + game.string);
    }
    case (is Game) {
        value boardPanel = BoardPanel(game.board);
        
        controller = Controller(game, userActionPanel, () => boardPanel.repaint());
        
        value frame = overlay(game, boardPanel);
        
        controller.updateGame(game);
        
        frame.visible = true;
    }
}

variable BufferedImage? closestNodes = null;

JFrame overlay(Game game, BoardPanel boardPanel) {
    value frame = JFrame();
    
    boardPanel.preferredSize = Dimension(1280, 1280);
    
    frame.title = "Ceylarquest Debug Stuff";
    frame.defaultCloseOperation = JFrame.exitOnClose;
    frame.setMinimumSize(Dimension(640, 640));
    frame.setLocationRelativeTo(null);
    frame.extendedState = JFrame.maximizedBoth;
    frame.layout = BorderLayout();
    
    frame.add(userActionPanel, javaString(BorderLayout.north));
    frame.add(JScrollPane(boardPanel), javaString(BorderLayout.center));
    
    //value executorService = Executors.newSingleThreadExecutor();
    //
    //executorService.submit(calculateClosestNodes(game.board, boardPanel));
    
    return frame;
}

void calculateClosestNodes(Board board, BoardPanel boardPanel)() {
    value start = system.milliseconds;
    value image = BufferedImage(1280, 1280, BufferedImage.typeIntRgb);
    value graphics = image.createGraphics();
    value context = JavaGraphicsContext(graphics, image.width, image.height);
    
    context.fillRect([0, 0], black, image.width, image.height);
    
    package.closestNodes = image;
    
    value executorService = Executors.newSingleThreadScheduledExecutor();
    
    executorService.scheduleAtFixedRate(() => boardPanel.repaint(), 1, 1, TimeUnit.seconds);
    
    for (x in 0..image.width) {
        for (y in 0..image.height) {
            value closestNode = calculateClosestNode(board, x, y);
            value nodeHash = closestNode.id.hash.magnitude;
            
            value color = Color(
                (nodeHash * 13) % 256,
                (nodeHash * 3) % 256,
                (nodeHash * 37) % 256
            );
            
            context.fillRect([x, y], color, 1, 1);
        }
    }
    
    graphics.dispose();
    
    boardPanel.repaint();
    
    print("took ``system.milliseconds - start`` ms");
}
