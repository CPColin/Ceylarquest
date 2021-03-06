import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    WellOrbit,
    WellPull
}
import com.crappycomic.ceylarquest.model.logic {
    containsWellOrbit,
    enforceWellPullPath,
    findBranches,
    matchingPaths,
    removeWellOrbitPaths
}

import test.com.crappycomic.ceylarquest.model {
    TestNode
}

test
shared void containsWellOrbitTest() {
    object testNode extends TestNode() {}
    object testWellOrbit extends TestNode() satisfies WellOrbit {}
    
    assertFalse(containsWellOrbit([testNode], 0));
    assertTrue(containsWellOrbit([testNode, testWellOrbit], 0));
    assertFalse(containsWellOrbit([testWellOrbit, testNode], 1),
        "WellOrbit testNode before the fromIndex should not have been noticed.");
    assertTrue(containsWellOrbit([testWellOrbit, testNode, testWellOrbit], 1));
}

test
shared void enforceWellPullPathTest() {
    object testNode1 extends TestNode() {}
    object testNode2 extends TestNode() {}
    object testWellPull1 extends TestNode() satisfies WellPull {}
    object testWellPull2 extends TestNode() satisfies WellPull {}
    
    assertEquals(enforceWellPullPath([testNode1, testWellPull1]),
        [testNode1, testWellPull1, testNode1]);
    assertEquals(enforceWellPullPath([testNode1, testNode2]),
        [testNode1, testNode2]);
    assertEquals(enforceWellPullPath([testNode1, testNode2, testWellPull1, testWellPull2]),
        [testNode1, testNode2, testWellPull1, testWellPull2, testWellPull1, testNode2]);
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
    
    assertEquals(findBranches(empty), finished);
    assertEquals(findBranches([path1, path2, path3]), [[path1, path2], 1]);
    assertEquals(findBranches([path1, path3]), [[path1, path3], 0]);
}

test
shared void matchingPathsTest() {
    object testNode1 extends TestNode() {}
    object testNode2 extends TestNode() {}
    object testNode3 extends TestNode() {}
    object testNode4 extends TestNode() {}
    
    value path1 = [testNode1, testNode2];
    value path2 = [testNode1, testNode3];
    value path3 = [testNode1, testNode2, testNode4];
    
    assertEquals(matchingPaths([path1, path2, path3], 0), [path1, path2, path3]);
    assertEquals(matchingPaths([path1, path2, path3], 1), [path1, path3]);
    assertEquals(matchingPaths([path3, path2, path1], 2), [path3]);
    assertEquals(matchingPaths([path1, path2, path3], 3), empty);
}

test
shared void removeWellOrbitPathsTest() {
    object testNode1 extends TestNode() {}
    object testNode2 extends TestNode() {}
    object testWellOrbit extends TestNode() satisfies WellOrbit {}
    
    value path1 = [testNode1, testWellOrbit];
    value path2 = [testNode1, testNode2];
    value paths = removeWellOrbitPaths({path1, path2}).sequence();
    
    assertEquals(paths.size, 1, "Exactly one path should have been returned.");
    assertFalse(paths.contains(path1), "The WellOrbit path should not have been returned.");
    assertTrue(paths.contains(path2), "The valid path should have been returned.");
}
