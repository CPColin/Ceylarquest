import ceylon.language.meta.model {
    Interface
}

"Provides ways for games to customize certain strings."
shared interface Strings {
    shared alias NodeType => [Interface<Node>, String, String];
    
    shared formal String card;
    
    shared formal String cashUnit;
    
    shared formal String fuel;
    
    shared formal String fuelStation;
    
    shared formal String fuelUnit;
    
    shared formal String game;
    
    shared formal String landOn;
    
    shared formal String leagueLong;
    
    shared formal String leagueShort;
    
    shared formal NodeType[] nodeTypes;
    
    shared formal String purchaseFuel;
}
