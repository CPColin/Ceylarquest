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
        "green" -> "Green"
    },
    "activePlayers" -> JsonArray({"red", "blue", "magenta", "green"}),
    "playerLocations" -> JsonObject {
        // "cyan" -> "dead",
        // "red" -> "companyHQ", default
        // "blue" -> "companyHQ", default
        "magenta" -> "eastFreeport",
        "green" -> "westB"
    },
    "ownedNodes" -> JsonObject {
        "westC" -> "green",
        "eastFreePort" -> "red", // Invalid because it's not Ownable
        "westRum" -> "cyan", // Invalid because Cyan is dead
        "eastRum" -> "blue"
    }
}.pretty;

