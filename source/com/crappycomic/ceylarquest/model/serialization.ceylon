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
        
        return Game(board, players);
    }
    catch (AssertionError | InvalidTypeException e) {
        return InvalidSave(e.message);
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
Map<Player, String> loadPlayers(JsonObject jsonObject) {
    value players = jsonObject.getObject("players");
    
    return map(players.map((playerKey -> playerName) =>
        resolvePlayer(playerKey) -> players.getString(playerKey)));
}

Player resolvePlayer(String key) {
    value playerDeclaration = `package com.crappycomic.ceylarquest.model`.getValue(key);
    
    assert (exists playerDeclaration);
    
    value player = playerDeclaration.get();
    
    assert (is Player player);
    
    return player;
}
