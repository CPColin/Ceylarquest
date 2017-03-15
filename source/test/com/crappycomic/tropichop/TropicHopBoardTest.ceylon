import ceylon.test {
    test
}

import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    BoardTest
}

class TropicHopBoardTest() extends BoardTest(tropicHopBoard) {
    test
    shared void verifySimpleSingleHops() {
        verifyAllowedMoves("companyHQ", 1, "Company HQ doesn't lead to West A.", "westA");
    }
}
