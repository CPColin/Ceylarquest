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
        value players = loadPlayerNames(jsonObject);
        
        value activePlayers = loadPlayers(jsonObject, "activePlayers");
        value allPlayers = loadPlayers(jsonObject, "allPlayers");
        value currentPlayer = loadCurrentPlayer(jsonObject);
        value owners = loadOwners(jsonObject, board);
        value placedFuelStations = loadPlacedFuelStations(jsonObject, board);
        value playerFuels = loadPlayerFuels(jsonObject);
        value playerLocations = loadPlayerLocations(jsonObject, board);
        
        return Game {
            board = board;
            playerNames = players;
            
            activePlayers = activePlayers;
            allPlayers = allPlayers;
            currentPlayer = currentPlayer;
            owners = owners;
            phase = null; // TODO
            playerCashes = null; // TODO
            playerFuels = playerFuels;
            placedFuelStations = placedFuelStations;
            playerFuelStationCounts = null; // TODO
            playerLocations = playerLocations;
            rules = null; // TODO
        };
    }
    catch (AssertionError | InvalidTypeException e) {
        return InvalidSave(e.message);
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
Player? loadCurrentPlayer(JsonObject jsonObject) {
    value currentPlayer = jsonObject.getStringOrNull("currentPlayer");
    
    return if (exists currentPlayer) then resolvePlayer(currentPlayer) else null;
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
{<Node -> Player>*}? loadOwners(JsonObject jsonObject, Board board) {
    value owners = jsonObject.getObjectOrNull("owners");
    
    if (exists owners) {
        return owners.map((nodeKey -> _)
            => resolveNode(board, nodeKey) -> resolvePlayer(owners.getString(nodeKey)));
    }
    else {
        return null;
    }
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{Node*}? loadPlacedFuelStations(JsonObject jsonObject, Board board) {
    value placedFuelStations = jsonObject.getArrayOrNull("placedFuelStations");
    
    if (exists placedFuelStations) {
        return placedFuelStations.narrow<String>().map((nodeKey) => resolveNode(board, nodeKey));
    }
    else {
        return null;
    }
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Player -> Integer>*}? loadPlayerFuels(JsonObject jsonObject) {
    value playerFuels = jsonObject.getObjectOrNull("playerFuels");
    
    if (exists playerFuels) {
        return playerFuels.map((playerKey -> _)
            => resolvePlayer(playerKey) -> playerFuels.getInteger(playerKey));
    }
    else {
        return null;
    }
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Player -> Node>*}? loadPlayerLocations(JsonObject jsonObject, Board board) {
    value playerLocations = jsonObject.getObjectOrNull("playerLocations");
    
    if (exists playerLocations) {
        return playerLocations.map((playerKey -> _)
            => resolvePlayer(playerKey)
                -> resolveNode(board, playerLocations.getString(playerKey)));
    }
    else {
        return null;
    }
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{<Player -> String>*} loadPlayerNames(JsonObject jsonObject) {
    value playerNames = jsonObject.getObject("playerNames");
    
    return playerNames.map((playerKey -> _)
        => resolvePlayer(playerKey) -> playerNames.getString(playerKey));
}

throws(`class AssertionError`)
throws(`class InvalidTypeException`)
{Player*}? loadPlayers(JsonObject jsonObject, String key) {
    value players = jsonObject.getArrayOrNull(key);
    
    if (exists players) {
        return players.narrow<String>().map((playerKey) => resolvePlayer(playerKey));
    }
    else {
        return null;
    }
}

Node resolveNode(Board board, String key) {
    value node = board.node(key);
    
    return node else board.start;
}

Player resolvePlayer(String key) {
    value playerDeclaration = `package com.crappycomic.ceylarquest.model`.getValue(key);
    
    assert (exists playerDeclaration);
    
    value player = playerDeclaration.get();
    
    assert (is Player player);
    
    return player;
}
