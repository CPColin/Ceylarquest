import ceylon.json {
    JsonObject,
    JsonArray
}

"A partially played game that can be used for debugging UI and serialization logic."
shared String debugGameJson => JsonObject {
    "board" -> JsonObject {
        "moduleName" -> `module com.crappycomic.tropichop`.name,
        "packageName" -> `package com.crappycomic.tropichop`.name,
        "objectName" -> "tropicHopBoard"
    },
    "playerNames" -> JsonObject {
        "blue" -> "Blue",
        "cyan" -> "Cyan",
        "green" -> "Green",
        "magenta" -> "Magenta",
        "red" -> "Red",
        "yellow" -> "Yellow"
    },
    "activePlayers" -> JsonArray {
        "blue",
        "green",
        "magenta",
        "red",
        "yellow"
    },
    "allPlayers" -> JsonArray {
        "red",
        "blue",
        "magenta",
        "green",
        "yellow",
        "cyan"
    },
    "currentPlayer" -> "magenta",
    "owners" -> JsonObject {
        "westC" -> "green",
        "eastFreePort" -> "red", // Invalid because it's not Ownable
        "westRum" -> "cyan", // Invalid because Cyan is not active
        "eastRum" -> "blue"
    },
    "placedFuelStations" -> JsonArray {
        "westC",
        "eastD",
        "eastFreeport" // Invalid becayse it's not FuelStationable
    },
    "playerLocations" -> JsonObject {
        "cyan" -> "westFreeport", // Ignored because Cyan is not active
        "magenta" -> "eastFreeport",
        "green" -> "westB"
    }
}.pretty;
