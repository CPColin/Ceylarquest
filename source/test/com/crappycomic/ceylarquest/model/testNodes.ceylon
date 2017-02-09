import ceylon.language.meta {
    typeLiteral
}
import ceylon.test {
    assertNotEquals
}

import com.crappycomic.ceylarquest.model {
    Node
}

"Provides two different [[Node]] instances with the given [[Type]]."
shared Type[2] testNodes<Type>()
        given Type satisfies Node {
    value nodes = testGame.board.nodes.keys.narrow<Type>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    
    assert (exists node1, exists node2);
    
    // This message will be a bit gross, but cleaning it up isn't worth the effort.
    assertNotEquals(node1, node2,
        "This function requires two different ``typeLiteral<Type>()`` nodes.");
    
    return [node1, node2];
}