shared abstract class Player(Color color)
    of red | cyan | yellow | magenta | blue | green {}

object red extends Player([255, 0, 0]) {}
object cyan extends Player([0, 255, 255]) {}
object yellow extends Player([255, 255, 0]) {}
object magenta extends Player([255, 0, 255]) {}
object blue extends Player([0, 0, 255]) {}
object green extends Player([0, 255, 0]) {}

shared Map<Player, String> testPlayers = map {
    red -> "Red",
    cyan -> "Cyan",
    yellow -> "Yellow",
    magenta -> "Magenta",
    blue -> "Blue",
    green -> "Green"
};