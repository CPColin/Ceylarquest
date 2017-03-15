import com.crappycomic.ceylarquest.model {
    Game,
    loadGame
}
import com.crappycomic.ceylarquest.view {
    manual
}

import debug {
    debugGameJson
}

import javax.swing {
    JFrame,
    JScrollPane,
    JTextPane
}

"Creates, shows, and returns a [[JFrame]] that displays the instruction [[manual]] for the given
 [[game]], optionally centering the frame over the given [[parent]]."
JFrame manualFrame(Game game, JFrame? parent = null) {
    value frame = JFrame("Instruction Manual");
    value textPane = JTextPane();
    
    textPane.editable = false;
    textPane.contentType = "text/html";
    textPane.text = manual.render(game);
    textPane.caretPosition = 0;
    
    frame.contentPane = JScrollPane(textPane);
    
    frame.setSize(640, 480);
    frame.setLocationRelativeTo(parent);
    frame.visible = true;
    
    return frame;
}

shared void testManualFrame() {
    value game = loadGame(debugGameJson);
    
    assert (is Game game);
    
    value frame = manualFrame(game);
    
    frame.defaultCloseOperation = JFrame.exitOnClose;
}
