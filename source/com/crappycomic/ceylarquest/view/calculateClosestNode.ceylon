import com.crappycomic.ceylarquest.model {
    Board,
    Node
}

"Returns the [[Node]] in the given [[board]] that is closest to the point at the given [[x]] and
 [[y]] coordinate."
shared Node calculateClosestNode(Board board, Integer x, Integer y) {
    value closestNode
            = board.nodes.keys
            .map((Node node) => [node, calculateDistance(x, y, *node.location)])
            .sort(byIncreasing(([Node, Integer] node) => node[1]))
            .first;
    
    assert (exists closestNode);
    
    return closestNode[0];
}

Integer calculateDistance(Integer x0, Integer y0, Integer x1, Integer y1) {
    return ((x1 - x0) ^ 2 + (y1 - y0) ^ 2);
}
