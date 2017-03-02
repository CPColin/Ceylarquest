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
        "eastRum" -> "blue",
        "eastC" -> "magenta"
    },
    //"phase" -> JsonObject {
    //    "name" -> "ChoosingAllowedMove",
    //    "paths" -> JsonArray {
    //        JsonArray { "companyHQ", "westA", "eastA" },
    //        JsonArray { "westResort", "eastFreeport", "eastD" }
    //    },
    //    "fuel" -> 0
    //},
    //"phase" -> JsonObject {
    //    "name" -> "DrewCard",
    //    "description" -> "Bonus Contract"
    //},
    //"phase" -> JsonObject {
    //    "name" -> "PreLand",
    //    "advancedToNode" -> true
    //},
    //"phase" -> JsonObject {
    //    "name" -> "Rolled",
    //    "roll" -> JsonArray { 2, 3, 4 },
    //    "multiplier" -> 2
    //},
    //"phase" -> JsonObject {
    //    "name" -> "RollingWithMultiplier",
    //    "multiplier" -> 5
    //},
    //"phase" -> JsonObject {
    //    "name" -> "SettlingDebts",
    //    "debts" -> JsonArray {
    //        JsonObject {
    //            "debtor" -> "yellow",
    //            "amount" -> 100,
    //            "creditor" -> "red"
    //        }
    //    },
    //    "nextPhase" -> JsonObject {
    //        "name" -> "postLand"
    //    }
    //},
    "phase" -> JsonObject {
        "name" -> "preRoll"
    },
    "placedFuelStations" -> JsonArray {
        "westC",
        "eastD",
        "eastFreeport" // Invalid becayse it's not FuelStationable
    },
    "playerFuels" -> JsonObject {
        "magenta" -> 0
    },
    "playerLocations" -> JsonObject {
        "cyan" -> "westFreeport", // Ignored because Cyan is not active
        "magenta" -> "eastFreeport",
        "green" -> "westB"
    }
}.pretty;
