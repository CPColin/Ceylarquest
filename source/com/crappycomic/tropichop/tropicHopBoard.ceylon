import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Administration,
    Board,
    Card,
    CollectCash,
    CollectFuelStation,
    Color,
    CostsFuelToLeave,
    DeedGroup,
    FuelSalable,
    FuelStationable,
    LoseDisputeWithLeague,
    Node,
    Ownable,
    RollAgain,
    RollWithMultiplier,
    UseFuel,
    WellOrbit,
    WinDisputeWithLeague,
    WinDisputeWithPlayer,
    mapNodes
}

interface Port
        satisfies Node & CostsFuelToLeave {}

interface Distillery
        satisfies Port & Ownable & FuelSalable {}

interface FreePort
        satisfies Port & Administration & ActionTrigger {}

interface OpenWater
        satisfies WellOrbit {}

interface OwnablePort
        satisfies Port & Ownable & FuelSalable & FuelStationable {}

interface Resort
        satisfies Port & Ownable {}

shared object tropicHopBoard extends Board() {
    value westIsland = DeedGroup(Color(255, 255, 0));
    value eastIsland = DeedGroup(Color(192, 92, 0));
    value distilleries = DeedGroup(Color(192, 192, 192));
    value resorts = DeedGroup(Color(96, 96, 96));
    
    object companyHQ satisfies FreePort & FuelSalable {
        name = "Company HQ";
        location = [114, 787];
        fuels = [25];
        action = CollectFuelStation(1);
    }
    object westA satisfies OwnablePort {
        name = "West A";
        location = [117, 936];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westFreeport satisfies FreePort {
        name = "West Freeport";
        location = [144, 1078];
        action = CollectCash(600);
    }
    object westB satisfies OwnablePort {
        name = "West B";
        location = [204, 1181];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westC satisfies OwnablePort {
        name = "West C";
        location = [376, 1203];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westD satisfies OwnablePort {
        name = "West D";
        location = [457, 1104];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westE satisfies OwnablePort {
        name = "West E";
        location = [611, 1050];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westResort satisfies Resort {
        name = "West Resort";
        location = [644, 913];
        deedGroup = resorts;
        price = 250;
        rents = [75, 150];
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
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westG satisfies OwnablePort {
        name = "West G";
        location = [358, 580];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westH satisfies OwnablePort {
        name = "West H";
        location = [201, 634];
        deedGroup = westIsland;
        price = 250;
        rents = [50, 150, 250, 350, 450, 550, 650, 750];
        fuels = [10, 10, 20, 20, 30, 30, 40, 40];
    }
    object westToEast1 satisfies OpenWater {
        name = "Open Water between West and East Islands";
        location = [756, 947];
    }
    object westToEast2 satisfies OpenWater {
        name = "Open Water between West and East Islands";
        location = [850, 891];
    }
    object westToEast3 satisfies OpenWater {
        name = "Open Water between West and East Islands";
        location = [951, 858];
    }
    object westToEast4 satisfies OpenWater {
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
        action = CollectFuelStation(1);
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
        westE -> [westToEast1, westResort],
        westResort -> westRum,
        westRum -> westF,
        westF -> westG,
        westG -> westH,
        westH -> companyHQ,
        westToEast1 -> westToEast2,
        westToEast2 -> westToEast3,
        westToEast3 -> westToEast4,
        westToEast4 -> eastA,
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
        Card("Doldrums", UseFuel(3)),
        Card("Gale 2", UseFuel(2), RollWithMultiplier(2)),
        Card("Gale 3", UseFuel(3), RollWithMultiplier(3)),
        Card("Gale 4", UseFuel(4), RollWithMultiplier(4)),
        Card("Bonus Contract", CollectCash(300), RollAgain()),
        Card("You LOSE a dispute with the Company", LoseDisputeWithLeague()),
        Card("You LOSE a dispute with the Company", LoseDisputeWithLeague()),
        Card("You WIN a dispute with the Company", WinDisputeWithLeague()),
        Card("You WIN a dispute with the Company", WinDisputeWithLeague()),
        Card("You WIN a dispute with any player of your choice", WinDisputeWithPlayer())
    ];
    
    shared ActionTrigger testActionTrigger = westFreeport;
    
    shared Node testAfterStart = westH;
    
    shared Node testBeforeStart = westA;
    
    shared Ownable & FuelSalable testFuelSalableNotStationable = westRum;
    
    shared Ownable & FuelStationable testFuelStationable = eastD;
    
    shared Ownable testOwnablePort = westB;
    
    shared Node testNotFuelSalableOrStationable = westResort;
    
    shared Node testUnownablePort = eastFreeport;
    
    shared Node testWell = eastToWest1;
}
