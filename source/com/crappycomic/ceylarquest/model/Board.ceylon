import ceylon.collection {
    LinkedList,
    MutableList
}

shared alias Path => [Node+];

// TODO: sort
"The game board, a layout of [[Node]]s and their connections to each other."
shared abstract class Board() {
    "Maps [[Node]]s to their one or more destinations, in the order they should be tried."
    shared formal Map<Node, [Node+]> nodes;
    
    "The [[Node]] that players start on."
    shared formal Node start;
    
    "The [[Card]]s that players can draw."
    shared formal [Card+] cards;
    
    // TODO: this doesn't belong here
    shared Node calculateClosestNode(Integer x, Integer y) {
        value closestNode
                = nodes.keys
                .map((Node node) => [node, calculateDistance(x, y, *node.location)])
                .sort(byIncreasing(([Node, Integer] node) => node[1]))
                .first;
        
        assert (exists closestNode);
        
        return closestNode[0];
    }
    
    shared Node? getNode(String id) {
        return nodes.keys.find((node) => node.id == id);
    }
    
    shared [Node+] getDestinations(Node node) {
        value destinations = nodes.get(node);
        
        assert(exists destinations);
        
        return destinations;
    }
    
    "Computes and returns each allowed move from the given [[origin]] node over the given [[distance]]. Each value
     returned contains the full [[Path]] from the [[origin]] to a node that is, at most, [[distance]] spaces away. This
     method can return an empty sequence, which means no moves are valid for the given parameters."
    shared [Path*] getAllowedMoves(Node origin, Integer distance) {
        variable value paths = LinkedList<MutableList<Node>>();
        
        iterateAllowedMoves(paths, [origin], distance);
        
        for (path in paths) {
            // Remove all paths that end on a WellOrbit node.
            if (path.last is WellOrbit) {
                paths.remove(path);
            }
            else if (path.last is WellPull) {
                // Adjust any paths that end on a WellPull node by adding the source of all the
                // "pulling" to the end of the path.
                value pullingNode = path.reversed.find((Node node) => !(node is WellPull));
                
                assert (exists pullingNode);
                
                path.add(pullingNode);
            }
        }
        
        // Examine, at most, the first two remaining paths.
        paths.truncate(2);
        
        // If we have two paths, find where they branch, then check each resulting subpath for WellOrbit nodes.
        // If a subpath has a WellOrbit node in it, it must be chosen over the other path.
        if (paths.size == 2) {
            value path1 = paths.get(0);
            value path2 = paths.get(1);
            
            assert (exists path1, exists path2);
            
            value branchNodeIndex = findBranchNodeIndex(path1, path2);
            
            if (containsWellOrbit(path1, branchNodeIndex)) {
                paths.deleteLast();
            }
        }
        
        return paths
            // Convert paths to sequences.
            .map((path) => path.sequence())
            // Ensure returned type enforces non-empty paths.
            .narrow<Path>()
            .sequence();
    }
    
    "Returns `true` if the given [[path]] passes the [[start]] node or lands on
     it. Starting from the [[start]] node does not, on its own, count as
     passing it."
    shared Boolean passesStart(Path path) {
        return path.rest.contains(start);
    }
    
    "Performs a depth-first search from the end of the current path over the given distance."
    void iterateAllowedMoves(MutableList<MutableList<Node>> paths, Path currentPath, Integer distance) {
        if (distance == 0) {
            paths.add(LinkedList<Node>(currentPath));
        }
        else {
            for (destination in getDestinations(currentPath.last)) {
                iterateAllowedMoves(paths, currentPath.withTrailing(destination), distance - 1);
            }
        }
    }
    
    Integer findBranchNodeIndex({Node*} path1, {Node*} path2) {
        value iterator1 = path1.iterator();
        value iterator2 = path2.iterator();
        variable value index = 0;
        
        while (true) {
            value node1 = iterator1.next();
            value node2 = iterator2.next();
            
            if (is Finished node1) {
                break;
            }
            else if (node1 != node2) {
                break;
            }
            
            index++;
        }
        
        return index - 1;
    }
    
    Integer calculateDistance(Integer x0, Integer y0, Integer x1, Integer y1) {
        return ((x1 - x0) ^ 2 + (y1 - y0) ^ 2);
    }
    
    Boolean containsWellOrbit({Node*} path, Integer fromIndex) {
        return path
            .skip(fromIndex)
            .any((node) => node is WellOrbit);
    }
}

shared Map<Node, [Node+]> mapNodes({<Node -> Node|[Node+]>+} nodes) {
    return map(nodes.map((node -> destinations)
        => if (is Node destinations) then node -> [destinations] else node -> destinations));
}
