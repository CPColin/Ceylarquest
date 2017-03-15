import com.crappycomic.ceylarquest.model {
    Board,
    Node
}

"Returns the destinations the given [[node]] has in the layout of the given [[board]]."
shared [Node+] destinations(Board board, Node node) {
    value destinations = board.nodes.get(node);
    
    assert (exists destinations);
    
    return destinations;
}
