import ceylon.json {
    JsonObject,
    JsonArray
}

shared String debugGameJson => JsonObject {
    "board" -> JsonObject {
        "moduleName" -> `module com.crappycomic.tropichop`.name,
        "packageName" -> `package com.crappycomic.tropichop`.name,
        "objectName" -> "tropicHopBoard"
    },
    "players" -> JsonObject {
        "cyan" -> "Cyan",
        "red" -> "Red",
        "blue" -> "Blue",
        "magenta" -> "Magenta",
        "green" -> "Green",
        "yellow" -> "Yellow"
    },
    "activePlayers" -> JsonArray {
        "red",
        "blue",
        "magenta",
        "green",
        "yellow"
    },
    "playerLocations" -> JsonObject {
        "cyan" -> "westFreeport", // Ignored because Cyan is not active
        "magenta" -> "eastFreeport",
        "green" -> "westB"
    },
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
    }
}.pretty;

