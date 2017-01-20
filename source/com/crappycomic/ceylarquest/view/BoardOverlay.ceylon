import ceylon.numeric.float {
    cos,
    pi,
    sin
}

import com.crappycomic.ceylarquest.model {
    Board,
    Color,
    Game,
    Location,
    Ownable
}

"A visual representation of a [[Game]] state. Does not include the background of the [[Board]]."
shared class BoardOverlay(Game game, GraphicsContext g) {
    // TODO: be nice to define this in terms of the board image size
    Integer playerRadius = 10;
    
    // TODO: this too
    Integer playerStroke = 2;
    
    "Draws every [[game.activePlayers|active player]] at their current locations."
    shared void drawActivePlayers() {
        value locations = game.activePlayers.group((player) => game.playerLocation(player));
        
        for (node -> players in locations) {
            value playerCount = players.size;
            
            players.indexed.each((index -> player) {
                value center = playerCenter(node.location, index, playerCount);
                
                g.fillCircle(center, player.color, playerRadius);
                g.drawCircle(center, black, playerRadius, playerStroke);
            });
        }
    }
    
    Location playerCenter(Location nodeCenter, Integer player, Integer players) {
        if (players == 1) {
            return nodeCenter;
        }
        else {
            Float radius = playerRadius / sin(pi / players);
            Float theta = 2 * pi * player / players; // TODO: phase
            
            return [(nodeCenter[0] + radius * cos(theta)).integer,
                (nodeCenter[1] - radius * sin(theta)).integer];
        }
    }
    
    // Temporary, for debugging
    shared void highlightNodes(Integer width = 20) {
        value nodes = game.board.nodes.keys;
        
        for (node in nodes) {
            for (destination in game.board.getDestinations(node)) {
                g.drawLine(node.location, destination.location, white, 2);
            }
        }
        
        for (node in nodes) {
            Color color = if (is Ownable node) then node.deedGroup.color else white;
            
            g.fillCircle(node.location, color.withAlpha(192), width);
        }
    }
    
    // Temporary, for debugging
    shared void drawClosestNode(Integer x, Integer y, Integer width, Integer height) {
        value closestNode = game.board.calculateClosestNode(x, y);
        value nodeHash = closestNode.hash;
        value color = Color(255 - (nodeHash * 2), (nodeHash * 37) % 256, nodeHash * 3);
        
        g.fillRect([x, y], color, width, height);
    }
}
