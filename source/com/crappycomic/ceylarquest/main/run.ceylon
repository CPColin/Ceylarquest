import ceylon.interop.java {
    javaString
}

import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    Color,
    DrewCard,
    Game,
    InvalidSave,
    PreLand,
    Result,
    loadGame,
    preRoll,
    drawingCard
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

late variable Game game;

shared void run() {
    value game = loadGame(debugGameJson);
    
    switch (game)
    case (is InvalidSave) {
        print("Invalid save: " + game.string);
    }
    case (is Game) {
        package.game = game;
        
        overlay();
    }
}

variable BufferedImage? closestNodes = null;

late BoardPanel boardPanel;

void overlay() {
    value frame = JFrame();
    
    boardPanel = BoardPanel();
    boardPanel.preferredSize = Dimension(1280, 1280);
    
    frame.title = "Ceylarquest Debug Stuff";
    frame.defaultCloseOperation = JFrame.exitOnClose;
    frame.setMinimumSize(Dimension(640, 640));
    frame.setLocationRelativeTo(null);
    frame.extendedState = JFrame.maximizedBoth;
    frame.layout = BorderLayout();
    
    frame.add(userActionPanel, javaString(BorderLayout.north));
    frame.add(JScrollPane(boardPanel), javaString(BorderLayout.center));
    
    userActionPanel.showPreRollPanel(game);

    frame.visible = true;
    
    //value executorService = Executors.newSingleThreadExecutor();
    //
    //executorService.submit(calculateClosestNodes);
}

void updateView(Result result) {
    if (is Game result) {
        game = result;
        
        value phase = game.phase;
        
        boardPanel.paths = null;
        
        switch (phase)
        case (is ChoosingAllowedMove) {
            boardPanel.paths = phase.paths;
            userActionPanel.showChoosingAllowedMovePanel(phase.paths, phase.fuel);
        }
        case (is DrewCard) {
            userActionPanel.showDrewCardPanel(game, phase.card);
        }
        //case (is PreLand) {
        //    userActionPanel.showPreLandPanel(game);
        //}
        case (drawingCard) {
            userActionPanel.showDrawingCardPanel(game);
        }
        case (preRoll) {
            userActionPanel.showPreRollPanel(game);
        }
        else {
            // TODO: temporary, for testing
            game = game.with {
                currentPlayer = game.nextPlayer;
                phase = preRoll;
            };
            userActionPanel.showPreRollPanel(game);
            // TODO: remove this block once the above cases are exhaustive
        }
        
        boardPanel.repaint();
    }
    else {
        print(result.message);
    }
}

void calculateClosestNodes() {
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
            value closestNode = calculateClosestNode(game.board, x, y);
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
