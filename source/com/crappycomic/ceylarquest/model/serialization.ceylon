import ceylon.json {
    InvalidTypeException,
    JsonArray,
    JsonObject,
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
        
        return let (board = loadBoard(jsonObject)) Game {
            board = board;
            playerNames = loadPlayerNames(jsonObject);
            
            activePlayers = loadPlayers(jsonObject, "activePlayers");
            allPlayers = loadPlayers(jsonObject, "allPlayers");
            currentPlayer = loadCurrentPlayer(jsonObject);
            owners = loadOwners(jsonObject, board);
            phase = loadPhase(jsonObject, "phase", board);
            playerCashes = loadPlayerCashes(jsonObject);
            playerFuels = loadPlayerFuels(jsonObject);
            placedFuelStations = loadPlacedFuelStations(jsonObject, board);
            playerFuelStationCounts = loadPlayerFuelStationCounts(jsonObject);
            playerLocations = loadPlayerLocations(jsonObject, board);
            rules = null; // TODO
        };
    }
    catch (AssertionError | InvalidTypeException e) {
        return InvalidSave(e.message);
    }
}

Board loadBoard(JsonObject jsonObject) {
    value board = jsonObject.getObject("board");
    
    return loadObject<Board>(board);
}

Player? loadCurrentPlayer(JsonObject jsonObject) {
    value currentPlayer = jsonObject.getStringOrNull("currentPlayer");
    
    return if (exists currentPlayer) then resolvePlayer(currentPlayer) else null;
}

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

Phase? loadPhase(JsonObject jsonObject, String key, Board board) {
    value phaseObject = jsonObject.getObjectOrNull(key);
    
    if (exists phaseObject) {
        value phaseName = phaseObject.getString("name");
        
        if (phaseName.first?.lowercase else false) {
            value phaseDeclaration = `package`.getValue(phaseName);
            
            assert (exists phaseDeclaration);
            
            value phaseValue = phaseDeclaration.get();
            
            assert (is Phase phaseValue);
            
            return phaseValue;
        }
        else {
            switch (phaseName)
            // TODO: it'd be nice to be more type-safe, so file follow-up.
            case ("ChoosingAllowedMove") {
                value paths = [
                    for (path in phaseObject.getArray("paths").arrays)
                        resolvePath(path, board)
                ];
                
                assert (nonempty paths);
                
                return ChoosingAllowedMove(paths, phaseObject.getInteger("fuel"));
            }
            case ("DrewCard") {
                return DrewCard(resolveCard(board, phaseObject.getString("description")));
            }
            case ("PreLand") {
                return PreLand(phaseObject.getBoolean("advancedToNode"));
            }
            case ("Rolled") {
                return Rolled(phaseObject.getArray("roll").integers.sequence(),
                    phaseObject.getIntegerOrNull("multiplier"));
            }
            case ("RollingWithMultiplier") {
                return RollingWithMultiplier(phaseObject.getInteger("multiplier"));
            }
            case ("SettlingDebts") {
                value debts = [
                    for (debt in phaseObject.getArray("debts").objects)
                        resolveDebt(debt)
                ];
                value nextPhase = loadPhase(phaseObject, "nextPhase", board);
                
                assert (exists nextPhase);
                
                return SettlingDebts(debts, nextPhase);
            }
            else {
                throw InvalidTypeException("Unknown Phase class: ``phaseName``");
            }
        }
    }
    
    value phase = preRoll;
    
    // Reminder to add functionality above when new Phase classes are added.
    // Phase objects (anonymous classes) should work by default.
    switch (phase)
    case (is ChoosingAllowedMove|DrewCard|PreLand|Rolled|RollingWithMultiplier|SettlingDebts) {}
    case (choosingNodeLostToLeague|choosingNodeWonFromLeague|choosingNodeWonFromPlayer
        |currentPlayerEliminated|drawingCard|gameOver|postLand|preRoll) {}
    
    return null;
}

{Node*}? loadPlacedFuelStations(JsonObject jsonObject, Board board) {
    value placedFuelStations = jsonObject.getArrayOrNull("placedFuelStations");
    
    if (exists placedFuelStations) {
        return placedFuelStations.narrow<String>().map((nodeKey) => resolveNode(board, nodeKey));
    }
    else {
        return null;
    }
}

{<Player -> Integer>*}? loadPlayerCashes(JsonObject jsonObject) {
    return loadPlayerData(jsonObject, "playerCashes", JsonObject.getInteger);
}

"Loads from the given [[JSON object|jsonObject]] another object matching the given [[key]],
 converting that object to a map from [[Player]] instances to [[data]] extracted using the given
 function."
{<Player -> Type>*}? loadPlayerData<Type>(JsonObject jsonObject, String key,
        Type(String)(JsonObject) data) {
    value playerData = jsonObject.getObjectOrNull(key);
    
    if (exists playerData) {
        return playerData.map((playerKey -> _)
            => resolvePlayer(playerKey) -> data(playerData)(playerKey));
    }
    else {
        return null;
    }
}

{<Player -> Integer>*}? loadPlayerFuels(JsonObject jsonObject) {
    return loadPlayerData(jsonObject, "playerFuels", JsonObject.getInteger);
}

{<Player -> Integer>*}? loadPlayerFuelStationCounts(JsonObject jsonObject) {
    return loadPlayerData(jsonObject, "playerFuelStationCounts", JsonObject.getInteger);
}

{<Player -> Node>*}? loadPlayerLocations(JsonObject jsonObject, Board board) {
    return loadPlayerData(jsonObject, "playerLocations",
        (JsonObject jsonObject)(String key) => resolveNode(board, jsonObject.getString(key)));
}

{<Player -> String>*} loadPlayerNames(JsonObject jsonObject) {
    value playerNames = loadPlayerData(jsonObject, "playerNames", JsonObject.getString);
    
    assert (exists playerNames);
    
    return playerNames;
}

{Player*}? loadPlayers(JsonObject jsonObject, String key) {
    value players = jsonObject.getArrayOrNull(key);
    
    if (exists players) {
        return players.narrow<String>().map((playerKey) => resolvePlayer(playerKey));
    }
    else {
        return null;
    }
}

Card resolveCard(Board board, String description) {
    value card = board.cards.find((card) => card.description == description);
    
    assert (exists card);
    
    return card;
}

Debt resolveDebt(JsonObject jsonObject) {
    value debtor = resolvePlayer(jsonObject.getString("debtor"));
    value amount = jsonObject.getInteger("amount");
    value creditor = resolvePlayer(jsonObject.getString("creditor"));
    
    return Debt(debtor, amount, creditor);
}

Path resolvePath(JsonArray jsonArray, Board board) {
    value path = [
        for (nodeId in jsonArray.strings)
            resolveNode(board, nodeId)
    ];
    
    assert (nonempty path);
    
    return path;
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
