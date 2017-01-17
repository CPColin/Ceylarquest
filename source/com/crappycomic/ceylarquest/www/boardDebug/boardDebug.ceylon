import com.crappycomic.ceylarquest.model {
    Board,
    Color,
    Node,
    Ownable,
    Location
}

import com.crappycomic.ceylarquest.view {
    BoardOverlay,
    GraphicsContext
}

import com.crappycomic.tropichop {
    tropicHopBoard
}

dynamic JsCanvas {
    shared formal Integer width;
    shared formal Integer height;
    
    shared formal JsContext getContext(String type);
}

dynamic JsContext {
    shared formal variable String fillStyle;
    shared formal variable Integer lineWidth;
    shared formal variable String strokeStyle;
    
    shared formal void arc(Integer centerX, Integer centerY, Integer radius, Float startAngle,
        Float endAngle, Boolean counterclockwise = false);
    shared formal void beginPath();
    shared formal void clearRect(Integer x, Integer y, Integer width, Integer height);
    shared formal void fill();
    shared formal void fillRect(Integer x, Integer y, Integer width, Integer height);
    shared formal void lineTo(Integer x, Integer y);
    shared formal void moveTo(Integer x, Integer y);
    shared formal void stroke();
}

Float pi() {
    dynamic {
        return Math.PI;
    }
}

object g satisfies GraphicsContext {
    shared actual void drawLine(Location from, Location to, Color color, Integer width) {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.lineWidth = width;
        context.strokeStyle = rgba(color);
        
        context.beginPath();
        context.moveTo(from[0], from[1]);
        context.lineTo(to[0], to[1]);
        
        context.stroke();
    }
    
    shared actual void fillCircle(Location center, Integer radius, Color color) {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.fillStyle = rgba(color, 0.5);
        
        context.beginPath();
        context.arc(center[0], center[1], radius, 0.0, 2.0 * pi());
        
        context.fill();
    }
    
    String rgba(Color color, Float alpha = 1.0)
        => "rgba(``color[0]``, ``color[1]``, ``color[2]``, ``alpha``)";
}

Board board = tropicHopBoard;

shared void clear() {
    dynamic { console.log("clearing"); }
    
    value canvas = getCanvas();
    value context = getContext(canvas);
    
    dynamic {
        console.log(canvas);
        console.log(context);
    }
    
    context.clearRect(0, 0, canvas.width, canvas.height);
}

shared void highlightNodes() {
    value boardOverlay = BoardOverlay(g);
    
    boardOverlay.highlightNodes(board);
}

variable Integer nodeAreaX = 0;
variable Integer nodeAreaY = 0;
variable Integer nodeAreaRadius = 0;

shared void drawNodeAreas() {
    nodeAreaX = 0;
    nodeAreaY = 0;
    nodeAreaRadius = getRadius();
    
    value canvas = getCanvas();
    value context = getContext(canvas);
    
    clear();
    calculateNodeAreas(context, canvas.width, canvas.height);
}

void calculateNodeAreas(JsContext context, Integer width, Integer height) {
    Node node = calculateClosestNode(nodeAreaX, nodeAreaY);
    Integer nodeHash = node.hash;
    Integer r = 255 - (nodeHash * 2);
    Integer g = (nodeHash * 37) % 256;
    Integer b = nodeHash * 3;
    
    context.fillStyle = "rgba(``r``, ``g``, ``b``, 0.75)";
    context.fillRect(nodeAreaX, nodeAreaY, nodeAreaRadius, nodeAreaRadius);
    
    nodeAreaX += nodeAreaRadius;
    
    if (nodeAreaX >= width) {
        nodeAreaX = 0;
        nodeAreaY += nodeAreaRadius;
    }
    
    if (nodeAreaY < height) {
        dynamic {
            setTimeout(void() {calculateNodeAreas(context, width, height);}, 0);
        }
    }
}

String getFillStyle(Ownable ownable) {
    value [red, green, blue] = ownable.deedGroup.color;
    
    return "rgba(``red``, ``green``, ``blue``, 0.75)";
}

JsCanvas getCanvas() {
    dynamic {
        return document.getElementById("board");
    }
}

JsContext getContext(JsCanvas canvas) {
    return canvas.getContext("2d");
}

Integer getRadius() {
    dynamic {
        value radius = Integer.parse(document.getElementById("radius").\ivalue);
        
        return if (is Integer radius) then radius else 0;
    }
}

Node calculateClosestNode(Integer x0, Integer y0) {
    value closestNode
        = board.nodes.keys
            .map((Node node) => [node, calculateDistance(x0, y0, *node.location)])
            .sort(byIncreasing(([Node, Integer] node) => node[1]))
            .first;
    
    assert (exists closestNode);
    
    return closestNode[0];
}

Integer calculateDistance(Integer x0, Integer y0, Integer x1, Integer y1) {
    return ((x1 - x0) ^ 2 + (y1 - y0) ^ 2);
}
