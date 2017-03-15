import com.crappycomic.ceylarquest.model {
    Board,
    Path
}

"Returns `true` if the given [[path]] passes the [[start node|Board.start]] of the given [[board]]
 or lands on it. Starting from the start node does not, on its own, count as passing it."
shared Boolean passesStart(Board board, Path path) {
    return path.rest.contains(board.start);
}
