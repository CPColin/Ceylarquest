import com.crappycomic.ceylarquest.model {
    Board,
    Color,
    Game,
    Node,
    Ownable
}

"A visual representation of a [[Game]] state. Does not include the background of the [[Board]]."
shared class BoardOverlay(GraphicsContext g) {
    Color white = [255, 255, 255];
    
    shared void highlightNodes(Board board) {
        value nodes = board.nodes.keys;
        
        for (node in nodes) {
            for (destination in board.getDestinations(node)) {
                g.drawLine(node.location, destination.location, white, 2);
            }
        }
        
        for (node in nodes) {
            Color color = if (is Ownable node) then node.deedGroup.color else white;
            
            g.fillCircle(node.location, 20, color);
        }
    }
}
