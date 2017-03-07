import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Administration,
    Board,
    Card,
    Color,
    CostsFuelToLeave,
    DeedGroup,
    FuelSalable,
    FuelStationable,
    Node,
    Ownable,
    Rules,
    Strings,
    WellOrbit,
    advanceToNode,
    collectCash,
    collectCashAndRollAgain,
    collectFuelStation,
    loseDisputeWithLeague,
    mapNodes,
    rollTypeAllMatch,
    rollWithMultiplier,
    useFuel,
    winDisputeWithLeague,
    winDisputeWithPlayer
}

interface Port
        satisfies Node & CostsFuelToLeave & FuelSalable {}

interface Distillery
        satisfies Port & Ownable {}

interface FreePort
        satisfies Node & Administration & ActionTrigger {}

interface OpenWater
        satisfies WellOrbit {}

interface OwnablePort
        satisfies Port & Ownable & FuelStationable {}

interface Resort
        satisfies Port & Ownable {}

shared object tropicHopBoard extends Board() {
    value westIsland = DeedGroup(Color(255, 255, 0));
    value eastIsland = DeedGroup(Color(192, 92, 0));
    value distilleries = DeedGroup(Color(192, 192, 192));
    value resorts = DeedGroup(Color(96, 96, 96));
    
    object companyHQ satisfies ActionTrigger & FuelSalable {
        name = "Company HQ";
        location = [114, 787];
        fuels = [25];
        action = collectFuelStation(1);
    }
    object westA satisfies OwnablePort {
        name = "West A";
        location = [117, 936];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westFreeport satisfies FreePort {
        name = "West Freeport";
        location = [144, 1078];
        action = collectCash(600);
    }
    object westB satisfies OwnablePort {
        name = "West B";
        location = [204, 1181];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westC satisfies OwnablePort {
        name = "West C";
        location = [376, 1203];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westD satisfies OwnablePort {
        name = "West D";
        location = [457, 1104];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westE satisfies OwnablePort {
        name = "West E";
        location = [611, 1050];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westResort satisfies Resort {
        name = "West Resort";
        location = [644, 913];
        deedGroup = resorts;
        price = 250;
        rents = [75, 150];
        fuels = [50, 75];
    }
    object westRum satisfies Distillery {
        name = "West Rum";
        location = [591, 778];
        deedGroup = distilleries;
        price = 250;
        rents = [75, 150];
        fuels = [10, 15];
    }
    object westF satisfies OwnablePort {
        name = "West F";
        location = [509, 660];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westG satisfies OwnablePort {
        name = "West G";
        location = [358, 580];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westH satisfies OwnablePort {
        name = "West H";
        location = [201, 634];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westI satisfies OwnablePort {
        name = "West I";
        location = [756, 947];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50];
    }
    object westToEast1 satisfies OpenWater {
        name = "Open Water between West and East Islands";
        location = [850, 891];
    }
    object westToEast2 satisfies OpenWater {
        name = "Open Water between West and East Islands";
        location = [951, 858];
    }
    object westToEast3 satisfies OpenWater {
        name = "Open Water between West and East Islands";
        location = [1052, 812];
    }
    object eastA satisfies OwnablePort {
        name = "East A";
        location = [1114, 726];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastResort satisfies Resort {
        name = "East Resort";
        location = [1114, 584];
        deedGroup = resorts;
        price = 250;
        rents = [75, 150];
        fuels = [50, 75];
    }
    object eastB satisfies OwnablePort {
        name = "East B";
        location = [1096, 494];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastC satisfies OwnablePort {
        name = "East C";
        location = [1058, 370];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastD satisfies OwnablePort {
        name = "East D";
        location = [1134, 279];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastE satisfies OwnablePort {
        name = "East E";
        location = [1067, 171];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastF satisfies OwnablePort {
        name = "East F";
        location = [960, 118];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastG satisfies OwnablePort {
        name = "East G";
        location = [835, 158];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastFreeport satisfies FreePort {
        name = "East Freeport";
        location = [793, 262];
        action = collectFuelStation(1);
    }
    object eastH satisfies OwnablePort {
        name = "East H";
        location = [777, 381];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastI satisfies OwnablePort {
        name = "East I";
        location = [764, 482];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastRum satisfies Distillery {
        name = "East Rum";
        location = [799, 595];
        deedGroup = distilleries;
        price = 250;
        rents = [75, 150];
        fuels = [10, 15];
    }
    object eastJ satisfies OwnablePort {
        name = "East J";
        location = [873, 659];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastK satisfies OwnablePort {
        name = "East K";
        location = [958, 726];
        deedGroup = eastIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 60];
    }
    object eastToWest1 satisfies OpenWater {
        name = "Open Water between East and West Islands";
        location = [684, 525];
    }
    object eastToWest2 satisfies OpenWater {
        name = "Open Water between East and West Islands";
        location = [584, 545];
    }
    object eastToWest3 satisfies OpenWater {
        name = "Open Water between East and West Islands";
        location = [478, 559];
    }
    
    nodes = mapNodes {
        companyHQ -> westA,
        westA -> westFreeport,
        westFreeport -> westB,
        westB -> westC,
        westC -> westD,
        westD -> westE,
        westE -> [westI, westResort],
        westResort -> westRum,
        westRum -> westF,
        westF -> westG,
        westG -> westH,
        westH -> companyHQ,
        westI -> westToEast1,
        westToEast1 -> westToEast2,
        westToEast2 -> westToEast3,
        westToEast3 -> eastA,
        eastA -> eastResort,
        eastResort -> eastB,
        eastB -> eastC,
        eastC -> eastD,
        eastD -> eastE,
        eastE -> eastF,
        eastF -> eastG,
        eastG -> eastFreeport,
        eastFreeport -> eastH,
        eastH -> eastI,
        eastI -> [eastToWest1, eastRum],
        eastRum -> eastJ,
        eastJ -> eastK,
        eastK -> eastA,
        eastToWest1 -> eastToWest2,
        eastToWest2 -> eastToWest3,
        eastToWest3 -> westG
    };
    
    start = companyHQ;
    
    cards = [
        Card("Doldrums", useFuel(3)),
        Card("Gale 2", rollWithMultiplier(2)),
        Card("Gale 3", rollWithMultiplier(3)),
        Card("Gale 4", rollWithMultiplier(4)),
        Card("Bonus Contract", collectCashAndRollAgain(300)),
        Card("Advance to East Freeport", advanceToNode(2, eastFreeport)),
        Card("Advance to West Freeport", advanceToNode(2, westFreeport)),
        Card("You LOSE a dispute with the Company", loseDisputeWithLeague),
        Card("You LOSE a dispute with the Company", loseDisputeWithLeague),
        Card("You WIN a dispute with the Company", winDisputeWithLeague),
        Card("You WIN a dispute with the Company", winDisputeWithLeague),
        Card("You WIN a dispute with any player of your choice", winDisputeWithPlayer)
    ];
    
    defaultRules = object extends Rules() {
        cardRollType = rollTypeAllMatch;
        
        initialCash = 1500;
        
        totalFuelStationCount = 20;
    };
    
    strings = object satisfies Strings {
        fuel = "Rum";
        
        fuelStation = "Still";
        
        fuelUnit = "barrel";
        
        leagueLong = "TropicHop Island Company";
        
        leagueShort = "Company";
        
        purchaseFuel = "Buy Rum";
    };
}
