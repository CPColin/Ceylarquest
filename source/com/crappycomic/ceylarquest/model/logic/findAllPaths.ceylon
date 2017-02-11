import com.crappycomic.ceylarquest.model {
    Board,
    Node,
    Path
}

"Recursively performs a depth-first search on the given [[board]], starting from the given [[head]]
 node and finding paths of the given [[distance]], returning the paths in the order they were found.
 The base case, when the distance is zero, returns a single path, containing the head node.
 
 The returned paths start at the given [[head]] and contain [[distance]] additional nodes.
 
 This code is indirectly covered by tests that use the `BoardTest` class to verify the layout of a
 specific board."
shared {Path+} findAllPaths(Board board, Node head, Integer distance) {
    if (distance <= 0) {
        return {[head]};
    }
    else {
        return {
            for (destination in destinations(board, head))
                for (tail in findAllPaths(board, destination, distance - 1))
                    tail.withLeading(head)
        };
    }
}
