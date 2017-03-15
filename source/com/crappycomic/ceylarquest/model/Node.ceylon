import ceylon.language.meta {
    classDeclaration
}

shared alias Location => Integer[2];

shared alias Owner => Player|Nobody;

"A node that triggers a [[NodeAction]] when landed upon."
shared interface ActionTrigger
        satisfies Node {
    shared formal NodeAction action;
}

"A node at which certain administrative tasks may be performed, such as buying fuel stations and
 re-selling owned properties."
shared interface Administration
        satisfies Node {}

"A node that costs fuel when players leave it."
shared interface CostsFuelToLeave
        satisfies Node {}

"A node that may sell fuel to players."
shared interface FuelSalable
        satisfies Node {
    shared formal [Integer+] fuels;
}

"A node that may have a fuel station placed on it."
shared interface FuelStationable
        satisfies Node {}

"A single space on the [[Board]]."
shared interface Node
        satisfies Identifiable {
    shared String id => classDeclaration(this).name;
    
    shared formal String name;
    
    shared formal Location location;
    
    string => name;
}

"A node that can be purchased by players."
shared interface Ownable
        satisfies Node {
    shared formal DeedGroup deedGroup;
    
    shared formal Integer price;
    
    shared formal [Integer+] rents;
}

"A node that represents a gravity well and, thus, may not be landed upon or bypassed."
shared interface Well
        of WellOrbit | WellPull
        satisfies Node {}

"A node that represents the gravity well that must be overcome to break an orbit."
shared interface WellOrbit
        satisfies Well {}

"A node that represents a gravity well that pulls the player backward to a previous node."
shared interface WellPull
        satisfies Well {}
