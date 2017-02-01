import com.crappycomic.ceylarquest.model {
    DeedGroup,
    Game,
    Player
}

"Returns the index that should be used when calculating rent and fuel fees. The index corresponds to
 the number of properties in the given [[group|deedGroup]] that are owned by the given [[player]],
 minus one. It does not make sense to check the fee index for a deed group where no node is owned.
 (Thus, it also does not make sense to check the fee index associated with a node that is not
 owned.)"
shared Integer feeIndex(Game game, Player player, DeedGroup deedGroup) {
    return game.owners.count((node -> owner)
        => node.deedGroup == deedGroup && owner == player) - 1;
}
