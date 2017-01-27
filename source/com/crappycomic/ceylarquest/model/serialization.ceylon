import ceylon.json {
    JsonObject,
    InvalidTypeException,
    parse
}

import ceylon.language.meta {
    modules
}

shared class InvalidSave(String message) {
    string => message;
}

shared Game|InvalidSave loadGame(String json) {
    try {
        assert (is JsonObject jsonObject = parse(json));
        
        value board = loadBoard(jsonObject);
        value players = loadPlayers(jsonObject);
        value activePlayers = loadActivePlayers(jsonObject);
        value ownedNodes = loadOwnedNodes(jsonObject, board);
        value placedFuelStations = loadPlacedFuelStations(jsonObject, board);
        value playerLocations = loadPlayerLocations(jsonObject, board);
        
        return Game {
            board = board;
            playerNames = players;
            activePlayers = activePlayers;
            ownedNodes = ownedNodes;
            placedFuelStations = placedFuelStations;
            playerLocations = playerLocations;
        };
    }
    catch (AssertionError | InvalidTypeException e) {
        return InvalidSave(e.message);
    }
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{Player*} loadActivePlayers(JsonObject jsonObject) {
    value activePlayers = jsonObject.getArrayOrNull("activePlayers");
    
    if (exists activePlayers) {
        return activePlayers.narrow<String>().map((playerKey) => resolvePlayer(playerKey));
    }
    else {
        return {};
    }
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
Board loadBoard(JsonObject jsonObject) {
    value board = jsonObject.getObject("board");
    value boardModuleName = board.getString("moduleName");
    value boardPackageName = board.getString("packageName");
    value boardObjectName = board.getString("objectName");
    
    value boardModule = modules.list.find((mod) => mod.name == boardModuleName);
    
    assert (exists boardModule);
    
    value boardPackage = boardModule.findPackage(boardPackageName);
    
    assert (exists boardPackage);
    
    value boardObjectDeclaration = boardPackage.getValue(boardObjectName);
    
    assert (exists boardObjectDeclaration);
    
    value boardObject = boardObjectDeclaration.get();
    
    assert (is Board boardObject);
    
    return boardObject;
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Node -> Player>*} loadOwnedNodes(JsonObject jsonObject, Board board) {
    value ownedNodes = jsonObject.getObject("ownedNodes");
    
    return ownedNodes.map((nodeKey -> _)
        => resolveNode(board, nodeKey) -> resolvePlayer(ownedNodes.getString(nodeKey)));
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{Node*} loadPlacedFuelStations(JsonObject jsonObject, Board board) {
    value placedFuelStations = jsonObject.getArray("placedFuelStations");
    
    return placedFuelStations.narrow<String>().map((nodeKey) => resolveNode(board, nodeKey));
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Player -> Node>*} loadPlayerLocations(JsonObject jsonObject, Board board) {
    value playerLocations = jsonObject.getObject("playerLocations");
    
    return playerLocations.map((playerKey -> _)
        => resolvePlayer(playerKey) -> resolveNode(board, playerLocations.getString(playerKey)));
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Player -> String>*} loadPlayers(JsonObject jsonObject) {
    value players = jsonObject.getObject("players");
    
    return players.map((playerKey -> _)
        => resolvePlayer(playerKey) -> players.getString(playerKey));
}

Node resolveNode(Board board, String key) {
    value node = board.getNode(key);
    
    return node else board.start;
}

Player resolvePlayer(String key) {
    value playerDeclaration = `package com.crappycomic.ceylarquest.model`.getValue(key);
    
    assert (exists playerDeclaration);
    
    value player = playerDeclaration.get();
    
    assert (is Player player);
    
    return player;
}
