import ceylon.language.meta {
    classDeclaration
}
import ceylon.numeric.float {
    pi
}

import com.crappycomic.ceylarquest.model {
    Color,
    Game,
    InvalidSave,
    Location,
    loadGame
}
import com.crappycomic.ceylarquest.model.logic {
    allowedMoves
}
import com.crappycomic.ceylarquest.view {
    BoardOverlay,
    GraphicsContext,
    LineCap,
    LineJoin,
    bevelJoin,
    buttCap,
    miterJoin,
    roundCap,
    roundJoin,
    squareCap
}

import debug {
    debugGameJson
}

dynamic JsCanvas {
    shared formal Integer width;
    shared formal Integer height;
    
    shared formal JsContext getContext(String type);
}

dynamic JsContext {
    shared formal variable String fillStyle;
    shared formal variable String lineCap;
    shared formal variable String lineJoin;
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

object g satisfies GraphicsContext {
    shared actual void clear() {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.clearRect(0, 0, canvas.width, canvas.height);
    }
    
    shared actual void drawCircle(Location center, Color color, Integer radius, Integer width) {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.lineWidth = width;
        context.strokeStyle = rgba(color);
        
        context.beginPath();
        context.arc(center[0], center[1], radius, 0.0, 2.0 * pi);
        
        context.stroke();
    }
    
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
    
    shared actual void drawPath({Location*} locations, Color color, Integer width,
            LineCap lineCap, LineJoin lineJoin) {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.lineCap = switch (lineCap)
            case (buttCap) "butt"
            case (roundCap) "round"
            case (squareCap) "square";
        context.lineJoin = switch (lineJoin)
            case (bevelJoin) "bevel"
            case (miterJoin) "miter"
            case (roundJoin) "round";
        context.lineWidth = width;
        context.strokeStyle = rgba(color);
        
        context.beginPath();
        locations.each((location) => context.lineTo(location[0], location[1]));
        
        context.stroke();
    }
    
    shared actual void fillCircle(Location center, Color color, Integer radius) {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.fillStyle = rgba(color);
        
        context.beginPath();
        context.arc(center[0], center[1], radius, 0.0, 2.0 * pi);
        
        context.fill();
    }
    
    shared actual void fillRect(Location topLeft, Color color, Integer width, Integer height) {
        value canvas = getCanvas();
        value context = getContext(canvas);
        
        context.fillStyle = rgba(color);
        
        context.fillRect(topLeft[0], topLeft[1], width, height);
    }
    
    String rgba(Color color)
        => "rgba(``color.red``, ``color.green``, ``color.blue``, ``color.alpha.float / 255``)";
}

Game game = loadDebugGame();

Game loadDebugGame() {
    value game = loadGame(debugGameJson);
    
    if (is InvalidSave game) {
        throw Exception(game.string);
    }
    else {
        return game;
    }
}

BoardOverlay boardOverlay = BoardOverlay(g);

shared void clear() {
    g.clear();
}

shared void drawActivePlayers() {
    clear();
    boardOverlay.drawActivePlayers(game);
}

shared void colorNodes() {
    clear();
    boardOverlay.colorNodes(game, getParameter());
}

shared void drawAllowedMoves() {
    value player = game.currentPlayer;
    value paths = allowedMoves(game.board, game.playerLocation(player), getParameter());
    
    clear();
    boardOverlay.drawPaths(player, paths);
}

variable Integer nodeAreaX = 0;
variable Integer nodeAreaY = 0;
variable Integer nodeAreaRadius = 0;

shared void drawNodeAreas() {
    nodeAreaX = 0;
    nodeAreaY = 0;
    nodeAreaRadius = getParameter();
    
    value canvas = getCanvas();
    value context = getContext(canvas);
    
    clear();
    calculateNodeAreas(context, canvas.width, canvas.height);
}

void calculateNodeAreas(JsContext context, Integer width, Integer height) {
    boardOverlay.drawClosestNode(game, nodeAreaX, nodeAreaY, nodeAreaRadius, nodeAreaRadius);
    
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

JsCanvas getCanvas() {
    dynamic {
        return document.getElementById("board");
    }
}

JsContext getContext(JsCanvas canvas) {
    return canvas.getContext("2d");
}

Integer getParameter() {
    dynamic {
        value parameter = Integer.parse(document.getElementById("parameter").\ivalue);
        
        return if (is Integer parameter) then parameter else 0;
    }
}

shared void setImages() {
    dynamic {
        value resourcePath = classDeclaration(game.board).containingModule.name.replace(".", "/");
        
        dynamic bodies = document.getElementsByTagName("body");
        dynamic body = bodies[0];
        
        body.style.background = "url(``resourcePath``/background.png) black fixed";
        
        dynamic canvas = getCanvas();
        
        canvas.style.background = "url(``resourcePath``/foreground.png)";
    }
}
