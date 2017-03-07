import ceylon.language.meta {
    classDeclaration
}
import ceylon.numeric.float {
    pi
}

import com.crappycomic.ceylarquest.controller {
    Controller
}
import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    Color,
    Game,
    InvalidSave,
    Location,
    Ownable,
    loadGame
}
import com.crappycomic.ceylarquest.model.logic {
    allowedMoves,
    applyCard,
    applyRoll,
    condemnNode,
    drawCard,
    endTurn,
    finishSettlingDebts,
    landOnNode,
    loseNodeToLeague,
    placeFuelStation,
    purchaseFuelStation,
    purchaseNode,
    rollDice,
    sellFuelStation,
    sellNode,
    settleDebtWithCash,
    traversePath,
    winNodeFromLeague,
    winNodeFromPlayer
}
import com.crappycomic.ceylarquest.view {
    GraphicsContext,
    LineCap,
    LineJoin,
    bevelJoin,
    boardOverlay,
    buttCap,
    miterJoin,
    roundCap,
    roundJoin,
    squareCap
}
import com.crappycomic.tropichop {
    tropicHopBoard
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
}

shared variable Game game = loadDebugGame();

Game loadDebugGame() {
    /*
     TODO File a bug report for this:
     The com.crappycomic.tropichop module is loaded via the debug module in Java mode, but the
     browser gets a "module X not available" error. Manually touching the module, for now.
     */ 
    suppressWarnings("unusedDeclaration")
    value board = tropicHopBoard;
    value game = loadGame(debugGameJson);
    
    if (is InvalidSave game) {
        throw Exception(game.string);
    }
    else {
        return game;
    }
}

late Controller controller;

shared void clear() {
    g.clear();
}

shared void createController() {
    value playerInfoPanels = [
        for (player in game.allPlayers)
            PlayerInfoPanel(game, player)
    ];
    
    playerInfoPanels.each((playerInfoPanel) => playerInfoPanel.createPanel(game));
    
    controller = Controller(game, userActionPanel, playerInfoPanels,
        (game) {
            g.clear();
            boardOverlay.draw(g, game);
        });
    
    controller.updateGame();
}

shared void doApplyCard() {
    controller.updateGame(applyCard(game));
}

shared void doApplyRoll() {
    controller.updateGame(applyRoll(game));
}

shared void doCancelChoosingNode() {
    controller.updateGame(game);
}

shared void doCondemnNode() {
    controller.updateGame(condemnNode(game));
}

shared void doDrawCard() {
    controller.updateGame(drawCard(game));
}

shared void doEndTurn() {
    controller.updateGame(endTurn(game));
}

shared void doFinishSettlingDebts() {
    controller.updateGame(finishSettlingDebts(game));
}

shared void doLandOnNode() {
    controller.updateGame(landOnNode(game));
}

shared void doLoseNodeToLeague(String? nodeId) {
    controller.updateGame(loseNodeToLeague(game, game.board.node(nodeId)));
}

shared void doPlaceFuelStation(String? nodeId) {
    controller.updateGame(placeFuelStation(game, game.board.node(nodeId)));
}

shared void doPurchaseFuelStation() {
    controller.updateGame(purchaseFuelStation(game));
}

shared void doPurchaseNode() {
    controller.updateGame(purchaseNode(game));
}

shared void doResign() {
    controller.updateGame(game.without(game.currentPlayer));
}

shared void doRollDice() {
    controller.updateGame(rollDice(game));
}

shared void doSellFuelStation() {
    controller.updateGame(sellFuelStation(game));
}

shared void doSellNode(String? nodeId) {
    value node = game.board.node(nodeId);
    
    if (is Ownable node) {
        controller.updateGame(sellNode(game, node));
    }
    else {
        controller.updateGame(game);
    }
}

shared void doSettleDebtWithCash() {
    controller.updateGame(settleDebtWithCash(game));
}

shared void doTraversePath(String nodeId) {
    value phase = game.phase;
    
    assert (is ChoosingAllowedMove phase);
    
    value node = game.board.node(nodeId);
    
    assert (exists node);
    
    value path = phase.paths.find((path) => path.last == node);
    
    assert (exists path);
    
    controller.updateGame(traversePath(game, path));
}

shared void doWinNodeFromLeague(String? nodeId) {
    controller.updateGame(winNodeFromLeague(game, game.board.node(nodeId)));
}

shared void doWinNodeFromPlayer(String? nodeId) {
    controller.updateGame(winNodeFromPlayer(game, game.board.node(nodeId)));
}

shared void drawActivePlayers() {
    clear();
    boardOverlay.drawActivePlayers(g, game);
}

shared void colorNodes() {
    clear();
    boardOverlay.colorNodes(g, game, getParameter());
}

shared void drawAllowedMoves() {
    value player = game.currentPlayer;
    value paths = allowedMoves(game.board, game.playerLocation(player), getParameter());
    
    clear();
    boardOverlay.drawPaths(g, player, paths);
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
    boardOverlay.drawClosestNode(g, game, nodeAreaX, nodeAreaY, nodeAreaRadius, nodeAreaRadius);
    
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
