shared abstract class Rules() {
    shared default Integer dieCount = 2;
    
    shared default Integer diePips = 6;
    
    shared formal Integer fuelStationPrice;
    
    shared formal Integer initialCash;
    
    shared formal Integer initialFuelStationCount;
    
    shared formal Integer maximumFuel;
    
    shared formal Integer passStartCash;
    
    shared formal Integer totalFuelStationCount;
}