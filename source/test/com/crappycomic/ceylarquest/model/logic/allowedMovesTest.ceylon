import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Node,
    WellPull
}
import com.crappycomic.ceylarquest.model.logic {
    containsWellOrbit,
    enforceWellPullPath,
    findBranches,
    matchingPaths,
    removeWellOrbitPaths
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

class TestNode() satisfies Node {
    location = [0, 0];
    
    name => id;
}

test
shared void containsWellOrbitTest() {
    assertFalse(containsWellOrbit([tropicHopBoard.start], 0));
    assertTrue(containsWellOrbit([tropicHopBoard.start, tropicHopBoard.testWellOrbit], 0));
    assertFalse(containsWellOrbit([tropicHopBoard.testWellOrbit, tropicHopBoard.start], 1),
        "WellOrbit node before the fromIndex should not have been noticed.");
    assertTrue(containsWellOrbit(
        [tropicHopBoard.testWellOrbit, tropicHopBoard.start, tropicHopBoard.testWellOrbit], 1));
}

test
shared void enforceWellPullPathTest() {
    object testWellPull1 extends TestNode() satisfies WellPull {}
    object testWellPull2 extends TestNode() satisfies WellPull {}
    
    assertEquals(enforceWellPullPath([tropicHopBoard.start, testWellPull1]),
        [tropicHopBoard.start, testWellPull1, tropicHopBoard.start]);
    assertEquals(enforceWellPullPath([tropicHopBoard.start, tropicHopBoard.testAfterStart]),
        [tropicHopBoard.start, tropicHopBoard.testAfterStart]);
    assertEquals(enforceWellPullPath([tropicHopBoard.start, testWellPull1, testWellPull2]),
        [tropicHopBoard.start, testWellPull1, testWellPull2, testWellPull1, tropicHopBoard.start]);
}

test
shared void findBranchesTest() {
    object testNode1 extends TestNode() {}
    object testNode2 extends TestNode() {}
    object testNode3 extends TestNode() {}
    object testNode4 extends TestNode() {}
    object testNode5 extends TestNode() {}
    
    value path1 = [testNode1, testNode2, testNode3];
    value path2 = [testNode1, testNode2, testNode4];
    value path3 = [testNode1, testNode5];
    
    assertEquals(findBranches([]), finished);
    assertEquals(findBranches([path1, path2, path3]), [[path1, path2], 1]);
    assertEquals(findBranches([path1, path3]), [[path1, path3], 0]);
}

test
shared void matchingPathsTest() {
    value path1 = [tropicHopBoard.start, tropicHopBoard.testWellOrbit];
    value path2 = [tropicHopBoard.start, tropicHopBoard.testOwnablePort];
    value path3
        = [tropicHopBoard.start, tropicHopBoard.testWellOrbit, tropicHopBoard.testFuelStationable];
    
    assertEquals(matchingPaths([path1, path2, path3], 0), [path1, path2, path3]);
    assertEquals(matchingPaths([path1, path2, path3], 1), [path1, path3]);
    assertEquals(matchingPaths([path3, path2, path1], 2), [path3]);
    assertEquals(matchingPaths([path1, path2, path3], 3), []);
}

test
shared void removeWellOrbitPathsTest() {
    value path1 = [tropicHopBoard.start, tropicHopBoard.testWellOrbit];
    value path2 = [tropicHopBoard.start, tropicHopBoard.testOwnablePort];
    value paths = removeWellOrbitPaths({path1, path2}).sequence();
    
    assertEquals(paths.size, 1, "Exactly one path should have been returned.");
    assertFalse(paths.contains(path1), "The WellOrbit path should not have been returned.");
    assertTrue(paths.contains(path2), "The valid path should have been returned.");
}
