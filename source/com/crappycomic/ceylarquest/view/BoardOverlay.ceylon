import com.crappycomic.ceylarquest.model {
    Board,
    Color,
    Game,
    Ownable
}

"A visual representation of a [[Game]] state. Does not include the background of the [[Board]]."
shared class BoardOverlay(Board board, GraphicsContext g) {
    Color white = [255, 255, 255];
    
    // Temporary, for debugging
    shared void highlightNodes(Integer width = 20) {
        g.clear();
        
        value nodes = board.nodes.keys;
        
        for (node in nodes) {
            for (destination in board.getDestinations(node)) {
                g.drawLine(node.location, destination.location, white, 2);
            }
        }
        
        for (node in nodes) {
            Color color = if (is Ownable node) then node.deedGroup.color else white;
            
            g.fillCircle(node.location, color, width);
        }
    }
    
    // Temporary, for debugging
    shared void drawClosestNode(Integer x, Integer y, Integer width, Integer height) {
        value closestNode = board.calculateClosestNode(x, y);
        value nodeHash = closestNode.hash;
        value color = [255 - (nodeHash * 2), (nodeHash * 37) % 256, nodeHash * 3];
        
        g.fillRect([x, y], color, width, height);
    }
}
