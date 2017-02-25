import ceylon.language.meta {
    typeLiteral
}
import ceylon.test {
    assertNotEquals
}

import com.crappycomic.ceylarquest.model {
    Node,
    Well
}
import com.crappycomic.ceylarquest.model.logic {
    destinations
}

"Provides two different [[Node]] instances with the given [[Type]] that are not also instances of
 the given [[NotType]]. The returned instances will never satisfy [[Well]]."
shared Type[2] testNodes<Type, NotType=Nothing>()
        given Type satisfies Node {
    value nodes = testGame.board.nodes.keys
        .narrow<Type>()
        .filter((node) => !node is NotType && !node is Well);
    value node1 = nodes.first;
    value node2 = nodes.last;
    
    assert (exists node1, exists node2);
    
    // This message will be a bit gross, but cleaning it up isn't worth the effort.
    assertNotEquals(node1, node2,
        "This function requires two different ``typeLiteral<Type>()`` nodes.");
    
    return [node1, node2];
}

"Provides two [[Node]] instances, the first of which leads to the
 [[start node|com.crappycomic.ceylarquest.model::Board.start]] and the second of which can be
 reached in one step from the start node. No guarantee is made for the types of the two nodes."
shared Node[2] testNodesBeforeAndAfterStart {
    value board = testGame.board;
    value start = board.start;
    value afterStart = destinations(board, start).first;
    value beforeStart = board.nodes.keys.find((node) => destinations(board, node).contains(start));
    
    assert (exists beforeStart);
    
    return [beforeStart, afterStart];
}
