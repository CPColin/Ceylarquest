import ceylon.collection {
    MutableSet,
    HashSet,
    ArrayList,
    MutableList
}
import ceylon.test {
    assertEquals,
    assertTrue,
    test,
    beforeTest,
    assertAll,
    afterTest
}

import com.crappycomic.ceylarquest.model {
    ...
}

shared abstract class BoardTest(shared Board board) {
    shared MutableList<Anything()> assertions = ArrayList<Anything()>();
    
    beforeTest shared void clearAssertions() => assertions.clear();
    
    afterTest shared void reportAssertions() {
        assertAll(assertions.sequence());
    }
    
    Boolean arePricesMonotonic([Integer+] prices) {
        variable Integer last = 0;
        for (price in prices) {
            if (price < last) { return false; }
            last = price;
        }
        return true;
    }
    
    "Returns all [[Ownable]] nodes in the current [[Board]]."
    value ownables => board.nodes.keys.narrow<Ownable>();
    
    "Ensures every [[Ownable]] node in a [[DeedGroup]] has as many defined [[Ownable.rents]] and, when appropriate,
        [[FuelSalable.fuels]] as there are nodes in the group."
    test
    shared void verifyDeedGroups() {
        value deedGroups = ownables.map((element) => element.deedGroup).frequencies();
        
        for (ownable in ownables) {
            value deedGroup = ownable.deedGroup;
            
            assertions.add(() =>
                assertEquals(ownable.rents.size, deedGroups.get(deedGroup),
                    "Node '``ownable``' rents list doesn't match size of DeedGroup."));
            
            if (is FuelSalable ownable) {
                assertions.add(() =>
                    assertEquals(ownable.fuels.size, deedGroups.get(deedGroup),
                        "Node '``ownable``' fuels list doesn't match size of DeedGroup."));
            }
        }
    }
    
    "Ensures every [[Ownable]] node has a list of [[Ownable.rents]] where each is at least as large as the previous one
        in the list (i.e., the values increase monotonically. If the node is [[FuelSalable]], the list of
        [[FuelSalable.fuels]] is similarly validated."
    test
    shared void verifyMonotonicPrices() {
        for (ownable in ownables) {
            assertions.add(() =>
                assertTrue(arePricesMonotonic(ownable.rents),
                    "Node '``ownable``' rents list isn't monotonic."));
            
            if (is FuelSalable ownable) {
                assertions.add(() =>
                    assertTrue(arePricesMonotonic(ownable.fuels),
                        "Node '``ownable``' fuels list isn't monotonic."));
            }
        }
    }
    
    "Ensures that every [[Node]] can be reached via a path that starts from the [[Board.start]] node and at least one
        node loops back to the start."
    test
    shared void verifyConnectivity() {
        value dfs = DepthFirstSearch();
        
        dfs.iterate(board.start);
        
        for (node in board.nodes.keys) {
            assertions.add(() =>
                assertTrue(dfs.visited.contains(node),
                    "Node '``node``' is not reachable from '``board.start``'."));
        }
        
        assertions.add(() =>
            assertTrue(dfs.startConnected,
                "Node '``board.start``' is the start node, but no node leads to it."));
    }
    
    shared void verifyAllowedMoves(String originId, Integer distance, String message, String+ destinationIds) {
        value originNode = board.getNode(originId);
        
        assert(exists originNode);
        
        value allowedMoves = board.getAllowedMoves(originNode, distance);
        value actualDestinations = allowedMoves.collect((move) => move.last);
        value expectedDestinations = [ for (destinationId in destinationIds) board.getNode(destinationId) ];
        
        for (expectedDestination in expectedDestinations) {
            assert(exists expectedDestination);
        }
        
        assertions.add(() => assertEquals(actualDestinations, expectedDestinations, message));
    }
    
    "Checks that all allowed paths from the given origin over the given distance do or don't pass start."
    shared void verifyPassesStart(String originId, Integer distance, Boolean passesStart) {
        value originNode = board.getNode(originId);
        
        assert(exists originNode);
        
        value allowedMoves = board.getAllowedMoves(originNode, distance);
        
        for (allowedMove in allowedMoves) {
            assertions.add(() => assertEquals(board.passesStart(allowedMove), passesStart,
                "Unexpected passesStart value for path from ``originId`` over ``distance`` distance."));
        }
    }
    
    class DepthFirstSearch() {
        shared MutableSet<Node> visited = HashSet<Node>();
        
        shared variable Boolean startConnected = false;
        
        shared void iterate(Node node) {
            visited.add(node);
            
            value destinations = board.getDestinations(node);
            
            for (destination in destinations) {
                if (destination == board.start) {
                    startConnected = true;
                }
                if (!visited.contains(destination)) {
                    iterate(destination);
                }
            }
        }
    }
}
