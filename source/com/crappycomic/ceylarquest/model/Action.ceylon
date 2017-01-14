"Something that can happen when a [[Node]] is landed on or a [[Card]] is drawn."
shared abstract class Action()
    of AdvanceToNode | CollectCash | CollectFuelStation | LoseDisputeWithLeague | RollAgain | RollWithMultiplier
        | UseFuel | WinDisputeWithLeague | WinDisputeWithPlayer {}

shared class AdvanceToNode(Node node) extends Action() {}

shared class CollectCash(Integer amount) extends Action() {}

shared class CollectFuelStation(Integer amount) extends Action() {}

shared class LoseDisputeWithLeague() extends Action() {}

shared class RollAgain() extends Action() {}

shared class RollWithMultiplier(Integer multiplier) extends Action() {}

shared class UseFuel(Integer amount) extends Action() {}

shared class WinDisputeWithLeague() extends Action() {}

shared class WinDisputeWithPlayer() extends Action() {}