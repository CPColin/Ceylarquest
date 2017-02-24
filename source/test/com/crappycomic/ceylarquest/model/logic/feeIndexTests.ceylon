import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.ceylarquest.model {
    DeedGroup,
    Ownable,
    Player
}
import com.crappycomic.ceylarquest.model.logic {
    feeIndex
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers
}

test
shared void feeIndexTests() {
    value player = testPlayers[0];
    value ownables = tropicHopBoard.nodes.keys
        .narrow<Ownable>()
        .group(Ownable.deedGroup);
    
    for (deedGroup -> nodes in ownables) {
        for (count in 1..nodes.size) {
            checkFeeIndex(player, deedGroup, nodes, count);
        }
    }
}

void checkFeeIndex(Player player, DeedGroup deedGroup, {Ownable*} nodes, Integer count) {
    value owners = { for (node in nodes.take(count)) node -> player };
    value game = testGame.with {
        owners = owners;
    };
    
    assertEquals(feeIndex(game, player, deedGroup), count - 1, "Fee index didn't match.");
}
