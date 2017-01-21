import com.crappycomic.ceylarquest.model {
    Color,
    Game,
    InvalidSave,
    loadGame
}
import com.crappycomic.ceylarquest.view {
    black
}

import debug {
    debugGameJson
}

import java.awt {
    Dimension
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

late Game game;

shared void run() {
    value game = loadGame(debugGameJson);
    
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

variable BufferedImage? closestNodes = null;

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
    
    //value executorService = Executors.newSingleThreadExecutor();
    //
    //executorService.submit(calculateClosestNodes);
}

void calculateClosestNodes() {
    value start = system.milliseconds;
    value image = BufferedImage(1280, 1280, BufferedImage.typeIntRgb);
    value graphics = image.createGraphics();
    value context = JavaGraphicsContext(graphics, image.width, image.height);
    
    context.fillRect([0, 0], black, image.width, image.height);
    
    package.closestNodes = image;
    
    value executorService = Executors.newSingleThreadScheduledExecutor();
    
    executorService.scheduleAtFixedRate(() => panel.repaint(), 1, 1, TimeUnit.seconds);
    
    for (x in 0..image.width) {
        for (y in 0..image.height) {
            value closestNode = game.board.calculateClosestNode(x, y);
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
    
    panel.repaint();
    
    print("took ``system.milliseconds - start`` ms");
}
