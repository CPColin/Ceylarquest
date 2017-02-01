"Something that can happen when a [[Card]] is drawn."
shared abstract class Action()
        of AdvanceToNode | LoseDisputeWithLeague | NodeAction | RollAgain | RollWithMultiplier
            | UseFuel | WinDisputeWithLeague | WinDisputeWithPlayer {
    shared default Result perform(Game game, Player player) { return game; }
}

"Something that can happen when a [[Node]] is landed on. These actions may not cause the
 [[phase|Game.phase]] of the [[Game]] to change. This includes actions like [[UseFuel]], which may
 knock a player out of the game."
shared abstract class NodeAction()
        of CollectCash | CollectFuelStation
        extends Action() {
    shared formal actual Game perform(Game game, Player player);
}

shared class AdvanceToNode(Node node) extends Action() {}

shared class CollectCash(Integer amount) extends NodeAction() {
    shared actual Game perform(Game game, Player player)
        => game.with { playerCashes = { player -> game.playerCash(player) + amount }; };
}

shared class CollectFuelStation(Integer amount) extends NodeAction() {
    shared actual Game perform(Game game, Player player)
        => game.fuelStationsRemaining > 0
            then game.with {
                playerFuelStationCounts = { player -> game.playerFuelStationCount(player) + 1 };
            }
            else game;
}

shared class LoseDisputeWithLeague() extends Action() {}

shared class RollAgain() extends Action() {}

shared class RollWithMultiplier(Integer multiplier) extends Action() {}

shared class UseFuel(Integer amount) extends Action() {}

shared class WinDisputeWithLeague() extends Action() {}

shared class WinDisputeWithPlayer() extends Action() {}
