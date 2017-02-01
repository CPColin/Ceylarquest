import com.crappycomic.ceylarquest.model {
    Debt,
    Game,
    Player
}

// TODO: need tests
shared Game payRent(Game game, Player player) {
    value node = game.playerLocation(player);
    value rent = rentFee(game, player, node);
    value owner = game.owner(node);
    
    if (rent == 0) {
        return game;
    }
    
    if (is Player owner) {
        return game.with {
            debts = { Debt(player, rent, owner) };
        };
    }
    else {
        // It's not likely an unowned node will cost the player rent.
        return game;
    }
}
