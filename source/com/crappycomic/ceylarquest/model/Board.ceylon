import ceylon.collection {
    HashMap,
    LinkedList
}

shared alias Path => [Node+];

"The game board, a layout of [[Node]]s and their connections to each other."
shared abstract class Board() {
    "Maps [[Node]]s to their one or more destinations, in the order they should be tried."
    shared formal Map<Node, Node|[Node, Node]> nodes;
    
    "Maps [[Node]] ID's to the objects that have them."
    shared Map<String, Node> nodeIds => HashMap { for (node in nodes.keys) node.id -> node };
    
    "The [[Node]] that players start on."
    shared formal Node start;
    
    "The [[Card]]s that players can draw."
    shared formal [Card+] cards;
    
    shared Node? getNode(String id) {
        return nodeIds[id];
    }
    
    shared [Node+] getDestinations(Node node) {
        value destinations = nodes.get(node);
        
        assert(exists destinations);
        
        if (is Node destinations) {
            return [destinations];
        }
        else {
            return destinations;
        }
    }
    
    "Computes and returns each allowed move from the given [[origin]] node over the given [[distance]]. Each value
     returned contains the full [[Path]] from the [[origin]] to a node that is, at most, [[distance]] spaces away. This
     method can return an empty sequence, which means no moves are valid for the given parameters."
    shared [Path*] getAllowedMoves(Node origin, Integer distance) {
        variable value paths = LinkedList<LinkedList<Node>>();
        
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
    void iterateAllowedMoves(LinkedList<LinkedList<Node>> paths, Path currentPath, Integer distance) {
        if (distance == 0) {
            paths.add(LinkedList<Node>(currentPath));
        }
        else {
            for (destination in getDestinations(currentPath.last)) {
                iterateAllowedMoves(paths, currentPath.withTrailing(destination), distance - 1);
            }
        }
    }
    
    Integer findBranchNodeIndex(List<Node> path1, List<Node> path2) {
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
    
    Boolean containsWellOrbit(List<Node> path, Integer fromIndex) {
        return path
            .sublistFrom(fromIndex)
            .any((node) => node is WellOrbit);
    }
}
