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
        value rules = loadRules(jsonObject);
        value activePlayers = loadActivePlayers(jsonObject);
        value owners = loadOwners(jsonObject, board);
        value placedFuelStations = loadPlacedFuelStations(jsonObject, board);
        value playerLocations = loadPlayerLocations(jsonObject, board);
        
        return Game {
            board = board;
            playerNames = players;
            rules = rules;
            activePlayers = activePlayers;
            owners = owners;
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
    
    return loadObject<Board>(board);
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
Type loadObject<Type>(JsonObject jsonObject) {
    value moduleName = jsonObject.getString("moduleName");
    value packageName = jsonObject.getString("packageName");
    value objectName = jsonObject.getString("objectName");
    
    value objectModule = modules.list.find((mod) => mod.name == moduleName);
    
    assert (exists objectModule);
    
    value objectPackage = objectModule.findPackage(packageName);
    
    assert (exists objectPackage);
    
    value objectDeclaration = objectPackage.getValue(objectName);
    
    assert (exists objectDeclaration);
    
    value objectValue = objectDeclaration.get();
    
    assert (is Type objectValue);
    
    return objectValue;
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Node -> Player>*} loadOwners(JsonObject jsonObject, Board board) {
    value owners = jsonObject.getObject("owners");
    
    return owners.map((nodeKey -> _)
        => resolveNode(board, nodeKey) -> resolvePlayer(owners.getString(nodeKey)));
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

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
Rules loadRules(JsonObject jsonObject) {
    value rules = jsonObject.getObject("rules");
    
    return loadObject<Rules>(rules);
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
