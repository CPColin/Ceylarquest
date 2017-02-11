import com.crappycomic.ceylarquest.model {
    Board,
    Node,
    Path,
    WellOrbit,
    WellPull
}

"Computes and returns each allowed move from the given [[origin]] node over the given [[distance]].
 Each value returned contains the full [[Path]] from the origin to a node that is, at most,
 [[distance]] spaces away. This method can return a single path with just the origin in it, which
 means no moves are valid for the given parameters."
shared [Path+] allowedMoves(Board board, Node origin, Integer distance) {
    // Find all the paths with the given distance.
    value paths = findAllPaths(board, origin, distance);
    // Remove paths that end on a WellOrbit node.
    value filteredPaths = removeWellOrbitPaths(paths);
    // Find branches and the branch point, if any.
    value branchResult = findBranches(filteredPaths.sequence());
    
    if (is Finished branchResult) {
        // We didn't have any paths to begin with, so just return the origin.
        return [[origin]];
    }
    
    value [branches, branchIndex] = branchResult;
    
    assert (nonempty branches);
    
    // Modify paths that end on one or more WellPull nodes before returning them.
    Path[] allowedPaths;
    
    if (branches.size == 1 || containsWellOrbit(branches.first, branchIndex)) {
        // If there's only one path or there's a branch point and the first path contains WellOrbit
        // nodes, return the first path.
        allowedPaths = [branches.first];
    }
    else {
        // Otherwise, all branches are valid, so return all of them.
        allowedPaths = branches;
    }
    
    if (nonempty allowedPaths) {
        return enforceWellPullPaths(allowedPaths);
    }
    else {
        // This probably won't happen, but fail safely, just in case.
        return [[origin]];
    }
}

"Returns `true` if the given [[path]] contains any [[WellOrbit]] nodes between the given
 [[index|fromIndex]] and the end of the path."
shared Boolean containsWellOrbit(Path path, Integer fromIndex) {
    return path
        .skip(fromIndex)
        .any((node) => node is WellOrbit);
}

"Modifies the given [[paths]] to enforce the behavior that [[WellPull]] nodes pull the player back
 to the previous node."
[Path+] enforceWellPullPaths([Path+] paths) {
    return [
        for (path in paths)
            enforceWellPullPath(path)
    ];
}

"Modifies the given [[path]] to enforce the behavior that [[WellPull]] nodes pull the player back to
 the previous node. The resulting path will lead up to the pulling node, then backtrack, in order,
 over the previous nodes until one can be landed upon. The path is assumed to start from a valid
 location."
shared Path enforceWellPullPath(Path path) {
    assert (!path.first is WellPull);
    
    if (path.last is WellPull) {
        value reversePath = path.reversed.rest;
        value endIndex = reversePath.firstIndexWhere((node) => !node is WellPull);
        
        assert (exists endIndex);
        
        return path.append(reversePath[...endIndex]);
    }
    else {
        return path;
    }
}

"Recursively finds among the given [[paths]] the latest index where they branch, starting from the
 given [[index]]. The returned paths will share a common node at the returned index and will share
 no further nodes between there and the end of the path. Returns [[Finished]] when no path remains.
 The paths are assumed to share a common first node and are expected to be all the same length."
shared [Path[], Integer]|Finished findBranches(Path[] paths, Integer index = 0) {
    if (nonempty paths) {
        value result = matchingPaths(paths, index + 1);
        
        if (result.size > 1) {
            return findBranches(result, index + 1);
        }
        else {
            return [paths, index];
        }
    }
    else {
        return finished;
    }
}

"Returns all [[paths]] that share the same node at the given [[index]]. The node must exist in the
 first path given."
shared Path[] matchingPaths([Path+] paths, Integer index) {
    value target = paths[0][index];
    
    if (exists target) {
        return [ for (path in paths) if (exists node = path[index]) if (node == target) path ];
    }
    else {
        return [];
    }
}

"Filters paths that end on a [[WellOrbit]] node from the given stream of [[paths]]."
shared {Path*} removeWellOrbitPaths({Path*} paths) {
    return paths.filter((path) => !path.last is WellOrbit);
}
