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
    Node,
    Ownable,
    Path,
    Player
}

import com.crappycomic.ceylarquest.model.logic {
    destinations
}

"A visual representation of a [[Game]] state. Does not include the background of the [[Board]]."
shared class BoardOverlay(GraphicsContext g) {
    Color fuelStationColor = Color(192, 192, 192);
    
    // TODO: It would be nice to define all of these dimensions in terms of the board image size.
    
    Integer nodeRadius = 20;
    
    Integer fuelStationStroke = nodeRadius / 5;
    
    Integer highlightRadius = nodeRadius + fuelStationStroke;
    
    Integer highlightStroke = highlightRadius / 4;
    
    Integer playerRadius = nodeRadius / 2;
    
    Integer playerStroke = playerRadius / 5;
    
    "Draws every [[active player|Game.activePlayers]] at their current locations."
    shared void drawActivePlayers(Game game) {
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
    
    "Colors every [[owned node|Game.owners]] according to the player who owns it."
    shared void drawOwnedNodes(Game game) {
        for (node -> owner in game.owners) {
            if (is Player owner) {
                g.fillCircle(node.location, owner.color.withAlpha(128), nodeRadius);
            }
        }
    }
    
    "Draws every fuel station that has been placed on the board."
    shared void drawPlacedFuelStations(Game game) {
        for (node in game.placedFuelStations) {
            g.drawCircle(node.location, fuelStationColor, nodeRadius, fuelStationStroke);
        }
    }
    
    "Returns the location of the given [[player]], given how many [[players]] are currently at the
     same node. The players will be arranged such that no space exists between them and they are all
     equidistant from the [[center of the given node|nodeCenter]]."
    Location playerCenter(Location nodeCenter, Integer player, Integer players) {
        if (players == 1) {
            return nodeCenter;
        }
        else {
            Float radius = playerRadius / sin(pi / players);
            Float theta = 2 * pi * player / players;
            
            return [(nodeCenter[0] + radius * cos(theta)).integer,
                (nodeCenter[1] - radius * sin(theta)).integer];
        }
    }
    
    // Temporary stuff, for debugging
    
    shared void colorNodes(Game game, Integer width = 20) {
        value nodes = game.board.nodes.keys;
        
        for (node in nodes) {
            for (destination in destinations(game.board, node)) {
                g.drawLine(node.location, destination.location, white, 2);
            }
        }
        
        for (node in nodes) {
            Color color = if (is Ownable node) then node.deedGroup.color else white;
            
            g.fillCircle(node.location, color.withAlpha(192), width);
        }
    }
    
    shared void drawClosestNode(Game game, Integer x, Integer y, Integer width, Integer height) {
        value closestNode = calculateClosestNode(game.board, x, y);
        value nodeHash = closestNode.hash;
        value color = Color(255 - (nodeHash * 2), (nodeHash * 37) % 256, nodeHash * 3);
        
        g.fillRect([x, y], color, width, height);
    }
    
    shared void drawPaths(Player player, {Path*} paths) {
        paths.each((path) => g.drawPath(path.map(Node.location), player.color.withSaturation(0.75),
            13, roundCap, roundJoin));
        paths.each((path) => g.drawPath(path.map(Node.location), player.color.withValue(0.75),
            7, roundCap, roundJoin));
    }
    
    shared void highlightNodes(Game game) {
        for (node in game.board.nodes.keys) {
            g.drawCircle(node.location, white, highlightRadius, highlightStroke);
        }
    }
}
