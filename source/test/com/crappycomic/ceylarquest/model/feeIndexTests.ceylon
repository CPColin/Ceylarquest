import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    DeedGroup,
    Ownable,
    Player,
    feeIndex,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void feeIndexTests() {
    value player = testPlayers.first.key;
    value deedGroup = tropicHopBoard.testOwnablePort.deedGroup;
    value nodes = tropicHopBoard.nodes.keys
        .narrow<Ownable>()
        .filter((node) => node.deedGroup == deedGroup);
    
    for (count in 1..nodes.size) {
        checkFeeIndex(player, deedGroup, nodes, count);
    }
}

void checkFeeIndex(Player player, DeedGroup deedGroup, {Ownable*} nodes, Integer count) {
    value owners = { for (node in nodes.take(count)) node -> player };
    value game = testGame.with {
        owners = owners;
    };
    
    assertEquals(feeIndex(game, player, deedGroup), count - 1, "Fee index didn't match.");
}
