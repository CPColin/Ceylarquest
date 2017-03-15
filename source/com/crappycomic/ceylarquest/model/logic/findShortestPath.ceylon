import com.crappycomic.ceylarquest.model {
    Board,
    Node,
    Path
}

shared Path findShortestPath(Board board, Node|[Path+] from, Node to) {
    if (is Node from) {
        if (from == to) {
            // For the special case where from and to are the same, we want the resulting path to
            // look like advancing to the node, as opposed to remaining on it.
            // This is so any NodeAction the node has can fire properly.
            // Without this check, this situation would result in a path that looped around the
            // current orbit or the whole board.
            return [from, to];
        }
        
        return findShortestPath(board, [[from]], to);
    }
    else {
        value paths = [
            for (path in from)
                for (destination in destinations(board, path.last))
                    path.withTrailing(destination)
        ];
        
        if (exists path = from.find((path) => path.last == to)) {
            return path;
        }
        
        return findShortestPath(board, paths, to);
    }
}
