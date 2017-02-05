shared alias Path => [Node+];

// TODO: sort
"The game board, a layout of [[Node]]s and their connections to each other, the [[Card]]s that can
 be drawn, and the default [[Rules]] by which the game will be played."
shared abstract class Board() {
    "The [[Card]]s that players can draw, in the order they were defined."
    shared formal [Card*] cards;
    
    "The default rules by which the game will be played."
    shared formal Rules defaultRules;
    
    "Maps [[Node]]s to their one or more destinations, in the order they should be tried."
    shared formal Map<Node, [Node+]> nodes;
    
    "The [[Node]] that players start on."
    shared formal Node start;
    
    shared Node? getNode(String id) {
        return nodes.keys.find((node) => node.id == id);
    }
    
    "Returns `true` if the given [[path]] passes the [[start]] node or lands on
     it. Starting from the [[start]] node does not, on its own, count as
     passing it."
    shared Boolean passesStart(Path path) {
        return path.rest.contains(start);
    }
}

shared Map<Node, [Node+]> mapNodes({<Node -> Node|[Node+]>+} nodes) {
    return map(nodes.map((node -> destinations)
        => if (is Node destinations) then node -> [destinations] else node -> destinations));
}
