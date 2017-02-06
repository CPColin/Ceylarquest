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
    object testNode extends TestNode("testNode") {}
    object testWellOrbit extends TestNode("testWellOrbit") satisfies WellOrbit {}
    
    assertFalse(containsWellOrbit([testNode], 0));
    assertTrue(containsWellOrbit([testNode, testWellOrbit], 0));
    assertFalse(containsWellOrbit([testWellOrbit, testNode], 1),
        "WellOrbit testNode before the fromIndex should not have been noticed.");
    assertTrue(containsWellOrbit([testWellOrbit, testNode, testWellOrbit], 1));
}

test
shared void enforceWellPullPathTest() {
    object testNode1 extends TestNode("testNode1") {}
    object testNode2 extends TestNode("testNode2") {}
    object testWellPull1 extends TestNode("testWellPull1") satisfies WellPull {}
    object testWellPull2 extends TestNode("testWellPull2") satisfies WellPull {}
    
    assertEquals(enforceWellPullPath([testNode1, testWellPull1]),
        [testNode1, testWellPull1, testNode1]);
    assertEquals(enforceWellPullPath([testNode1, testNode2]),
        [testNode1, testNode2]);
    assertEquals(enforceWellPullPath([testNode1, testNode2, testWellPull1, testWellPull2]),
        [testNode1, testNode2, testWellPull1, testWellPull2, testWellPull1, testNode2]);
}

test
shared void findBranchesTest() {
    object testNode1 extends TestNode("testNode1") {}
    object testNode2 extends TestNode("testNode2") {}
    object testNode3 extends TestNode("testNode3") {}
    object testNode4 extends TestNode("testNode4") {}
    object testNode5 extends TestNode("testNode5") {}
    
    value path1 = [testNode1, testNode2, testNode3];
    value path2 = [testNode1, testNode2, testNode4];
    value path3 = [testNode1, testNode5];
    
    assertEquals(findBranches([]), finished);
    assertEquals(findBranches([path1, path2, path3]), [[path1, path2], 1]);
    assertEquals(findBranches([path1, path3]), [[path1, path3], 0]);
}

test
shared void matchingPathsTest() {
    object testNode1 extends TestNode("testNode1") {}
    object testNode2 extends TestNode("testNode2") {}
    object testNode3 extends TestNode("testNode3") {}
    object testNode4 extends TestNode("testNode4") {}
    
    value path1 = [testNode1, testNode2];
    value path2 = [testNode1, testNode3];
    value path3 = [testNode1, testNode2, testNode4];
    
    assertEquals(matchingPaths([path1, path2, path3], 0), [path1, path2, path3]);
    assertEquals(matchingPaths([path1, path2, path3], 1), [path1, path3]);
    assertEquals(matchingPaths([path3, path2, path1], 2), [path3]);
    assertEquals(matchingPaths([path1, path2, path3], 3), []);
}

test
shared void removeWellOrbitPathsTest() {
    object testNode1 extends TestNode("testNode1") {}
    object testNode2 extends TestNode("testNode2") {}
    object testWellOrbit extends TestNode("testWellOrbit") satisfies WellOrbit {}
    
    value path1 = [testNode1, testWellOrbit];
    value path2 = [testNode1, testNode2];
    value paths = removeWellOrbitPaths({path1, path2}).sequence();
    
    assertEquals(paths.size, 1, "Exactly one path should have been returned.");
    assertFalse(paths.contains(path1), "The WellOrbit path should not have been returned.");
    assertTrue(paths.contains(path2), "The valid path should have been returned.");
}
